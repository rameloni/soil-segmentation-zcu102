# Median Filter Accelerator
Source [wikipedia](https://en.wikipedia.org/wiki/Median_filter).
The median filter is a non-linear digital filtering technique, often used to remove noise from an image or signal. In [Soil_Segmentation.py](../AIPreciseAgri_analysis/Soil_Segmentation/Soil_Segmentation.py) is used as a pre-processing step to improve the results of edge detection (e.g otsu segmentation). Median filtering is very widely used in digital image processing because, under certain conditions, it preserves edges while removing noise, somewhat like the mean filter. However, it often does a better job than the mean filter of preserving useful detail in the image. 

## The Algorithm
The main idea  is to **run through the signal entry by entry**, **replacing** each entry with the **median of neighboring entries**. The pattern of neighbors is called the "window", which slides, entry by entry, over the entire signal. For one-dimensional signals, the most obvious window is just the first few preceding and following entries, whereas for two-dimensional (or higher-dimensional) data the window must include all entries within a given radius or ellipsoidal region.



### One dimensional
This is not interesting for Soil_segmentation.py because the images are 2-dimensional signals.

### Two-dimensional pseudo code
```
1. allocate outputPixelValue[image width][image height]
2. allocate window[window width × window height]
3. edgex := (window width / 2) rounded down
4. edgey := (window height / 2) rounded down
    for x from edgex to image width - edgex do
    for y from edgey to image height - edgey do
        i = 0
        for fx from 0 to window width do
            for fy from 0 to window height do
                window[i] := inputPixelValue[x + fx - edgex][y + fy - edgey]
                i := i + 1
        sort entries in window[]
        outputPixelValue[x][y] := window[window width * window height / 2]
```
## The Algorithm
In [Soil_Segmentation.py](../AIPreciseAgri_analysis/Soil_Segmentation/Soil_Segmentation.py) [numpy.median](https://numpy.org/doc/stable/reference/generated/numpy.median.html) method is used: `np.median(flatten_view, axis=3)`.
The median filter considers each pixel in the image in turn and looks at its nearby neighbors to decide whether or not it is representative of its surroundings. The pixel value is replaced with the **median value of the neighboring pixel** values. The median is calculated by first sorting all the pixel values from the surrounding neighborhood into numerical order and then replacing the pixel being considered with the middle pixel value (*If the neighborhood under consideration contains an even number of pixels, the average of the two middle pixel values is used*).
**The median is a more robust average than the mean and so a single very unrepresentative pixel in a neighborhood will not affect the median value significantly**: the median filter does not create new unrealistic pixel values when the filter straddles an edge.

### Approach
- Store the pixel values of input image in an array.
- For each pixel value store all the neighbor pixel value including that cell in a new array (called window).
- Sort the window array.
- Median of window array is used to store output image pixel intensity.
### Boundary Issues Example
2D Median filtering example using a 3 x 3 sampling window: Extending border values outside with values at the boundary.

### Edge preservation
The median filter preserves edge property while Gaussian filter does not. Edge preservation is an important property because edges are important for visual appearance. For edge preservation property median filter is widely used in digital image processing. 

### Pseudo Code
```
stored_image = readImage(inputù_image) // copying the input image in an array

```
