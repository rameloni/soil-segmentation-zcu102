# ===============================================================
import matplotlib.pyplot as plt
import numpy as np
import os

from skimage.data import astronaut
from skimage.color import rgb2gray
from skimage.filters import sobel
from skimage.segmentation import felzenszwalb, slic, quickshift, watershed
from skimage.segmentation import mark_boundaries
from skimage.util import img_as_float, img_as_int
from skimage.io import imread
from skimage.transform import rescale, resize, downscale_local_mean
from skimage.util import view_as_blocks


def print_img(images, titles):
    if len(images) == len(titles):
        fig, (ax) = plt.subplots(1, len(images),
                                 figsize=(5*len(images), 3), sharex=True, sharey=True)
        array = (ax.ravel(), titles, images)
        for i in range(0, len(images)):
            # print(titles[i])
            ax[i].imshow(images[i])
            ax[i].set_title(titles[i])


"""computing the felzenszwalb and print the results"""


def felzenszwalb_and_imshow(img):
    segments_fz = felzenszwalb(img, scale=100, sigma=0.5, min_size=2000)
    boundaries = mark_boundaries(img, segments_fz, color=(1, 0, 0))

    print(f"Felzenszwalb number of segments: {len(np.unique(segments_fz))}")

    print_img((img, boundaries, segments_fz), ("Original image", "Felzenszwalbs's method",
              "Segments from felzenszwalb"))
    return len(np.unique(segments_fz))  # return the number of segments


def slic_and_imshow(img):
    segments_slic = slic(img, n_segments=250,
                         compactness=10, sigma=1, start_label=1)
    boundaries = mark_boundaries(img, segments_slic, color=(1, 0, 0))
    print(f"SLIC number of segments: {len(np.unique(segments_slic))}")

    print_img((img, boundaries, segments_slic), ("Original image", "K-means clustering (slic)",
              "Segments from k-means clustering"))
    return len(np.unique(segments_slic))


def quickshift_and_imshow(img):
    segments_quick = quickshift(img, kernel_size=3, max_dist=6, ratio=0.5)
    boundaries = mark_boundaries(img, segments_quick, color=(1, 0, 0))

    print(f"Quickshift number of segments: {len(np.unique(segments_quick))}")

    print_img((img, boundaries, segments_quick), ("Original image", "Quickshift method",
              "Segments from quickshift"))
    return len(np.unique(segments_quick))


def sobel_and_imshow(img):
    segments_sobel = sobel(rgb2gray(img))

    print_img((img, segments_sobel), ("Original image", "Sobel filter"))

    return len(np.unique(segments_sobel))


def watershed_and_imshow(img):
    gradient = sobel(rgb2gray(img))
    segments_watershed = watershed(gradient, markers=250, compactness=0.001)
    boundaries = mark_boundaries(img, segments_watershed, color=(1, 0, 0))

    print(
        f"Watershed number of segments: {len(np.unique(segments_watershed))}")

    print_img((img, boundaries, segments_watershed),
              ("Original image", "Watershed method", "Segments from watershed"))
    return len(np.unique(segments_watershed))


"""Starting the script"""

root = '/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/'  # root directory
set = 'Sample_images'   # set images directory

# getting images names
filenames = os.listdir(os.path.join(root, set))
# os.path.join(root, set) ---> it joins the paths
# os.listdir(directory) ---> it lists input directory content
# print(os.path.join(root, set))
# print(os.listdir(os.path.join(root, set)))


# for the whole set of images apply the segmentation (for each images in Sample_images)
for file in filenames[:1]:
    # read the path of the images (getting the whole name)
    filename = os.path.join(os.path.join(root, set), file)
    image = imread(filename, as_gray=False)
    print(image.shape)
    _img = image.copy()
    # image = resize(image, (image.shape[0] // 8, image.shape[1] // 8),
    #                        anti_aliasing=True)
    image = resize(image, (4800, 6800), anti_aliasing=True)
    # print(image.shape)
    # print_img(image, "Original image")
    # print_img(_img, "Resized image")

    # size of blocks
    block_shape = (100, 100, 1)
    # see astronaut as a matrix of blocks (of shape block_shape)
    view = view_as_blocks(image, block_shape)
    # collapse the last two dimensions in one
    flatten_view = view.reshape(
        view.shape[0], view.shape[1], view.shape[2], -1)

    # resampling the image by taking either the `mean`,
    # the `max` or the `median` value of each blocks.

    image = np.mean(flatten_view, axis=3)
    # image = np.max(flatten_view, axis=3)
    # image = np.median(flatten_view, axis=3)
    # print_img(image, "Mean image")

    # image = resize(image, (480, 680), anti_aliasing=False)    resize to match a certain size
    # rescale by a certain factor
    image = rescale(image, (10, 10, 1), anti_aliasing=False)

    # convert the image to a floating point format
    img = img_as_float(image[::2, ::2])

    # print_img(img, "As float image")
    plt.show()

    # compute the Felsenszwalb’s efficient graph based image segmentation
    felzenszwalb_and_imshow(img)

    # compute segmentation using k-means clustering
    slic_and_imshow(img)

    # compute the quickshift mode-seeking algorithm
    quickshift_and_imshow(img)

    # compute the sobel filter
    sobel_and_imshow(img)

    # compute the watershed algorithm
    watershed_and_imshow(img)

    plt.tight_layout()
    plt.show()
# ===============================================================

# plt.show()
