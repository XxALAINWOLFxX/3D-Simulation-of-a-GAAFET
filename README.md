# 3D-Simulation-of-a-GAAFET

## Project Overview

This repository contains the files and scripts needed to perform a 3D simulation of Gate-All-Around Field-Effect Transistors (GAAFETs) using Synopsys Sentaurus tools. This is my final year BTech Project under Dr. Venkatnarayan Hariharan at Shiv Nadar University.
### Tools Used
1. **Sentaurus Process (SProcess)**: To model and simulate the fabrication process.  
2. **Sentaurus Device (SDevice)**: To simulate the electrical behavior of the device.  
3. **Sentaurus Visual**: To analyze and visualize the simulation results.  

> **Note:** This project uses features from the 2017 version of Sentaurus, specifically the **Advanced Calibration Module**. Please ensure compatibility with your software version.
> Machine Specifications: workstation-class machine with a 10-core Intel Xeon processor W-2255 running at 3.7 GHz with L1/2/3 cache of 0.6/10/19 MB respectively, and having a 256 GB RAM.

---

## Steps to Replicate the Project

1. **Clone the Repository**  
   Clone this repository into your local directory

2. **Set the Path**
   Ensure the directory path is set to the project's location.

3. **Run Sentaurus Process (SProcess)**
   Execute the SProcess tool via terminal:
   sprocess <process_file>.cmd

   Check for any errors in the log files generated.

**Using the SDevice Command File**
To simulate the device characteristics

4. Generate a parameter file:
   sdevice -p

5. Edit the .par file and datexcode.txt file if using materials outside the Sentaurus library. Refer to the Sentaurus Device Manual for instructions.

6. Run the .cmd file in the terminal:
   sdevice <device_file>.cmd

7. **Visualize Results**
   Use Sentaurus Visual to analyze the output files and visualize the results.

**Troubleshooting**

1) Log Files: Check the log files generated during the execution of SProcess and SDevice for errors or warnings.
2) Version Compatibility: Ensure you are using the 2017 version or later if the advanced calibration module is required.
3) Material Definitions: When using custom materials not included in the Sentaurus library, correctly update the datexcode.txt file and the .par file.

**References**

For additional information, please consult the Synopsys Sentaurus manuals:

1) Sentaurus Process User Guide
2) Sentaurus Device User Guide
3) Sentaurus Visual Manual

Feel free to raise issues or submit contributions via this repository. Happy simulating! 🚀
