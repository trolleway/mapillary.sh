import os
import subprocess
from tqdm import tqdm
import argparse
import re
from PIL import Image, ImageFilter
import piexif

def extract_pto_parameters(file_path):
    # Regex to find 'i' lines and capture the floats after r, p, and y
    # \d+\.\d+ matches decimal numbers, [-+]? handles negative values
    pattern = r"^i\s+.*r([-+]?\d+\.\d+)\s+p([-+]?\d+\.\d+)\s+y([-+]?\d+\.\d+)"
    
    #extracted_data = []
    

    with open(file_path, 'r') as file:
        for line in file:
            # Search for the pattern in each line starting with 'i'
            match = re.search(pattern, line)
            if match:
                # Convert the captured groups into a tuple of floats
                r_val, p_val, y_val = map(float, match.groups())
                #extracted_data.append((r_val, p_val, y_val))
                
    return r_val, p_val, y_val

def compress360(src_file,dst_file,quality=40):

    


    with Image.open(src_file) as img:
        # 1. Extract Metadata
        exif_dict = piexif.load(img.info.get("exif", b""))
        exif_bytes = piexif.dump(exif_dict)

        # 2. Apply Blur to Bottom 200px
        width, height = img.size
        if height > 300:
            # Define the region to blur (left, top, right, bottom)
            box = (0, height - 500, width, height)
            nadir = img.crop(box)
            
            # Apply strong Gaussian blur
            blurred_nadir = nadir.filter(ImageFilter.GaussianBlur(radius=12))
            
            # Paste the blurred section back onto the original
            img.paste(blurred_nadir, box)

        # 3. Save with Compression and Metadata
        img.save(
            dst_file, 
            "JPEG", 
            quality=quality, 
            exif=exif_bytes,
            optimize=True
        )



parser = argparse.ArgumentParser(description="Compress 360 panorama JPEG images from source to destination.")

# Define source directory argument
parser.add_argument(
    "source", 
    type=str, 
    help="Path to the directory containing source JPEG files"
)

# Define destination directory argument
parser.add_argument(
    "destination", 
    type=str, 
    help="Path to the directory where compressed files will be saved"
)
#rotation_group = parser.add_mutually_exclusive_group(required=True)

parser.add_argument(
    "--roll", 
    type=float,
 
    help="roll value"
)
parser.add_argument(
    "--pitch", 
    type=float,  

    help="pitch value"
)
parser.add_argument(
    "--yaw", 
    type=float,  

    help="yaw value"
)

parser.add_argument(
    "--pto", 
    type=str,  

    help="yaw value"
)


args = parser.parse_args()

# --- CONFIGURATION ---
INPUT_DIR = r"d:\2m\2026-03-14-vdnkh\04"
OUTPUT_DIR = r"c:\trolleway\2m\04"
INPUT_DIR = args.source
OUTPUT_DIR = args.destination

NONA_PATH = r"c:\Program Files\Hugin\bin\nona.exe"  # Or full path like 'C:/Program Files/Hugin/bin/nona.exe'
EXIFTOOL_PATH = "exiftool"  # Path to exiftool.exe

if args.roll is not None:
    ROLL = args.roll
    PITCH = args.pitch
    YAW = args.yaw
elif args.pto is not None:
    ROLL,PITCH,YAW = extract_pto_parameters(args.pto)


if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

def rotate_360(input_path, output_path, p, r, y):
    # 1. Create a minimal .pto script for nona
    # p f2: equirectangular projection
    # i: input image parameters (r=roll, p=pitch, y=yaw)
    
    filename = os.path.basename(input_path)
    base_name = os.path.splitext(filename)[0]
    
    # Nona output prefix and the final file it will create
    nona_prefix = os.path.join(output_path, base_name)
    nona_output_file = output_path + ".jpg"
    
    

    
    pto_content = f"""
p f2 w5760 h2880 v360
m g1 i0
i f4 v360 r{r} p{p} y{y} n"{input_path}"
"""
    
    tmp_pto = "temp_rotation.pto"
    with open(tmp_pto, "w") as f:
        f.write(pto_content)

    # 2. Run nona command
    # -m JPEG: output format
    # -o: output filename prefix
    try:
        subprocess.run([NONA_PATH, "-m", "JPEG", "-o", output_path, tmp_pto], check=True)
        #print(f"Processed: {os.path.basename(input_path)}")
        cmd = [
            EXIFTOOL_PATH, 
            "-tagsFromFile", input_path, 
            "-all:all", 
            "-quiet", 
            "-quiet", 
            "-overwrite_original", 
            nona_output_file
        ]
        
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error processing {input_path}: {e}")
    finally:
        if os.path.exists(tmp_pto):
            os.remove(tmp_pto)

# --- EXECUTION ---
files = [f for f in os.listdir(INPUT_DIR) if f.lower().endswith(('.jpg', '.jpeg'))]
for filename in tqdm(files):
    if filename.lower().endswith(('.jpg', '.jpeg', '.png')):
        in_file = os.path.abspath(os.path.join(INPUT_DIR, filename))
        out_file = os.path.join(OUTPUT_DIR, os.path.splitext(filename)[0])
        rotate_360(in_file, out_file, PITCH, ROLL, YAW)
        root, ext = os.path.splitext(out_file)
        new_path = f"{root}_compr{ext}"

        compress360(out_file+'.jpg',new_path+'.jpg')
        os.remove(out_file+'.jpg')