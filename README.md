# Soil Segmentation for zcu102 on yocto
Hybrid application (SW/HW) for the soil segmentation algorithm.

- [Soil segmentation analysis](AIPreciseAgri_analysis)
- [Soil segmentation timing analysis](AIPreciseAgri_analysis/README.analysis.md#timing-analysis)
- [Median Filter](median-filter)
- [Communication Management](ps-pl-comm)

# Plan
1. [Real accelerator management](#1---real-accelerator-management)
2. [Profiling app Comp4Drones](#2---comp4drones-application-profiling)
3. [Accelerator implementation](#3---accelerator-implementation)
4. [Soil Segmentation app](#4---soil-segmentation-app)


## 1 - Real accelerator management
Sobel/roberts accelerator or AES256.

 - [ ] Study of memory management
 - [ ] Study of communication management (DMA)
    - [ ] Brief description of DMA and its interface 
	- [ ] Vivado schematic
	- [ ] svg schematic
    - [ ] Custom ip block
	- [ ] AXIS interface
	- [ ] Creating a custom IP
	- [ ] Integrate IP and interface (make connections)
	- [ ] How to use the xdc + link xdc
	- [ ] Synth, Impl, Bitstream (.bin version, remember to check the setting option)
    - [ ] Create the C app to use DMA
    - [ ] Integrate the interface for AES256
 - [ ] MDC backend MDC compatible with UltraScale+

## 2 - Comp4Drones application profiling

Profiling on the software part of the Sopil Segmentation heterogeneous system to decide what to implement for FPGA and what not.

 - [ ] Running the software code on UltraScale+
    - [x] Behavioural test on PC
    - [x] Timing test on PC
    - [ ] Behavioural test on UltraScale+
    - [ ] Timing test on UltraScale+
 - [ ] Latencies table of the different parts
 - [ ] Identification of critical parts

## 3 - Accelerator implementation
The critical part should be the median filter. 
 - [x] Extract the algorithm of Python function and make a C working implementation
 - [ ] Hardware implementation

## 4 - Soil Segmentation app
App integration on the UltraScale+

 - [ ] Reading camera integration (Software management)
 - [ ] Depending on the application chosen, comparison of the image cores genrated by bitbake --> table of the different implementations: What changes? Why?

