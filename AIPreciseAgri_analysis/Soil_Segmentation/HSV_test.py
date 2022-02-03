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


# get astronaut from skimage.data in grayscale
path = '/home/raffaele/borsa-ricerca/AIPreciseAgri-master/'
filename = path + 'Sample_images/DJI_0002.JPG'
image = imread(filename, as_gray=False)
# image = imread(filename, as_gray=True)

'''
# image_rescaled = rescale(image, 0.25, anti_aliasing=True)
# image_resized = resize(image, (image.shape[0] // 4, image.shape[1] // 4),
#                        anti_aliasing=True)
# image_downscaled = downscale_local_mean(image, (4, 4))
'''

# size of blocks
block_shape = (32, 32, 1)

# see astronaut as a matrix of blocks (of shape block_shape)
view = view_as_blocks(image, block_shape)

# collapse the last two dimensions in one
flatten_view = view.reshape(
    view.shape[0], view.shape[1], view.shape[2], -1)  # -1 one shape dimension

# resampling the image by taking either the `mean`,
# the `max` or the `median` value of each blocks.
mean_view = np.mean(flatten_view, axis=3)
max_view = np.max(flatten_view, axis=3)
median_view = np.median(flatten_view, axis=3)

rgb_view = [[median_view, "median"],
            [max_view, "max"],
            [mean_view, "mean"]]

'''Plotting in HSV color profile'''
for rgb_i in rgb_view:

    RGB_image = rgb_i[0].astype('uint8')    # get the image
    hsv_img = rgb2hsv(RGB_image)
    hue_img = hsv_img[:, :, 0]
    sat_img = hsv_img[:, :, 1]
    value_img = hsv_img[:, :, 2]

    fig, (ax0, ax1, ax2, ax3) = plt.subplots(ncols=4, figsize=(8, 3))
    fig.suptitle('HSV color profile')

    ax0.imshow(hue_img, cmap='hsv')
    ax0.set_title("Hue channel")
    ax0.axis('off')
    ax1.imshow(sat_img,  cmap='hsv')
    ax1.set_title("Saturation channel")
    ax1.axis('off')
    ax2.imshow(value_img, cmap='hsv')
    ax2.set_title("Value channel")
    ax2.axis('off')
    ax3.imshow(RGB_image, cmap='hsv')
    ax3.set_title("RGB " + rgb_i[1])
    ax3.axis('off')

    fig.tight_layout()

plt.show()
