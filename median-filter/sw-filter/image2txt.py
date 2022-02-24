"""
This script extract the pixel values from an image and writes them into a txt file (one txt file per color channel)
"""

import os
from statistics import median
from skimage.io import imread
import cv2
import numpy as np
from skimage.util import view_as_blocks
import sys
# to make simple the analisys --> just use the first n pixels of the image


# print in a file
# print the portion of image
def imwrite_txt(image, x_size, y_size, image_name, txt_file):
    fp = open(txt_file, "w+")
    # writing image sizes
    fp.write("%10d \n" % y_size)
    fp.write("%10d \n" % x_size)

    print("writing", image_name, "into txt")
    for z in range(0, 3):
        for y in range(0, y_size):
            for x in range(0, x_size):
                fp.write("%3d " % image[y, x, z])
        fp.write("\n")

    fp.close()


if len(sys.argv) < 3:  # the correct inputs are not provided
    print("Inputs not found! Please enter:",
          sys.argv[0], "<path-to-image> <output-dir>")
else:
    # filename = os.getcwd() + "/" + str(sys.argv[1])
    filename = str(sys.argv[1])
    # filename = "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/Sample_images/DJI_0002.JPG"
    image_name, file_extension = os.path.splitext(filename)
    print(os.path.basename(filename))
    # exit()
    # READ THE IMAGE
    # READ IMAGE
    # input _rgb is an array
    input_rgb = imread(image_name+".JPG", as_gray=False)
    print(input_rgb.shape)

    # sizes to write
    (y_out_size, x_out_size, z_out_size) = input_rgb.shape
    # (y_out_size, x_out_size, z_out_size) = (10, 10, 3)
    output_dir = str(sys.argv[2])
    imwrite_txt(input_rgb, x_out_size,
                y_out_size, os.path.basename(image_name), output_dir+"/"+os.path.basename(image_name)+".txt")
    # exit()
    # imwrite_txt(input_rgb[:, :, 1], x_out_size,
    #             y_out_size, os.path.basename(image_name), "G", output_dir+"/"+os.path.basename(image_name)+"G.txt")
    # imwrite_txt(input_rgb[:, :, 2], x_out_size,
    #             y_out_size, os.path.basename(image_name), "B", output_dir+"/"+os.path.basename(image_name)+"B.txt")

    # print the portion of image
    # output_file = "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/debugging/py_out_rgb.JPG"
    # cv2.imwrite(output_file, input_rgb[:, :, :: -1])

    # # Step 2 Compute median and print in a file
    kernel_size = 32
    view = view_as_blocks(input_rgb, (kernel_size, kernel_size, 1))
    flatten_view = view.reshape(
        view.shape[0], view.shape[1], view.shape[2], -1)

    median_view = np.median(flatten_view, axis=3)
    print("median_view shape", median_view.shape)
    # print(sorted(flatten_view[1,  0, 0, :]))
    # print(flatten_view[1,  0, 0, :])
    print(median_view[1, 0, 0])
    imwrite_txt(median_view, median_view.shape[1],
                median_view.shape[0], os.path.basename(image_name)+"_median", output_dir+"/"+os.path.basename(image_name)+"_medianpy.txt")
