from cv2 import imwrite, imread, IMREAD_GRAYSCALE, IMWRITE_PXM_BINARY

root = "/home/raffaele/Documents/soil-segmentation-zcu102/median-filter/"
# imagename = input("Enter file name: ")
imagename = "image.png"
filename = root + imagename
png_img = imread(filename, IMREAD_GRAYSCALE)

imwrite(root+"image.pgm", png_img, (IMWRITE_PXM_BINARY, 0))