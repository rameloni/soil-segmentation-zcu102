from statistics import median
import numpy as np
from skimage.util import view_as_blocks

from skimage import filters
from skimage import morphology as morph
from skimage.io import imread
from skimage.color import rgb2hsv, rgb2ycbcr
from skimage.transform import rescale, resize, downscale_local_mean
import matplotlib.pyplot as plt
import cv2
import time
import sys
import os

# this script has the goal to do the otsu segementation on the set of metiated images generated by pseudo_median.c (it is only for testing)


def do_otsu(median_name, file_extension, original_image, output_dir, output_name, med=[[0], [0]],  _med=0):
    if file_extension == '.JPG':
        median_view = imread(median_name, as_gray=False)
        _image_orig = imread(original_image, as_gray=False)
        if (_med != 0):
            median_view = med
        print("medianview shape:", median_view.shape)
        RGB_image = median_view.astype('uint8')
        ycbcr_img = rgb2ycbcr(RGB_image)
        y_img = ycbcr_img[:, :, 0]
        cb_img = ycbcr_img[:, :, 1]
        cr_img = ycbcr_img[:, :, 2]

        image = cr_img.copy()

        val = filters.threshold_otsu(image)
        image = resize(image, (_image_orig.shape[0], _image_orig.shape[1]))
        print(output_name, "otsu val:", val)
        mask_color = image < val

        _image_orig[mask_color, :] = 255

        # print the images
        cv2_image = cv2.cvtColor(_image_orig, cv2.COLOR_RGB2BGR)
        # cv2.imshow("image", cv2.resize(
        #     cv2_image, (0, 0), fx=0.15, fy=0.15))
        cv2_rgb = cv2.cvtColor(_image_orig, cv2.COLOR_RGB2BGR)

        start_time = time.time()

        # output_dir = "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/SOIL_SEGMENTED_IMAGES_byMEDIAN_C"
        # write the output images into the directories
        # remember that file is the name of the image in the output dir
        cv2.imwrite(os.path.join(output_dir,
                    output_name), cv2_rgb)
        # write the mask image in the output dir
        # cv2.imwrite(os.path.join(output_dir, "masked"+file_extension),
        #             mask_color.astype('uint8')*255)
        # print(output_dir)
    return median_view


def imread_txt(image_name):
    # image_fp = open(image_name, "r")
    n_pixels = 0
    rows_count = 0
    row = []
    out = []
    with open(image_name, "rb") as image_fp:
        # read header
        y_size = int(image_fp.read(10).decode('utf-8'))
        image_fp.read(2)
        x_size = int(image_fp.read(10).decode('utf-8'))
        print("x_size", x_size)
        image_fp.read(2)
        while True:
            # print("row")
            pix = image_fp.read(3).decode('utf-8')
            if not pix:
                break
            row.append(pix)
            # image_fp.seek(4, 1)

            c = image_fp.read(1).decode('utf-8')
            c = image_fp.read(1).decode('utf-8')
            if c == '\n':
                # i = 0
                out.append(row)
                row = []
                rows_count += 1
            else:
                image_fp.seek(-1, 1)

            n_pixels += 1
    n_pixels -= 1
    rows_count -= 1
    cols_count = n_pixels // rows_count
    return (out, x_size, y_size)


def create_rgb(R, G, B):
    # where R, G, B are lists
    (_R, _G, _B) = (np.array(R), np.array(G), np.array(B))
    print("R.shape", _R.shape)
    print("G.shape", _G.shape)
    print("B.shape", _B.shape)
    if _R.shape == _G.shape and _G.shape == _B.shape:
        rgb_image = np.zeros((_R.shape[0], _R.shape[1], 3))
        print("fill rgb")
        for y in range(0, _R.shape[0]):
            for x in range(0, _R.shape[1]):
                rgb_image[y, x, 0] = _R[y, x]
                rgb_image[y, x, 1] = _G[y, x]
                rgb_image[y, x, 2] = _B[y, x]
        return rgb_image

    # return -1


root = '/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/'  # root directory
set_orig = 'Sample_images'
set_median = 'Sample_images_MEDIAN_C'

filenames_orig = os.listdir(os.path.join(root, set_orig))

# for file in filenames_median:
#     filename_orig = os.path.join(os.path.join(root, set_orig), file)
#     filename_median = os.path.join(os.path.join(root, set_median), file)
#     _, file_extension = os.path.splitext(filename_median)

#     do_otsu(filename_median, file_extension, filename_orig, soil_seg_dir, file)


# Use the C median image
filename_orig = "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/Sample_images/DJI_0003.JPG"
output_dir = "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/sw-filter/sample-img-txt"
# c_median_view = do_otsu(c_img_path, ".JPG", filename_orig,
#                         output_dir, "c_segmented.JPG")

# Use the python median image

image_name, file_extension = os.path.splitext(filename_orig)
# input _rgb is an array
input_rgb = imread(image_name+".JPG", as_gray=False)
print(input_rgb.shape)

# Step 2 Compute median and print in a file
kernel_size = 32
view = view_as_blocks(input_rgb, (kernel_size, kernel_size, 1))
flatten_view = view.reshape(view.shape[0], view.shape[1], view.shape[2], -1)

median_view = np.median(flatten_view, axis=3)
py_median_view = do_otsu(filename_orig, ".JPG", filename_orig,
                         output_dir, "py_segmented.JPG", med=median_view, _med=1)


print("Reading txt image")
(RGB, x, y) = imread_txt(
    "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/sw-filter/sample-img-txt/DJI_0003_medianc.txt")
# print(np.array(RGB))
print("RGB shape", np.array(RGB).shape)
print(x, y)
(R, G, B) = np.array((RGB[0], RGB[1], RGB[2]))

median_view = np.zeros((y, x, 3))
for i in range(0, y):
    for j in range(0, x):
        median_view[i, j, 0] = R[j + i*x]
        median_view[i, j, 1] = G[j+i*x]
        median_view[i, j, 2] = B[j + i*x]
        # R = imread_txt(
        #     "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/debugging/c_1st_channel_median.txt")

        # print("Reading txt G channel")
        # G = imread_txt(
        #     "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/debugging/c_2nd_channel_median.txt")

        # print("Reading txt B channel")
        # B = imread_txt(
        #     "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/debugging/c_3rd_channel_median.txt")
        # # print("x shape", x)
print("create rgb")
# print(median_view)
print(R)
print(B)
# median_view = create_rgb(R, G, B)
if(np.array_equal(median_view, py_median_view)):
    print("C and python median_views are equal")

# if median_view != -1:
print("OTSU....")
c_txt_segmented = do_otsu(filename_orig, ".JPG", filename_orig,
                          output_dir, "c_segmented_txt.JPG", med=median_view, _med=1)