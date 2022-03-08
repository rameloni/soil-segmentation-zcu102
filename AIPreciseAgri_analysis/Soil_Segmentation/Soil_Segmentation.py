
import os
import numpy as np
import matplotlib.pyplot as plt
from skimage import data
from skimage import filters
from skimage import exposure
from skimage.io import imread
from skimage.util import view_as_blocks
from skimage.color import rgb2hsv, rgb2ycbcr
from skimage.transform import rescale, resize, downscale_local_mean
import cv2

import time  # for timing report


def elapsed_and_print(start_time, end_time, msg):
    print('|', f'{msg:{" "}{"<"}{25}}', '|',
          f'{"{:.2f}".format((end_time-start_time)*1000) + " ms":{" "}{"<"}{15}}', '|',
          f'{"{:.0f}".format((end_time-start_time)*1000000) + " μs":{" "}{"<"}{15}}', '|')
    return end_time - start_time


def print_header(title):
    w = len(title) + 4
    print(f'{"":{"*"}{"<"}{w}}')
    print(f'{"*":{" "}{"<"}{w-1}}' + '*')

    print("*", title, "*")

    print(f'{"*":{" "}{"<"}{w-1}}' + '*')
    print(f'{"":{"*"}{"<"}{w}}')


print_header("Starting program")
start_time = time.time()
root = '/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/'  # root directory

rootsroot = root + '..'
# print(rootsroot)

set = 'Sample_images'   # set images directory

# segmented images output dir name
soil_seg_dir = 'SOIL_SEGMENTED_IMAGES'
# segmented masks output dir name
soil_seg_masks_dir = 'SOIL_SEGMENTED_MASKS'

# segmented images output dir PATH name
seg_images_full_dir = os.path.join(root, soil_seg_dir)
# segmented masks output dir PATH name
seg_masks_full_dir = os.path.join(root, soil_seg_masks_dir)

# if the segmented output directories don't exist --> create them
if not os.path.exists(seg_images_full_dir):
    os.makedirs(seg_images_full_dir)
if not os.path.exists(seg_masks_full_dir):
    os.makedirs(seg_masks_full_dir)

filenames = os.listdir(os.path.join(root, set))
end_time = time.time()
elapsed_and_print(start_time, end_time, "Time:")

print_header("Opening " + set + " dir")

# list of times in seconds
times = {'Divide and flatten': [],
         'Mean filter': [],
         'Max filter': [],
         'Median filter': [],
         'rgb2ycbcr color space': [],
         'Otsu threshold': [],
         'Resize image': [],
         'Mask': [],
         'Masked image': [],
         'Writing images': [],
         'Total time elapsed': []}


for file in filenames:
    filename = os.path.join(os.path.join(root, set), file)
    # make sure that filename isn't a directory but rather a file
    if not os.path.isdir(filename):
        start_tot_time = time.time()
        # split extension
        # '_' is the path and 'file_extension' is the extension of the file
        _, file_extension = os.path.splitext(filename)
        print_header(file)
        # print(file_extension)

        if file_extension == '.JPG':
            # if the file is a JPG image apply the otsu segmentation
            # print(filename)
            _image = imread(filename, as_gray=False)
            _image_ = _image.copy()

            start_time = time.time()
            # print(_image.shape)
            # size of blocks
            block_shape = (32, 32, 1)

            # see astronaut as a matrix of blocks (of shape block_shape)
            view = view_as_blocks(_image, block_shape)

            # collapse the last two dimensions in one
            flatten_view = view.reshape(
                view.shape[0], view.shape[1], view.shape[2], -1)
            end_time = time.time()

            times['Divide and flatten'].append(elapsed_and_print(
                start_time, end_time, "Divide and flatten:"))
            # print(times)

            start_time = time.time()
            mean_view = np.mean(flatten_view, axis=3)
            end_time = time.time()
            times['Mean filter'].append(elapsed_and_print(
                start_time, end_time, "Mean filter:"))

            start_time = time.time()
            max_view = np.max(flatten_view, axis=3)
            end_time = time.time()
            times['Max filter'].append(elapsed_and_print(
                start_time, end_time, "Max filter:"))

            start_time = time.time()
            median_view = np.median(flatten_view, axis=3)
            end_time = time.time()
            times['Median filter'].append(elapsed_and_print(
                start_time, end_time, "Median filter:"))

            start_time = time.time()
            RGB_image = median_view.astype('uint8')
            ycbcr_img = rgb2ycbcr(RGB_image)
            y_img = ycbcr_img[:, :, 0]
            cb_img = ycbcr_img[:, :, 1]
            cr_img = ycbcr_img[:, :, 2]
            end_time = time.time()
            times['rgb2ycbcr color space'].append(elapsed_and_print(
                start_time, end_time, "rgb2ycbcr color space:"))

            image = cr_img.copy()
            # image = exposure.equalize_hist(image)

            # hsv_img = rgb2hsv(RGB_image)
            # hue_img = hsv_img[:, :, 0]
            # sat_img = hsv_img[:, :, 1]
            # value_img = hsv_img[:, :, 2]

            # image = value_img.copy()

            start_time = time.time()
            # Threshold value based on Otsu's method
            val = filters.threshold_otsu(image)
            end_time = time.time()
            times['Otsu threshold'].append(elapsed_and_print(
                start_time, end_time, "Otsu Threshold:"))

            # resize the flattened image to match the original size
            start_time = time.time()
            image = resize(image, (_image_.shape[0], _image_.shape[1]))
            end_time = time.time()
            times['Resize image'].append(elapsed_and_print(
                start_time, end_time, "Resize image:"))

            start_time = time.time()
            mask_color = image < val
            mask = image < val
            end_time = time.time()
            times['Mask'].append(elapsed_and_print(
                start_time, end_time, "Mask:"))

            start_time = time.time()
            # set the pixels masked to 255
            _image_[mask_color, :] = 255
            end_time = time.time()
            times['Masked image'].append(elapsed_and_print(
                start_time, end_time, "Masked image:"))

            end_tot_time = time.time()
            times['Total time elapsed'].append(elapsed_and_print(
                start_tot_time, end_tot_time, "'Total time elapsed':"))

            # print the images
            cv2_image = cv2.cvtColor(_image, cv2.COLOR_RGB2BGR)
            # cv2.imshow("image", cv2.resize(
            #     cv2_image, (0, 0), fx=0.15, fy=0.15))

            cv2_rgb = cv2.cvtColor(_image_, cv2.COLOR_RGB2BGR)
            cv2.imshow("mask", cv2.resize(cv2_rgb,
                       (0, 0), fx=0.15, fy=0.15))

            cv2.waitKey(20)

            start_time = time.time()
            # write the output images into the directories
            # remember that file is the name of the image in the output dir
            cv2.imwrite(os.path.join(seg_images_full_dir, file), cv2_rgb)
            # write the mask image in the output dir
            cv2.imwrite(os.path.join(seg_masks_full_dir, file),
                        mask_color.astype('uint8')*255)
            end_time = time.time()
            times['Writing images'].append(elapsed_and_print(
                start_time, end_time, "Writing images:"))


# print the average elapsed times for each code snippet
print_header("Compute average elapsed times")
print("| Code                      | Latency (ms)    | Latency (ms)    |")
print("| ------------------------- | --------------- | --------------- |")

for key, value in times.items():
    elapsed_and_print(0, sum(value)/len(value), key)
    # print()

cv2.destroyAllWindows()
