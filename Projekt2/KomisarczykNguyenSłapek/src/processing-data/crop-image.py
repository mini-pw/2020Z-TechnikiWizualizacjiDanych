import numpy as np
from PIL import Image, ImageDraw

# Open the input image as numpy array, convert to RGB
import os

directory = "../../resources/images"
for filename in os.listdir(directory):
    splitFilename = filename.split(".")
    img = Image.open(directory + "/" + str(filename)).convert("RGB")

    npImage = np.array(img)
    h, w = img.size

    # Create same size alpha layer with circle
    alpha = Image.new('L', img.size, 0)
    draw = ImageDraw.Draw(alpha)
    draw.pieslice([0, 0, h, w], 0, 360, fill=255)

    # Convert alpha Image to numpy array
    npAlpha = np.array(alpha)

    # Add alpha layer to RGB
    npImage = np.dstack((npImage, npAlpha))

    # Save with alpha
    Image.fromarray(npImage).save('../../resources/processed-images/' + splitFilename[0] + ".png")