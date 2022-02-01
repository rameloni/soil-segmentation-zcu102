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
# filename = '/home/amirhosein/Desktop/SASSARI_PROJ/RGB_06-09-2018/DJI_0011.JPG'
filename = '/home/amirhosein/Desktop/SASSARI_PROJ/RGB_12-12-2018/DJI_0011.JPG'
# image = imread(filename, as_gray=True)
image = imread(filename, as_gray=False)
# l = color.rgb2gray(data.astronaut())

# image_rescaled = rescale(image, 0.25, anti_aliasing=True)
# image_resized = resize(image, (image.shape[0] // 4, image.shape[1] // 4),
#                        anti_aliasing=True)
# image_downscaled = downscale_local_mean(image, (4, 4))

# size of blocks
block_shape = (32, 32, 1)

# see astronaut as a matrix of blocks (of shape block_shape)
view = view_as_blocks(image, block_shape)

# collapse the last two dimensions in one
flatten_view = view.reshape(view.shape[0], view.shape[1], view.shape[2], -1)
# flatten_view = view.reshape(view.shape[0], view.shape[1], -1)

# resampling the image by taking either the `mean`,
# the `max` or the `median` value of each blocks.
mean_view = np.mean(flatten_view, axis=3)
max_view = np.max(flatten_view, axis=3)
median_view = np.median(flatten_view, axis=3)
# mean_view = np.mean(flatten_view, axis=2)
# max_view = np.max(flatten_view, axis=2)
# median_view = np.median(flatten_view, axis=2)

# display resampled images
# fig, axes = plt.subplots(2, 4, figsize=(8, 8), sharex=True, sharey=True)
# fig, axes = plt.subplots(nrows=1, ncols=4)
# ax = axes.ravel()

# l_resized = ndi.zoom(l, 2)
# ax[0].imshow(l_resized, extent=(-0.5, 128.5, 128.5, -0.5), cmap=cm.Greys_r)
# ax[0].imshow(l_resized, cmap=cm.Greys_r)
# ax[0].set_title("Original image")
# ax[0].imshow(image, cmap=cm.Greys_r)
# ax[0].set_title("Original image")
# ax[0].imshow(image)

# ax[1].set_title("Block view with\n local mean pooling")
# ax[1].imshow(mean_view, cmap=cm.Greys_r)
# ax[1].set_title("Block view with\n local mean pooling")
# ax[1].imshow(mean_view.astype('uint8'))

# ax[2].set_title("Block view with\n local max pooling")
# ax[2].imshow(max_view, cmap=cm.Greys_r)
# ax[2].set_title("Block view with\n local max pooling")
# ax[2].imshow(max_view.astype('uint8'))

# ax[3].set_title("Block view with\n local median pooling")
# ax[3].imshow(median_view, cmap=cm.Greys_r)
# ax[3].set_title("Block view with\n local median pooling")
# ax[3].imshow(median_view.astype('uint8'))

# ax[4].imshow(image, cmap='gray')
# ax[4].set_title("Original image")

# ax[5].imshow(image_rescaled, cmap='gray')
# ax[5].set_title("Rescaled image (aliasing)")

# ax[6].imshow(image_resized, cmap='gray')
# ax[6].set_title("Resized image (aliasing)")

# ax[7].imshow(image_downscaled, cmap='gray')
# ax[7].set_title("Downscaled image (no aliasing)")
RGB_image = median_view.astype('uint8')
hsv_img = rgb2hsv(RGB_image)
hue_img = hsv_img[:, :, 0]
sat_img = hsv_img[:, :, 1]
value_img = hsv_img[:, :, 2]

fig, (ax0, ax1, ax2, ax3) = plt.subplots(ncols=4, figsize=(8, 3))

ax0.imshow(hue_img, cmap='hsv')
ax0.set_title("Hue channel")
ax0.axis('off')
ax1.imshow(sat_img)
ax1.set_title("Saturation channel")
ax1.axis('off')
ax2.imshow(value_img, cmap='hsv')
ax2.set_title("Value channel")
ax2.axis('off')
ax3.imshow(RGB_image, cmap='hsv')
ax3.set_title("RGB median")
ax3.axis('off')

fig.tight_layout()


# for a in ax:
#     a.set_axis_off()

fig.tight_layout()
plt.show()
