#include <iostream>
#include <fstream>
#include <sstream>
using namespace std;

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

int array[2000][2000];
int arr[2000][2000];
int main()
{
    int window[9], row = 0, col = 0, numrows = 0, numcols = 0, MAX = 0; // the kernel???? 3*3
    // ifstream infile("Saltpepper.pgm");
    ifstream infile("/home/raffaele/Documents/soil-segmentation-zcu102/median-filter/image.pgm");
    // ifstream infile("/home/raffaele/Documents/soil-segmentation-zcu102/median-filter/S.png");
    stringstream ss;
    string inputLine = "";

    // First line : version
    getline(infile, inputLine);
    cout << inputLine << endl;
    if (inputLine.compare("P2") != 0)
        cerr << "Version error" << endl;
    else
        cout << "Version : " << inputLine << endl;

    // Continue with a stringstream
    ss << infile.rdbuf();

    // Secondline : size of image
    ss >> numcols >> numrows >> MAX;

    //print total number of rows, columns and maximum intensity of image
    cout << numcols << " columns and " << numrows << " rows" << endl
         << "Maximum Intensity " << MAX << endl;

    //Initialize a new array of same size of image with 0
    for (row = 0; row <= numrows; ++row)
    {
        array[row][0] = 0;
        cout << array[row][1];
    }
    for (col = 0; col <= numcols; ++col)
        array[0][col] = 0;

    // Following lines : data
    int r = 1;
    int c = 1;
    for (row = 1; row <= numrows; ++row)
    {
        for (col = 1; col <= numcols; ++col)
        {
            //original data store in new array
            ss >> array[row][col];
        }
    }

    // Now print the array to see the result
    for (row = 1; row <= numrows; ++row)
    {
        for (col = 1; col <= numcols; ++col)
        {
            //neighbor pixel values are stored in window including this pixel
            window[0] = (int)array[row - 1][col - 1];
            window[1] = (int)array[row - 1][col];
            window[2] = (int)array[row - 1][col + 1];
            window[3] = (int)array[row][col - 1];
            window[4] = (int)array[row][col];
            window[5] = (int)array[row][col + 1];
            window[6] = (int)array[row + 1][col - 1];
            window[7] = (int)array[row + 1][col];
            window[8] = (int)array[row + 1][col + 1];

            //sort window array
            for (int i = 0; i < 9; i++)
                if (window[i] < 0)
                    window[i] *= -1;

            insertionSort(window, 9);
            // for (int i : window)
            //     cout << i;
            // cout << endl;
            //put the median to the new array
            arr[row][col] = window[4];
        }
    }

    ofstream outfile, outfile_test;

    //new file open to store the output image
    outfile.open("out_image_cpp.pnm");
    outfile << "P2" << endl;
    outfile << numcols << " " << numrows << endl;
    outfile << "255" << endl;

    for (row = 1; row <= numrows; ++row)
    {
        for (col = 1; col <= numcols; ++col)
        {
            //store resultant pixel values to the output file
            outfile << arr[row][col] << " ";
        }
    }

    // outfile_test.open("S.pnm");
    // outfile_test << "P2" << endl;
    // outfile_test << numcols << " " << numrows << endl;
    // outfile_test << "255" << endl;
    // outfile_test = ss;
    // for (row = 1; row <= numrows; ++row)
    // {
    //     for (col = 1; col <= numcols; ++col)
    //     {
    //         //store resultant pixel values to the output file
    //         outfile_test << ss << " ";
    //     }
    // }

    outfile.close();
    outfile_test.close();
    infile.close();
    return 0;
}
