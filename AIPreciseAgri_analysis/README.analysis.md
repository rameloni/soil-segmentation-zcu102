# Soil Segmentation Code Analysis
It is the first step to port the application on the ZCU102: learning what the algorithm does.
## Index
- [YCbCr_test](#YCbCr_test.py)

## YCbCr_test.py
This is a python script which shows how to use `view_as_block` of `skimage.util`. Block views can be incredibly useful when one wants to perform local operations on non-overlapping image patches. [Skimage](https://scikit-image.org/) is a collection of algorithms for image processing.

This script:
 1. opens an image with  `imread`;
 2. creates a block view of the image in blocks of 32x32x1
    ```python
    view = view_as_blocks(image, (32, 32, 1))
    ```