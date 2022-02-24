# STEP 1:  print the image in a known format (e.g. rgb-rgb-rgb.....)
"""Evaluation of imread from skimage.io.
Returns img_array: ndarray
    The different color bands/channels are stored in the third dimension, such that a gray-image is MxN, an RGB-image MxNx3 and an RGBA-image MxNx4.

"""
import os
from statistics import median
from skimage.io import imread
import cv2
import numpy as np
from skimage.util import view_as_blocks

# to make simple the analisys --> just use the first n pixels of the image


# print in a file
# print the portion of image


# READ THE IMAGE
# READ IMAGE and KERNEL SIZE
# if len(sys.argv) <= 3:  # the correct inputs are not provided
#     print("Inputs not found! Please enter:",
#           sys.argv[0], "<path-to-image> x_kernel_size y_kernel_size")

# # filename = os.getcwd() + "/" + str(sys.argv[1])
# filename = str(sys.argv[1])

filename = "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/Sample_images/DJI_0002.JPG"

image_name, file_extension = os.path.splitext(filename)
# input _rgb is an array
input_rgb = imread(image_name+".JPG", as_gray=False)
print(input_rgb.shape)
# to make simple the analisys --> just use the first n pixels of the image

# print first channel --> Is this channel R? Or is it G or B?
# fp = open("py_1st_channel.txt", "w")
n = 3648
(y_out_size, x_out_size, z_out_size) = input_rgb.shape
# (y_out_size, x_out_size, z_out_size) = (10, 10, 3)
print("1st channel: ")

fp = open("py_1st_channel.txt", "w+")
print("writing R channel into txt")
for y in range(0, y_out_size):
    for x in range(0, x_out_size):
        fp.write("%3d " % input_rgb[y, x, 0])
    fp.write("\n")

fp.close()
print("writing G channel into txt")
fp = open("py_2nd_channel.txt", "w+")
for y in range(0, y_out_size):
    for x in range(0, x_out_size):
        fp.write("%3d " % input_rgb[y, x, 1])
    fp.write("\n")

fp.close()
print("writing B channel into txt")
fp = open("py_3rd_channel.txt", "w+")
for y in range(0, y_out_size):
    for x in range(0, x_out_size):
        fp.write("%3d " % input_rgb[y, x, 2])
    fp.write("\n")

fp.close()

# print the portion of image
output_file = "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/debugging/py_out_rgb.JPG"
cv2.imwrite(output_file, input_rgb[:, :, :: -1])


# Step 2 Compute median and print in a file
kernel_size = 32
view = view_as_blocks(input_rgb, (kernel_size, kernel_size, 1))
flatten_view = view.reshape(view.shape[0], view.shape[1], view.shape[2], -1)

median_view = np.median(flatten_view, axis=3)
print("median_view shape", median_view.shape)
print(sorted(flatten_view[1,  0, 0, :]))
print(flatten_view[1,  0, 0, :])
print(median_view[1, 0, 0])
fp = open("py_1st_channel_median.txt", "w+")
for y in range(0, median_view.shape[0]):
    for x in range(0, median_view.shape[1]):
        fp.write("%3d " % median_view[y, x, 0])
    fp.write("\n")
