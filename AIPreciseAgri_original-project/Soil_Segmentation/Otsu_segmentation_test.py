
# import numpy as np
# from scipy import ndimage as ndi
# from matplotlib import pyplot as plt
# import matplotlib.cm as cm

# from skimage import data
# from skimage import color
# from skimage.transform import rescale, resize, downscale_local_mean
# from skimage.util import view_as_blocks
# from skimage.io import imread
# from skimage.color import rgb2hsv, rgb2ycbcr


# # get astronaut from skimage.data in grayscale
# # filename = '/home/amirhosein/Desktop/SASSARI_PROJ/RGB_06-09-2018/DJI_0011.JPG'
# filename = '/home/amirhosein/Desktop/SASSARI_PROJ/RGB_12-12-2018/DJI_0011.JPG'
# # image = imread(filename, as_gray=True)
# image = imread(filename, as_gray=False)
# # l = color.rgb2gray(data.astronaut())

# # image_rescaled = rescale(image, 0.25, anti_aliasing=True)
# # image_resized = resize(image, (image.shape[0] // 4, image.shape[1] // 4),
# #                        anti_aliasing=True)
# # image_downscaled = downscale_local_mean(image, (4, 4))

# # size of blocks
# block_shape = (32, 32, 1)

# # see astronaut as a matrix of blocks (of shape block_shape)
# view = view_as_blocks(image, block_shape)

# # collapse the last two dimensions in one
# flatten_view = view.reshape(view.shape[0], view.shape[1], view.shape[2], -1)
# # flatten_view = view.reshape(view.shape[0], view.shape[1], -1)

# # resampling the image by taking either the `mean`,
# # the `max` or the `median` value of each blocks.
# mean_view = np.mean(flatten_view, axis=3)
# max_view = np.max(flatten_view, axis=3)
# median_view = np.median(flatten_view, axis=3)
# # mean_view = np.mean(flatten_view, axis=2)
# # max_view = np.max(flatten_view, axis=2)
# # median_view = np.median(flatten_view, axis=2)

# # display resampled images
# # fig, axes = plt.subplots(2, 4, figsize=(8, 8), sharex=True, sharey=True)
# # fig, axes = plt.subplots(nrows=1, ncols=4)
# # ax = axes.ravel()

# # l_resized = ndi.zoom(l, 2)
# # ax[0].imshow(l_resized, extent=(-0.5, 128.5, 128.5, -0.5), cmap=cm.Greys_r)
# # ax[0].imshow(l_resized, cmap=cm.Greys_r)
# # ax[0].set_title("Original image")
# # ax[0].imshow(image, cmap=cm.Greys_r)
# # ax[0].set_title("Original image")
# # ax[0].imshow(image)

# # ax[1].set_title("Block view with\n local mean pooling")
# # ax[1].imshow(mean_view, cmap=cm.Greys_r)
# # ax[1].set_title("Block view with\n local mean pooling")
# # ax[1].imshow(mean_view.astype('uint8'))

# # ax[2].set_title("Block view with\n local max pooling")
# # ax[2].imshow(max_view, cmap=cm.Greys_r)
# # ax[2].set_title("Block view with\n local max pooling")
# # ax[2].imshow(max_view.astype('uint8'))

# # ax[3].set_title("Block view with\n local median pooling")
# # ax[3].imshow(median_view, cmap=cm.Greys_r)
# # ax[3].set_title("Block view with\n local median pooling")
# # ax[3].imshow(median_view.astype('uint8'))

# # ax[4].imshow(image, cmap='gray')
# # ax[4].set_title("Original image")

# # ax[5].imshow(image_rescaled, cmap='gray')
# # ax[5].set_title("Rescaled image (aliasing)")

# # ax[6].imshow(image_resized, cmap='gray')
# # ax[6].set_title("Resized image (aliasing)")

# # ax[7].imshow(image_downscaled, cmap='gray')
# # ax[7].set_title("Downscaled image (no aliasing)")
# RGB_image = median_view.astype('uint8')
# hsv_img = rgb2ycbcr(RGB_image)
# hue_img = hsv_img[:, :, 0]
# sat_img = hsv_img[:, :, 1]
# value_img = hsv_img[:, :, 2]

# fig, (ax0, ax1, ax2, ax3) = plt.subplots(ncols=4, figsize=(8, 3))

# ax0.imshow(sat_img)
# ax0.set_title("Saturation image")
# ax0.axis('off')
# ax1.imshow(hue_img, cmap='hsv')
# ax1.set_title("Hue channel")
# ax1.axis('off')
# ax2.imshow(value_img)
# ax2.set_title("Value channel")
# ax2.axis('off')
# ax3.imshow(RGB_image)
# ax3.set_title("RGB median")
# ax3.axis('off')

# fig.tight_layout()

# ===============================================================
# import matplotlib.pyplot as plt
# import numpy as np
# import os

# from skimage.data import astronaut
# from skimage.color import rgb2gray
# from skimage.filters import sobel
# from skimage.segmentation import felzenszwalb, slic, quickshift, watershed
# from skimage.segmentation import mark_boundaries
# from skimage.util import img_as_float
# from skimage.io import imread
# from skimage.transform import rescale, resize, downscale_local_mean
# from skimage.util import view_as_blocks

# # img = img_as_float(astronaut()[::2, ::2])
# root = '/home/amirhosein/Desktop/SASSARI_PROJ'
# # set = 'RGB_12-12-2018'
# set = 'RGB_06-09-2018'

# filenames = os.listdir(os.path.join(root, set))
# for file in filenames:
#     filename = os.path.join(os.path.join(root, set), file)
#     # filename = '/home/amirhosein/Desktop/SASSARI_PROJ/RGB_12-12-2018/DJI_0011.JPG'
#     image = imread(filename, as_gray=False)
#     # image = resize(image, (image.shape[0] // 8, image.shape[1] // 8),
#     #                        anti_aliasing=True)
#     image = resize(image, (4800, 6800), anti_aliasing=True)

#     # size of blocks
#     block_shape = (100, 100, 1)

#     # see astronaut as a matrix of blocks (of shape block_shape)
#     view = view_as_blocks(image, block_shape)

#     # collapse the last two dimensions in one
#     flatten_view = view.reshape(view.shape[0], view.shape[1], view.shape[2], -1)
#     # flatten_view = view.reshape(view.shape[0], view.shape[1], -1)

#     # resampling the image by taking either the `mean`,
#     # the `max` or the `median` value of each blocks.
#     image = np.mean(flatten_view, axis=3)
#     # image = np.max(flatten_view, axis=3)
#     # image = np.median(flatten_view, axis=3)

#     # image = resize(image, (480, 680), anti_aliasing=False)
#     image = rescale(image, (10, 10, 1), anti_aliasing=False)


#     img = img_as_float(image[::2, ::2])

#     segments_fz = felzenszwalb(img, scale=100, sigma=0.5, min_size=2000)
#     # segments_slic = slic(img, n_segments=250, compactness=10, sigma=1,start_label=1)
#     # segments_quick = quickshift(img, kernel_size=3, max_dist=6, ratio=0.5)
#     # gradient = sobel(rgb2gray(img))
#     # segments_watershed = watershed(gradient, markers=250, compactness=0.001)

#     print(f"Felzenszwalb number of segments: {len(np.unique(segments_fz))}")
#     # print(f"SLIC number of segments: {len(np.unique(segments_slic))}")
#     # print(f"Quickshift number of segments: {len(np.unique(segments_quick))}")

#     fig, ax = plt.subplots(1, 1, figsize=(10, 10), sharex=True, sharey=True)

#     ax.imshow(mark_boundaries(img, segments_fz, color=(1,0,0)))
#     ax.set_title("Felzenszwalbs's method")
#     # ax[0, 1].imshow(mark_boundaries(img, segments_slic, color=(1,0,0)))
#     # ax[0, 1].set_title('SLIC')
#     # ax[1, 0].imshow(mark_boundaries(img, segments_quick, color=(1,0,0)))
#     # ax[1, 0].set_title('Quickshift')
#     # ax[1, 1].imshow(mark_boundaries(img, segments_watershed, color=(1,0,0)))
#     # ax[1, 1].set_title('Compact watershed')
#     # ax.ravel()
#     ax.set_axis_off()
#     # for a in ax.ravel():
#     #     a.set_axis_off()

#     plt.tight_layout()
#     plt.show()
# ===============================================================

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

filename = '/home/amirhosein/Desktop/SASSARI_PROJ/RGB_12-12-2018/DJI_0011.JPG'
# filename = '/home/amirhosein/Desktop/SASSARI_PROJ/RGB_06-09-2018/DJI_0011.JPG'
_image = imread(filename, as_gray=False)
_image_ = _image.copy()

# size of blocks
block_shape = (32, 32, 1)

# see astronaut as a matrix of blocks (of shape block_shape)
view = view_as_blocks(_image, block_shape)

# collapse the last two dimensions in one
flatten_view = view.reshape(view.shape[0], view.shape[1], view.shape[2], -1)

mean_view = np.mean(flatten_view, axis=3)
max_view = np.max(flatten_view, axis=3)
median_view = np.median(flatten_view, axis=3)

RGB_image = median_view.astype('uint8')
hsv_img = rgb2ycbcr(RGB_image)
hue_img = hsv_img[:, :, 0]
sat_img = hsv_img[:, :, 1]
value_img = hsv_img[:, :, 2]
image = value_img.copy()
# image = exposure.equalize_hist(image)

# hsv_img = rgb2hsv(RGB_image)
# hue_img = hsv_img[:, :, 0]
# sat_img = hsv_img[:, :, 1]
# value_img = hsv_img[:, :, 2]

# image = value_img.copy()

val = filters.threshold_otsu(image)
image = resize(image, (_image_.shape[0], _image_.shape[1]))
mask_color = image < val
mask = image < val
# mask_color = resize(mask_color.astype('uint8'), (_image_.shape[0], _image_.shape[1]))
# RGB_image = resize(_image, (mask.shape[0], mask.shape[1]), anti_aliasing=True)
_image_[mask_color, :] = 255

# hist, bins_center = exposure.histogram(image)

# plt.figure(figsize=(9, 4))
# plt.subplot(131)
# plt.imshow(image, cmap='gray', interpolation='nearest')

cv2_image = cv2.cvtColor(_image, cv2.COLOR_RGB2BGR)
cv2.imshow("image", cv2.resize(cv2_image, (0, 0), fx=0.15, fy=0.15))

# plt.axis('off')
# plt.subplot(132)
# plt.imshow(mask, cmap='gray', interpolation='nearest')
# cv2.imshow("mask", mask)
# plt.axis('off')
# plt.subplot(133)
# plt.imshow(RGB_image)

# cv2_rgb = cv2.cvtColor(_image_.astype('float32'), cv2.COLOR_RGB2BGR)
cv2_rgb = cv2.cvtColor(_image_, cv2.COLOR_RGB2BGR)
# cv2.imshow("rgb image", cv2.resize(_image_, (0, 0), fx=0.15, fy=0.15)) #cv2.imshow(filename, cv2.resize(image, (0, 0), fx=0.3, fy=0.3))
cv2.imshow("rgb image", cv2.resize(cv2_rgb, (0, 0), fx=0.15, fy=0.15)) #cv2.imshow(filename, cv2.resize(image, (0, 0), fx=0.3, fy=0.3))

# plt.axis('off')
# plt.tight_layout()
# plt.show()
cv2.waitKey(0)

