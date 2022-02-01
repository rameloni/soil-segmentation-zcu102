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