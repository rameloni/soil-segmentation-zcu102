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
from skimage import measure
from skimage.filters import gaussian


matplotlib.rcParams['font.size'] = 8


def plot_img_and_hist(image, axes, bins=256):
    # this function plot the image and the histogram of the image
    # it is the same of Histogram_test.py

    image = img_as_float(image)
    ax_img, ax_hist = axes
    ax_cdf = ax_hist.twinx()

    # Display image
    ax_img.imshow(image, cmap=plt.cm.gray)
    ax_img.set_axis_off()

    # Display histogram
    ax_hist.hist(image.ravel(), bins=bins, histtype='step', color='black')
    ax_hist.ticklabel_format(axis='y', style='scientific', scilimits=(0, 0))
    ax_hist.set_xlabel('Pixel intensity')
    ax_hist.set_xlim(0, 1)
    ax_hist.set_yticks([])

    # Display cumulative distribution
    img_cdf, bins = exposure.cumulative_distribution(image, bins)
    ax_cdf.plot(bins, img_cdf, 'lime')
    ax_cdf.set_yticks([])

    return ax_img, ax_hist, ax_cdf


# Load an example image

path = '/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/'
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

# using the median view and convert to hsv color profile
RGB_image = median_view.astype('uint8')
hsv_img = rgb2hsv(RGB_image)
hue_img = hsv_img[:, :, 0]
sat_img = hsv_img[:, :, 1]
value_img = hsv_img[:, :, 2]

img = sat_img   # ecìxtract the saturation values

# Contrast stretching
p2, p98 = np.percentile(img, (2, 98))
img_rescale = exposure.rescale_intensity(img, in_range=(p2, p98))

# Equalization
img_eq = exposure.equalize_hist(img)

# Adaptive Equalization
img_adapteq = exposure.equalize_adapthist(img, clip_limit=0.03)

# Display results
fig = plt.figure(figsize=(10, 5))
axes = np.zeros((2, 4), dtype=object)
axes[0, 0] = fig.add_subplot(2, 4, 1)
for i in range(1, 4):
    axes[0, i] = fig.add_subplot(
        2, 4, 1+i, sharex=axes[0, 0], sharey=axes[0, 0])
for i in range(0, 4):
    axes[1, i] = fig.add_subplot(2, 4, 5+i)

ax_img, ax_hist, ax_cdf = plot_img_and_hist(img, axes[:, 0])
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
# plt.show()

# ===============================================================

img = gaussian(img_rescale, 3)

# Find contours at a constant value of 0.8
contours = measure.find_contours(img, 0.8)

# Display the image and plot all contours found
fig, ax = plt.subplots()
ax.imshow(img, cmap=plt.cm.gray)

for contour in contours:
    # plot y versus x as lines
    ax.plot(contour[:, 1], contour[:, 0], linewidth=2)

ax.axis('image')
ax.set_xticks([])
ax.set_yticks([])
plt.show()
