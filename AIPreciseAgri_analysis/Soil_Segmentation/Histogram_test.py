# ===============================================================

import numpy as np
from scipy import ndimage as ndi
from matplotlib import pyplot as plt
import matplotlib.cm as cm

from skimage import data
from skimage import color
from skimage.transform import rescale, resize, downscale_local_mean
from skimage.util import view_as_blocks
from skimage.io import imread
from skimage.color import rgb2hsv
import matplotlib
import matplotlib.pyplot as plt
import numpy as np

from skimage import img_as_float
from skimage import exposure


matplotlib.rcParams['font.size'] = 8


def plot_img_and_hist(image, axes, bins=256):
    # this function plot the image and the histogram of the image

    # axes should be 2x1 array
    # print(axes)
    image = img_as_float(image)
    ax_img, ax_hist = axes
    # Create a twin Axes sharing the xaxis. cdf and histogram in the same place
    ax_cdf = ax_hist.twinx()
    # print(ax_cdf)
    # print()
    # Display image
    ax_img.imshow(image, cmap=plt.cm.gray)
    ax_img.set_axis_off()
    print("Image shape:", image.shape)
    print("Image flattened shape: ", image.ravel().shape, " ",
          image.shape[0], "*", image.shape[1], "=", image.shape[0]*image.shape[1])

    # Display histogram
    # image.ravel() returns a flattened array
    # plot an histogram from image.ravel(), divided into bins, step histogram type, colour black
    ax_hist.hist(image.ravel(), bins=bins, histtype='step', color='black')
    # configure the scalar format of the axes, scilimits=(0,0) includes all numbers. Scilimits Scientific notation is used only for numbers outside the range 10m to 10n (and only if the formatter is configured to use scientific notation at all).
    ax_hist.ticklabel_format(axis='y', style='scientific', scilimits=(0, 0))
    ax_hist.set_xlabel('Pixel intensity')
    ax_hist.set_xlim(0, 1)
    ax_hist.set_yticks([])

    # Display cumulative distribution
    img_cdf, bins = exposure.cumulative_distribution(image, bins)
    ax_cdf.plot(bins, img_cdf, 'lime')
    ax_cdf.set_yticks([])
    print()
    return ax_img, ax_hist, ax_cdf


# Load an example image

path = '/home/raffaele/borsa-ricerca/AIPreciseAgri-master/'
filename = path + 'Sample_images/DJI_0002.JPG'  # image filename
image = imread(filename, as_gray=False)  # open the image read

# size of blocks
block_shape = (32, 32, 1)

# see astronaut as a matrix of blocks (of shape block_shape)
view = view_as_blocks(image, block_shape)

# collapse the last two dimensions in one
flatten_view = view.reshape(view.shape[0], view.shape[1], view.shape[2], -1)

mean_view = np.mean(flatten_view, axis=3)
max_view = np.max(flatten_view, axis=3)
median_view = np.median(flatten_view, axis=3)

# using the median view
RGB_image = median_view.astype('uint8')
hsv_img = rgb2hsv(RGB_image)
hue_img = hsv_img[:, :, 0]
sat_img = hsv_img[:, :, 1]
value_img = hsv_img[:, :, 2]

# Low contrast image
img = value_img  # value_img becaus the contrast works fine on brightness
# img = RGB_image

# Contrast stretching
# print(img)
p2, p98 = np.percentile(img, (2, 98))
# print("p2 = ", p2, "; p98 = ", p98)
img_rescale = exposure.rescale_intensity(img, in_range=(p2, p98))

# Equalization
img_eq = exposure.equalize_hist(img)

# Adaptive Equalization
img_adapteq = exposure.equalize_adapthist(img, clip_limit=0.03)


# Display results
fig = plt.figure(figsize=(8, 5))    # create a figure
# axes = np.zeros((2, 4), dtype=np.object)  # return an array 2x4 of zeros
axes = np.zeros((2, 4), dtype=object)  # return an array 2x4 of zeros
# adding a subplot of 2 rows, 4 columns at index 1
# index must be 1<=index<=8, it can never be greater than 8
axes[0, 0] = fig.add_subplot(2, 4, 1)
# print(axes)

# adding the spaces for the first row
for i in range(1, 4):
    axes[0, i] = fig.add_subplot(
        2, 4, 1+i, sharex=axes[0, 0], sharey=axes[0, 0])  # sharex and sharey - share the x and y axes

# adding the subplots for the second row
for i in range(0, 4):
    axes[1, i] = fig.add_subplot(2, 4, 5+i)

# plotting all images and histograms

# Plot low contrast image
ax_img, ax_hist, ax_cdf = plot_img_and_hist(img, axes[:, 0], bins=20)
ax_img.set_title('Low contrast image')

y_min, y_max = ax_hist.get_ylim()
ax_hist.set_ylabel('Number of pixels')
ax_hist.set_yticks(np.linspace(0, y_max, 5))

ax_img, ax_hist, ax_cdf = plot_img_and_hist(img_rescale, axes[:, 1])
ax_img.set_title('Contrast stretching')

ax_img, ax_hist, ax_cdf = plot_img_and_hist(img_eq, axes[:, 2])
ax_img.set_title('Histogram equalization')

ax_img, ax_hist, ax_cdf = plot_img_and_hist(img_adapteq, axes[:, 3])
ax_img.set_title('Adaptive equalization')

ax_cdf.set_ylabel('Fraction of total intensity')
ax_cdf.set_yticks(np.linspace(0, 1, 5))

# prevent overlap of y-axis labels
fig.tight_layout()
plt.show()


# ===============================================================
