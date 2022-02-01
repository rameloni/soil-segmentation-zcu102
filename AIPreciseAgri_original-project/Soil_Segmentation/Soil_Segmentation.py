
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

root = '.'
rootsroot = '..'
set = 'Sample_images'
soil_seg_dir = 'SOIL_SEGMENTED'
soil_seg_masks_dir = 'SOIL_SEGMENTED_MASKS'

seg_images_full_dir = os.path.join(root, soil_seg_dir)
seg_masks_full_dir = os.path.join(root, soil_seg_masks_dir)

if not os.path.exists(seg_images_full_dir):
    os.makedirs(seg_images_full_dir)
if not os.path.exists(seg_masks_full_dir):
    os.makedirs(seg_masks_full_dir)

filenames = os.listdir(os.path.join(rootsroot, set))
for file in filenames:
    filename = os.path.join(os.path.join(rootsroot, set), file)
    if not os.path.isdir(filename):
        _, file_extension = os.path.splitext(filename)
        print(file_extension)
        if file_extension == '.JPG':
            print(filename)
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

            _image_[mask_color, :] = 255

            cv2_image = cv2.cvtColor(_image, cv2.COLOR_RGB2BGR)
            cv2.imshow("image", cv2.resize(cv2_image, (0, 0), fx=0.15, fy=0.15))

            cv2_rgb = cv2.cvtColor(_image_, cv2.COLOR_RGB2BGR)

            cv2.imshow("rgb image", cv2.resize(cv2_rgb, (0, 0), fx=0.15, fy=0.15)) #cv2.imshow(filename, cv2.resize(image, (0, 0), fx=0.3, fy=0.3))

            cv2.waitKey(30)

            cv2.imwrite(os.path.join(seg_images_full_dir, file), cv2_rgb)
            cv2.imwrite(os.path.join(seg_masks_full_dir, file), mask_color.astype('uint8')*255)
cv2.destroyAllWindows()
