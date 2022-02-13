from cv2 import imwrite, imread, IMREAD_GRAYSCALE, IMWRITE_PXM_BINARY
import sys
import os


# print (len(sys.argv))

if len(sys.argv) >= 2:  # the input image is provided
    filename = os.getcwd() + "/" + str(sys.argv[1])
    # print(filename)
    
    # extract the extension
    imagename, image_ext = os.path.splitext(filename)
    
    in_image = imread(filename, IMREAD_GRAYSCALE)
    imwrite(imagename+".pgm", in_image,(IMWRITE_PXM_BINARY, 0))

    print(sys.argv[1], "is successfully converted.")
    print("Result:", imagename+".pgm")

# root = "/home/raffaele/Documents/soil-segmentation-zcu102/median-filter/"
# # imagename = input("Enter file name: ")
# imagename = "image.png"
# filename = root + imagename
# png_img = imread(filename, IMREAD_GRAYSCALE)

# imwrite(root+"image.pgm", png_img, (IMWRITE_PXM_BINARY, 0))