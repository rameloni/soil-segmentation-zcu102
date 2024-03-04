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
## Python Version
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
stored_image = readImage(input_image) // copying the input image in an array

```

## C translation


## HDL implementation
The FPGA accelerator is written in Verilog. It is composed by a main actor compatible with the MDC tool. The whole accelerator, which consists of 7 actors connected together through FIFOs (one per in/out signal), receives a stream of pixels (8-bit) from an input FIFO and sends another stream of pixels back to an output FIFO. 
### The Actor - fill&check.v
The actor inputs are:
 - `[7:0] in_px` the input pixel stream channel;
 - `[7:0] in_pivot` the value which is used to separate the input pixels and push them into lower, equal and larger buffers;
 - `[10:0] in_buff_size` 
 - `[10:0] in_median_pos`
 - `[7:0] in_second_median_value`
	
The outputs are:
 - `[7:0] out_px` the next pixel stream channel;
 - `[7:0] out_pivot` the next pivot value which is used to separate the input pixels and push them into lower, equal and larger;
 - `[10:0] out_buff_size` 
 - `[10:0] out_median_pos`
 - `[7:0] out_second_median_value` 
	
3 main modules:
 - `fill_logic.v`
 - `next_logic.v`
 - `send_logic.v`
	
	
### How it runs
Each actor has two main phases:
 1. Fill (`fill_logic`) - during this step the actor reads and samples `in_pivot`, `in_buff_size`, `in_median_pos` and `in_second_median_value`, then it saves `in_buff_size` pixels into temp buffers (lower, equal and larger than `in_pivot`).
 2. Send (`send_logic`) - during this step the actor sends the pixels either from lower buffer or equal buffer or larger buffer, and sends the updated `out_pivot`, `out_buff_size`, `out_median_pos` and `out_second_median_value`. Each of output value is chosen by the `next_logic`.

	
### Fill Logic
This module has the purpose to **store** the input pixels, from the previous actor, into three **temporary buffers** (lower, equal and larger) and then to **signal the end of filling** (`fill_done`). Where saving the `in_px` is chosen through the `in_pivot`.

So, this module will be able to generate the `rd` signals to read the input data from the FIFOs, sample them and the signals the `fill_done` to the `send_logic`. To do that, this logic:
 1. samples the input control values into registers (`in_pivot`, `in_buff_size`, `in_median_pos` and `in_second_median_value`);
 2. starts to fill the temporary buffers
    - reads `in_buff_size` pixels from the FIFO
    - for each pixel read, it pushes the pixel into the proper buffer and updates the sizes, the max and min lower and larger values
 3. once the filling process ends it signals the end to the send logic - all the pixels are saved
 4. once the send logic receives the command and it is free, the fill logic could start a new filling. Therefore, it restarts the counters and buffers and repeats the process from step 1
 5. if the fill logic has ended filling and the send logic is busy, the fill logic waits the send logic and then continue to the step 3

 #### FSM fill logic
 It manages the whole filling process. It raises the read request properly, puts the logic in a wait status if needed and signals the filling status of the logic.
 The inputs are:
  - `fill_done` - it signals that all the pixels are stored, hence the pixels are ready to be sent to the send logic
  - `sending` - it signals that the send logic is a sending status, so it is busy and it's not able to receive a new request
  - `control_sampled` - it signals that the control data are stored, therefore the reading process can start

 The outputs are:
  - `read_req` - it is a 1-bit signal which is sent to the input FIFO to read the pixels (*remember that in `fifo_small` a data is valid only if rd==1 and empty==0)
  - `filling` - it signals the status of the fill logic to the other modules, (e.g. if filling==1 the control signals cannot be read from the FIFOs)
  - `up_next` - update next, it allows the update of next data (data that should be sent to the next actor), the fill logic is restarted 

 The states:
  - IDLE=2'b00 - the fill logic is neither filling nor waiting the send logic
  - READ=2'b01 - the fill logic is reading from the input pixels FIFO (it is filling the temporary buffers)
  - WAIT=2'b10 - the fill logic is waiting the send logic, that is fill logic ends filling but send logic is busy
  - SEND_REQ=2'b11 - the fill logic raises a request send to the send logic, the pixels and the next control values are sent to send logic
  
 The counters are updated when a new pixel is received and they are finally restarted once the send request has been done.

### Next Logic
This module updates the next data needed by the send logic. It could be completely a combinatorial module but it has not any sense since the values must be sent only once the fill logic ends and send logic is not busy. Indeed, the next values are stored in registers and that registers are updated once the `up_next` is equal to 


### Send logic
This module handles the sending to the next actor of the next values. It is controlled by a fsm and output counter, as in the fill logic. The transmission starts only once the `up_next` signal is raised (*note: the 'up_next` is raised only if send logic is not actually already sending*). Therefore, the send logic has to generate a sending (busy signal) properly.
 
 #### FSM Send Logic
 It is quite simple and it manages the sending step. It receives the update trigger from the fill logic and put the logic in a sending status in which the sending requests are done.
 The inputs are:
  - `up_next` - update next request, once this signal is received the next values are available, so they could be sent to the next actor
  - `send_done` - this signal communicates that the last pixel has been sent

 The outputs are:
  - `sending` - the busy signal, it is sent to the fill logic and it communicates that the send logic is busy and, therefore, it cannot received other requests (up_next==1)
  - `send_req` - it is sent to the output FIFO (connected to wr FIFO's port)
  - `samp_data` - this signal makes the send logic able to save store the next data, *but it might not necessary because the next logic itself is composed by registers and such registers are updated only if up_next==1 by the next logic and, since up_next could be 1 only if sending==0, all data are ever true

 The states:
  - IDLE=1'b0 - the send logic is not sending and no pixels are sent to the next actor
  - SEND=1'b1 - the send logic is sending the next buffer's pixels

