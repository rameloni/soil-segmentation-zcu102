# Soil Segmentation Code Analysis
It is the first step to port the application on the ZCU102: learning what the algorithm does.
## Index
- [YCbCr_test](#YCbCr_test.py)

## YCbCr_test.py
This script converts the input image in YCbCr color space. Also it shows how to use `view_as_block` of `skimage.util`. Block views can be incredibly useful when one wants to perform local operations on non-overlapping image patches. [Skimage](https://scikit-image.org/) is a collection of algorithms for image processing.

This script:
 1. opens an image with  `imread`;
 2. creates a block view of the image in blocks of 32x32x1. **Be careful that smaller are the blocks and bigger and larger the resulting image will be but, on the other hand, bigger are the blocks, smaller the resulting image will be and with a worse resolution.**
    ```python
    view = view_as_blocks(image, (32, 32, 1))
    # print(view.shape) ------- (114, 171, 3, 32, 32, 1) that is a concatenation (new_image, shape)
    ```
    For example, if the rgb image is of 3648x5472x3 px the view_as_block image will be of 114x171x3: *3648/32=114, 5472/32=171, 3/1=3*.
 3. Then the image is flattened:
    ```python
    flatten_view = view.reshape(view.shape[0], view.shape[1], view.shape[2], -1)  # -1 one shape dimension
    # print(flatten_view.shape) ------- (114, 171, 3, 1024) (32, 32, 1) are collapsed in 1024
    ```
 4. Then, the algorithm starts. It consists of three main parts: [mean()](https://numpy.org/doc/stable/reference/generated/numpy.mean.html?highlight=mean), [max()]() and [median()](https://numpy.org/doc/stable/reference/generated/numpy.median.html?highlight=median#numpy.median) functions of numpy library which compute the arithmetic mean, get max value and comput the median along the specified axis.
    ```python
    mean_view = np.mean(flatten_view, axis=3)
    max_view = np.max(flatten_view, axis=3)
    median_view = np.median(flatten_view, axis=3)
    # they are arrays of 114x171x3 pixels. Each pixel contains the mean, max and median value of a block respectively
    # np.mean()
    ```
 5. Finally the images (mean_view, max_view and median_view) are plotted in different channels. In particular the image is converted in YCbCr color space using `rgb2ycbcr` from `skimage.color`:
    - Y channel
    - Cb channel
    - Cr channel
    - RGB channel

