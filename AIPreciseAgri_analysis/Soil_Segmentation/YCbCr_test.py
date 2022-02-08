"""
============================
Block views on images/arrays
============================

This example illustrates the use of ``view_as_blocks`` from
:py:func:`skimage.util`.  Block views can be incredibly useful when one
wants to perform local operations on non-overlapping image patches.

We use ``astronaut`` from ``skimage.data`` and virtually 'slice' it into square
blocks.  Then, on each block, we either pool the mean, the max or the
median value of that block. The results are displayed altogether, along
with a spline interpolation of order 3 rescaling of the original `astronaut`
image.

"""
from cv2 import imshow
import numpy as np
from scipy import ndimage as ndi
from matplotlib import pyplot as plt
import matplotlib.cm as cm

from skimage import data
from skimage import color
from skimage.transform import rescale, resize, downscale_local_mean
from skimage.util import view_as_blocks
from skimage.io import imread
from skimage.color import rgb2hsv, rgb2ycbcr

import time

'''
    Starts the script
'''
# get astronaut from skimage.data in grayscale

path = '/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/'
filename = path + 'Sample_images/DJI_0002.JPG'  # image filename
image = imread(filename, as_gray=False)  # open the image read

# image = imread(filename, as_gray=True)

'''
# image_rescaled = rescale(image, 0.25, anti_aliasing=True)
# image_resized = resize(image, (image.shape[0] // 4, image.shape[1] // 4),
#                        anti_aliasing=True)
# image_downscaled = downscale_local_mean(image, (4, 4))
'''

# launching the algorithm
start_time = time.time()

# size of blocks
block_shape = (32, 32, 1)
# block_shape = (32, 32)

# see astronaut as a matrix of blocks (of shape block_shape)   arr_out view_as_blocks(arr_in, block_shape)
view = view_as_blocks(image, block_shape)

# collapse the last two dimensions in one
flatten_view = view.reshape(
    view.shape[0], view.shape[1], view.shape[2], -1)  # -1 one shape dimension


# resampling the image by taking either the `mean`,
# the `max` or the `median` value of each blocks.
s = time.time()
mean_view = np.mean(flatten_view, axis=3)
print("mean_view.shape = ", mean_view.shape)
e = time.time()
print(e-s)
# print("mean_view = ", mean_view)

max_view = np.max(flatten_view, axis=3)
print("max_view.shape = ", max_view.shape)
# print("max_view = ", max_view)
s = time.time()
median_view = np.median(flatten_view, axis=3)
print("median_view.shape = ", median_view.shape)
e = time.time()
print(e-s)
# print("median_view = ", median_view)
print()

rgb_view = [[median_view, "median"],
            [max_view, "max"],
            [mean_view, "mean"]]


# Plotting the YCbCr color profile
for rgb_i in rgb_view:
    # RGB_image = median_view.astype('uint8')
    RGB_image = rgb_i[0].astype('uint8')    # get the image
    ycbcr_img = rgb2ycbcr(RGB_image)
    # hsv_img = rgb2hsv(RGB_image)
    y_img = ycbcr_img[:, :, 0]
    cb_img = ycbcr_img[:, :, 1]
    cr_img = ycbcr_img[:, :, 2]

    fig, (ax0, ax1, ax2, ax3) = plt.subplots(ncols=4, figsize=(8, 3))
    fig.suptitle('YCbCr color profile')

    ax0.imshow(y_img)
    ax0.set_title("Y channel")
    ax0.axis('off')
    ax1.imshow(cb_img)
    ax1.set_title("Cb channel")
    ax1.axis('off')
    ax2.imshow(cr_img)
    ax2.set_title("Cr channel")
    ax2.axis('off')
    ax3.imshow(RGB_image)
    ax3.set_title("RGB " + rgb_i[1])
    ax3.axis('off')

    fig.tight_layout()


end_time = time.time()


print("Block shape = ", block_shape)
print("Image.shape = ", image.shape)
print("Block shape = ", block_shape)
print("View.shape", view.shape)
print("Flatten_view.shape", flatten_view.shape)
print("Total time:", end_time - start_time)

plt.show()
