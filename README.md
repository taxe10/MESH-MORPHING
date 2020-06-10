A) DATASET: The dataset is available as .RAR files in 2 parts each. Make sure to unzip the files before executing the codes.

  1. Fresh THz data: Mouse5B_Fresh.mat
  2. Block THz data: Mouse5B_Block.mat
  3. Pathology Mask: Pathology_Mouse5B_Mask.png
     This pathology mask identifies the regions within the pathology results, i.e. red blue represents cancer, red represents fat, are lumens, and white is the background.

Dataset description:

  1. ScanData: matrix with dimensions <y,x,t> representing the data of the THz scan. y and x are the positions of the scan where a signal was received while t is the 1024-point time-domain signal received at that position. Generally our basic imaging consists of looking at the maximum of the ScanData along the t-axis to get a 2D image with dimensions <x,y>.
  2. xrange: physical positions of the x-axis in the scan in millimeters.
  3. yrange: physical positions of the y-axis in the scan in millimeters.
  4. trange: time-domain axis of the reflected signal at each point in picoseconds in case you wish to plot individual time-domain signals.
  5. TissueMask: matrix with dimensions <y,x> that specifies the region of interest (pixels marked as 1).

B) MAIN FILES:

  1. Get_THz_Image: Creates the THz image based on the maximum peak of the time-domain data.
  2. Rotation: Aligns the pathology image with respect to the THz mask.
  3. main: Performs the mesh-morphing algorithm.

C) HOW TO RUN:

  1. Download all the files in the repository and save them in the same folder.
  2. Unzip the data files and make sure their names match the description in part A.
  3. Run Get_THz_Image.m to obtain the THz image shape, save it as a PNG file.
  4. Run Rotation.m to align the pathology mask with respect to the THz image, save this output as a PNG file.
     IMPORTANT: If black regions show up due to the rotation in the boundaries of the image, manually DELETE these regions before the next step.
  5. Run main.m and follow the instructions in the code.

For further details, please refer to: https://scholarworks.uark.edu/cgi/viewcontent.cgi?article=4276&context=etd
At the end of the document, there is an USER MANUAL for this work.

D) CHANGES:

To make any changes to the files, please refer to the comments included in the scripts.

E) CONTACT INFORMATION:

Tanny Chavez Esparza 

email: tachavez@email.uark.edu
