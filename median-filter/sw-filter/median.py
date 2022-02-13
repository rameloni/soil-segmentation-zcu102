from curses import resize_term
import numpy as np
from skimage import filters
from skimage import morphology as morph
from skimage.io import imread
from skimage.util import view_as_blocks
from skimage.color import rgb2hsv, rgb2ycbcr
from skimage.transform import rescale, resize, downscale_local_mean
import matplotlib.pyplot as plt
import cv2
import time
import sys
import os

scriptpath = "/home/raffaele/Documents/soil-segmentation-zcu102/AIPreciseAgri_analysis/Soil_Segmentation/"
sys.path.append(os.path.abspath(scriptpath))
from Segmentation_test import print_img

def elapsed_and_print(start_time, end_time, msg):
    print('|', f'{msg:{" "}{"<"}{25}}', '|',
          f'{"{:.2f}".format((end_time-start_time)*1000) + " ms":{" "}{"<"}{15}}', '|',
          f'{"{:.0f}".format((end_time-start_time)*1000000) + " μs":{" "}{"<"}{15}}', '|')
    return end_time - start_time

# find the compatible image shape
# def find_shape(n_portions, image):
#     # the image is "divided" n_portions
#     shape = 
#     return shape

# list of times in seconds
times = {'Divide and flatten': [],
         'Mean filter': [],
         'Max filter': [],
         'Median filter': [],
         'Real Median': [],
         'rgb2ycbcr color space': [],
         'Otsu threshold': [],
         'Resize image': [],
         'Mask': [],
         'Masked image': [],
         'Writing images': [],
         'Total time elapsed': []}

if len(sys.argv) >= 2:  # the input image is provided
    filename = os.getcwd() + "/" + str(sys.argv[1])
    start_tot_time = time.time()

    image_name, file_extension = os.path.splitext(filename)
    # print_header(file)
        # print(file_extension)
    # convert png to JPG
    if file_extension == '.png':
        cv2.imwrite(image_name+".JPG",  imread(filename, as_gray=False),(cv2.IMWRITE_PAM_FORMAT_RGB, 0))

    if file_extension == '.JPG' or file_extension == '.png':

        # if the file is a JPG image apply the otsu segmentation
        # print(filename)
        # 1. READ THE IMAGE
        _image = imread(image_name+".JPG", as_gray=False)
        # 2. COPY THE IMAGE
        _image_ = _image.copy()
        # _image = resize(_image_, (3000, 3000,3))
        print(_image.shape)
        start_time = time.time()
        # cv2.imwrite(filename+"filtered.JPG", _image)
        # exit()
        # size of blocks
        # 3. CREATE THE WINDOW
        block_shape = (32, 32, 1)

        # block_shape = (30, 30, 1)

        print("block_shape:", block_shape)
        # see astronaut as a matrix of blocks (of shape block_shape)
        view = view_as_blocks(_image, block_shape)
        print("_image.shape:", _image.shape)
        print("view.shape:",view.shape)

        # collapse the last two dimensions in one
        flatten_view = view.reshape(
            view.shape[0], view.shape[1], view.shape[2], -1)
        end_time = time.time()
        print("flatten_view.shape:", flatten_view.shape)

        times['Divide and flatten'].append(elapsed_and_print(
            start_time, end_time, "Divide and flatten:"))
        # print(times)

        start_time = time.time()
        # flatten_view.shape = (rows/32, cols/32, 3, 32*32=1024)
        # np.mean(flatten_view, axis=3)
        # computes the mean of 1024 pixels and create a new image "mean_view" of rows/32*cols/32 
        mean_view = np.mean(flatten_view, axis=3)
        end_time = time.time()
        times['Mean filter'].append(elapsed_and_print(
            start_time, end_time, "Mean filter:"))
        print("mean_view.shape", mean_view.shape)

        start_time = time.time()
        max_view = np.max(flatten_view, axis=3)
        end_time = time.time()
        times['Max filter'].append(elapsed_and_print(
            start_time, end_time, "Max filter:"))
        print("max_view.shape", max_view.shape)
    
        start_time = time.time()
        # median_view = np.median(flatten_view, axis=3)
        median_view = np.median(flatten_view, axis=3)
        end_time = time.time()
        times['Median filter'].append(elapsed_and_print(
            start_time, end_time, "Median filter:"))
        print("median_view.shape", median_view.shape)
        new_size = (1000,1000, 3)
        resized_image = np.zeros(new_size)
        resized_image[:, :, 0] = resize(_image_[:,:,0], new_size[:2])*255
        resized_image[:, :, 1] = resize(_image_[:,:,1], new_size[:2])*255
        resized_image[:, :, 2] = resize(_image_[:,:,2], new_size[:2])*255
        # print_img([resize(_image, (1000, 1000, 3)), resized_image], ["Image", "Real Median view"])
        # plt.show()
        # exit()
        start_time = time.time()
        # compute the real median_view
        # real_median_view = filters.median(_image, morph.cube(32))
        # print(_image)
        # print(resized_image.astype('uint8'))
        real_median_view = np.zeros(new_size)
        real_median_view[:, :, 0] = filters.median(resized_image[:, :, 0], morph.square(16))
        real_median_view[:, :, 1] = filters.median(resized_image[:, :, 1], morph.square(16))
        real_median_view[:, :, 2] = filters.median(resized_image[:, :, 2], morph.square(16))

        # real_median_view = _image[:,:,1]
        end_time = time.time()
        times['Real Median'].append(elapsed_and_print(
            start_time, end_time, "Real Median filter:"))
        # print the median view
        print(real_median_view.shape)
        
        # print_img([resize(_image, (1000, 1000, 3)), median_view.astype('uint8'),  real_median_view.astype('uint8')], ["Image", "Median view", "Real Median view"])
        # print_img([resized_image.astype('uint8'), median_view.astype('uint8'),  real_median_view.astype('uint8')], ["Image", "Median view", "Real Median view"])
        # plt.show()
        cv2.imwrite(filename+"resized.JPG", cv2.cvtColor(resized_image.astype('uint16'), cv2.COLOR_RGB2BGR))   
        cv2.imwrite(filename+"filtered.JPG", cv2.cvtColor(median_view.astype('uint16'), cv2.COLOR_RGB2BGR))    
        cv2.imwrite(filename+"filtered_real.JPG", cv2.cvtColor(real_median_view.astype('uint16'), cv2.COLOR_RGB2BGR))    
        # END MEDIAN TEST
        # exit()

        start_time = time.time()
        # RGB_image = median_view.astype('uint8')
        # RGB_image = real_median_view.astype('uint8')
        RGB_image = _image.astype('uint8')
        ycbcr_img = rgb2ycbcr(RGB_image)
        y_img = ycbcr_img[:, :, 0]
        cb_img = ycbcr_img[:, :, 1]
        cr_img = ycbcr_img[:, :, 2]
        end_time = time.time()
        times['rgb2ycbcr color space'].append(elapsed_and_print(
            start_time, end_time, "rgb2ycbcr color space:"))
        print("rgb_image.shape", RGB_image.shape)
        print("cr_img.shape", cr_img.shape)

        image = cr_img.copy()   # cr used for otsu threshold
        


        # image = value_img.copy()

        start_time = time.time()
        # Threshold value based on Otsu's method
        val = filters.threshold_otsu(image)
        end_time = time.time()
        times['Otsu threshold'].append(elapsed_and_print(
            start_time, end_time, "Otsu Threshold:"))

        print("val", val)
        # resize the flattened image to match the original size
        print("image.shape", image.shape)
        start_time = time.time()
        image = resize(image, (_image_.shape[0], _image_.shape[1]))
        end_time = time.time()
        times['Resize image'].append(elapsed_and_print(
            start_time, end_time, "Resize image:"))
        print("Resized image.shape", image.shape)
        
  
        start_time = time.time()
        mask_color = image < val
        mask = image < val
        end_time = time.time()
        times['Mask'].append(elapsed_and_print(
            start_time, end_time, "Mask:"))
        print("mask.shape", mask.shape)

        start_time = time.time()
        # set the pixels masked to 255
        _image_[mask_color, :] = 255
        end_time = time.time()
        times['Masked image'].append(elapsed_and_print(
            start_time, end_time, "Masked image:"))
        print("masked_image.shape", _image_.shape)

        

        end_tot_time = time.time()
        times['Total time elapsed'].append(elapsed_and_print(
            start_tot_time, end_tot_time, "'Total time elapsed':"))

        # print the images
        cv2_image = cv2.cvtColor(_image, cv2.COLOR_RGB2BGR)
        # cv2.imshow("image", cv2.resize(
        #     cv2_image, (0, 0), fx=0.15, fy=0.15))

        cv2_rgb = cv2.cvtColor(_image_, cv2.COLOR_RGB2BGR)
        # cv2.imshow("mask", cv2.resize(cv2_rgb,
        #            (0, 0), fx=0.15, fy=0.15))

        # cv2.waitKey(30)

        start_time = time.time()
             # write the mask image in the output dir

        # cv2.imwrite(filename+"masked_image_with_real_median_16.JPG",cv2_rgb)
        # cv2.imwrite(filename+"masked_image.JPG", cv2_rgb)
        cv2.imwrite(filename+"masked_image_without_median.JPG", cv2_rgb)
    
        end_time = time.time()
        times['Writing images'].append(elapsed_and_print(
            start_time, end_time, "Writing images:"))

exit()
# print the average elapsed times for each code snippet
print_header("Compute average elapsed times")
print("| Code                      | Latency (ms)    | Latency (ms)    |")
print("| ------------------------- | --------------- | --------------- |")

for key, value in times.items():
    elapsed_and_print(0, sum(value)/len(value), key)
    # print()

cv2.destroyAllWindows()
