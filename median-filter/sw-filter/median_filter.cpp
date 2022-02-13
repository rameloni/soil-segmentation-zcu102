#include <iostream>
#include <fstream>
#include <sstream>
#include <string.h> /* strrchr */
#include <unistd.h>
#include <vector>
#include "sorting.cpp"
#ifndef MAX_BUF
#define MAX_BUF 200
#endif

using namespace std;
/* Median filter declaration */
int **median_filter(int wrows, int wcols, int numrows, int numcols, int **in_pixels);

/* Function to sort an array using insertion sort*/
void insertionSort(int arr[], int n)
{
    int i, key, j;
    for (i = 1; i < n; i++)
    {
        key = arr[i];
        j = i - 1;

        /* Move elements of arr[0..i-1], that are
        greater than key, to one position ahead
        of their current position */
        while (j >= 0 && arr[j] > key)
        {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }
}

int main(int argc, char *argv[])
{
    if (argc <= 1)
        exit(0);

    // get the input file extension
    const char *ext = strrchr(argv[1], '.');

    /*
        int numrows = 10, numcols = 12;

        int **out_pixels;
        out_pixels = (int **)malloc(sizeof(int *) * numrows);
        for (int i = 0; i < numrows; ++i)
            *(out_pixels + i) = (int *)malloc(sizeof(int) * numcols);

        // out_pixels[0][0] = 1;
        *(*(out_pixels + 5) + 1) = 10;
        // *(*(out_pixels + 1) + 2) = 4; // equals to out_pixels[1][2]??

        // *out_pixels[0] + sizeof(int *) * 1 = 10;
        for (int x = 0; x < numrows; x++)
        {
            printf("|");
            for (int y = 0; y < numcols; y++)
            {

                // printf("x:%d, y:%d-->", x, y);
                // printf("%d | ", **(out_pixels + x * numcols + y));
                printf("%2d |", *(*(out_pixels + x) + y));
            }
            puts("");

            // printf("x:%d-->%d ", x, out_pixels_1[x]);
        }

        return 0;
    */
    if (strcmp(ext, ".pgm") == 0) // there is an input pgm image
    {
        // read the image name and the current path
        string in_imagename = argv[1];
        char *cur_path = strcat(get_current_dir_name(), "/");
        // set the whole filename of image
        string filename = (string)cur_path + in_imagename + "";

        printf("Current path: %s\n", cur_path);
        printf("Image: %s\n", argv[1]);
        printf("Extension: %s\n", ext);
        cout << "Whole filename: " << filename << endl;
        cout << "------------------------------------------------------------------------------------------------------------" << endl;

        // open the input image
        ifstream infile(strcat(cur_path, argv[1]));
        if (infile.fail()) // check if the file is opened
            cerr << "File input reading FAILED. Check your input file." << endl;

        stringstream ss; // input file string
        string inputLine = "";
        int numrows = 0, numcols = 0, MAX = 0; // the kernel???? 3*3

        // First line : version
        getline(infile, inputLine);
        // cout << inputLine << endl;
        if (inputLine.compare("P2") != 0)
            cerr << "Version error or check your image file" << endl;
        else
            cout << "Version: " << inputLine << endl;

        // Continue with a stringstream
        ss << infile.rdbuf();

        // Secondline : size of image
        ss >> numcols >> numrows >> MAX;

        // initialize input image array to store pixel values
        int **arr_in_image;
        arr_in_image = (int **)malloc(sizeof(int *) * numrows); // initialize the rows pointers
        for (int i = 0; i < numrows; ++i)
            *(arr_in_image + i) = (int *)malloc(sizeof(int) * numcols); // initialize the rows

        // print total number of rows, columns and maximum intensity of image
        cout << numcols << " columns and " << numrows << " rows" << endl
             << "Maximum Intensity " << MAX << endl;

        // Following lines : data
        // Stores the input image into an array
        for (int row = 0; row < numrows; ++row)
            for (int col = 0; col < numcols; ++col)
                // original data store in new array
                // ss >> array[row][col];
                ss >> *(*(arr_in_image + row) + col);
        // cout << "ok2";
        clock_t t1 = clock();
        printf("Start time: %ju\n", t1);
        int **arr_median_image = median_filter(32, 32, numrows, numcols, arr_in_image);
        clock_t t2 = clock();
        printf("End time: %ju\n", t2);
        printf("ELAPSED time: %.2fms\n", 1000.0 * (t2 - t1) / CLOCKS_PER_SEC);

        // save the output image file .pnm
        ofstream outfile, outfile_test;
        // new file open to store the output image
        // outfile.open("VIA.pnm" + ".pnm");

        outfile.open(filename + ".pnm");
        outfile << "P2" << endl;
        outfile << numcols << " " << numrows << endl;
        outfile << "255" << endl;
        for (int row = 0; row < numrows; ++row)
        {
            outfile << " ";
            for (int col = 0; col < numcols; ++col)
                // store resultant pixel values to the output file
                outfile << *(*(arr_median_image + row) + col) << " ";
            outfile << endl;
        }

        outfile.close();
        outfile_test.close();
        infile.close();
    }
    return 0;
}

int **median_filter(int wrows, int wcols, int numrows, int numcols, int **in_pixels)
{
    // output pixels
    int **out_pixels;
    out_pixels = (int **)malloc(sizeof(int *) * numrows); // initialize the rows pointers
    for (int i = 0; i < numrows; ++i)
        *(out_pixels + i) = (int *)malloc(sizeof(int) * numcols); // initialize the rows
    /*
    To access the (i, j) element
    Use: *(*(out_pixels + i) + j);
    */

    // window: it is a 1-D array used for sorting
    int *window = (int *)malloc(sizeof(int) * wrows * wcols);
    int edge_x = wrows / 2;
    int edge_y = wcols / 2;

    // Now print the array to see the result
    // for (int row = 1; row < numrows; ++row)
    //     for (int col = 1; col < numcols; ++col)
    int j = 0;
    for (int x = edge_x; x < numrows - edge_x; ++x)
        for (int y = edge_y; y < numcols - edge_y; ++y)
        {
            int i = 0; // indexing of window
            for (int fx = 0; fx < wrows; ++fx)
                for (int fy = 0; fy < wcols; ++fy)
                    window[i++] = *(*(in_pixels + (x + fx - edge_x)) + (y + fy - edge_y));

            // sorting window
            // insertionSort(window, wrows * wcols);
            // printf("Merge[%d]", j++);

            mergeSort(window, 0, wrows * wcols - 1);
            // if (j % 100000 == 0)
            //     printf("Merge[%d]", j);
            // j++;
            out_pixels[x][y] = window[wrows * wcols / 2];
        }

    // free memory window
    free(window);

    return out_pixels;
}