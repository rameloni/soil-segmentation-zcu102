# =========================================================

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

path = '/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/'
filename = path + 'Sample_images/DJI_0002.JPG'  # image filename
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
ycbcr_img = rgb2ycbcr(RGB_image)
y_img = ycbcr_img[:, :, 0]
cb_img = ycbcr_img[:, :, 1]
cr_img = ycbcr_img[:, :, 2]

image = cr_img.copy()
# image = exposure.equalize_hist(image)

# hsv_img = rgb2hsv(RGB_image)
# hue_img = hsv_img[:, :, 0]
# sat_img = hsv_img[:, :, 1]
# value_img = hsv_img[:, :, 2]

# image = value_img.copy()

# Threshold value based on Otsu's method
val = filters.threshold_otsu(image)
print("# Threshold value based on Otsu's method: ", val)
# resize the flattened image to match the original size
print("image.shape", image.shape)
print("_image.shape", _image.shape)
print("_image_.shape", _image_.shape)
image = resize(image, (_image_.shape[0], _image_.shape[1]))

x = 4 < 3
print(x)
mask_color = image < val    # if the image[i] < val ---> mask_color[i]=true
print("mask_color: ", mask_color)
mask = image < val
print("mask: ", mask)
print(mask.all() == mask_color.all())

_image_[mask_color, :] = 255


# printing the masks
fig, (ax0, ax1) = plt.subplots(ncols=2,  figsize=(8, 5))    # create a figure
ax0.imshow(mask, cmap='gray')
ax1.imshow(image)
plt.show()

# Convert an image from RGB color to BGR (blue, green, red)
cv2_image = cv2.cvtColor(_image, cv2.COLOR_RGB2BGR)
# show the image rescaling it by 0.15 factor
print(cv2_image.shape)

cv2.imshow("image", cv2.resize(cv2_image, (0, 0), fx=0.15, fy=0.15))
print(cv2.resize(cv2_image, (0, 0), fx=0.15, fy=0.15).shape)


# Convert an image from RGB color to BGR (blue, green, red)
cv2_rgb_masked = cv2.cvtColor(_image_, cv2.COLOR_RGB2BGR)
# cv2.imshow("rgb image", cv2.resize(_image_, (0, 0), fx=0.15, fy=0.15)) #cv2.imshow(filename, cv2.resize(image, (0, 0), fx=0.3, fy=0.3))
# cv2.imshow(filename, cv2.resize(image, (0, 0), fx=0.3, fy=0.3))
cv2.imshow("image masked ", cv2.resize(
    cv2_rgb_masked, (0, 0), fx=0.15, fy=0.15))


# cv2.waitKey(0)  # wait forever
cv2.waitKey(0)
