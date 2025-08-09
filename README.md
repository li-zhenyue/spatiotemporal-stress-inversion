# spatiotemporal-stress-inversion

Welcome to the Spatiotemporal Stress Field Inversion Program

This program is designed to perform stress field inversion using focal mechanism data.
Compared with the method of Hardebeck and Michael (2006), it features:

1.	Data Partitioning
   
    ⦁ Hardebeck & Michael (2006): Uses a regular grid to divide the study area.
    
    ⦁ This program: Groups earthquakes into stress regions using spatial clustering based on event locations.

3. Stress Field Calculation
   
    ⦁ Hardebeck & Michael (2006): Randomly selects one fault plane from the two nodal planes in each focal mechanism.
      This program: Uses an iterative approach, each time selecting the plane that is more prone to slip instability.
      
    ⦁ Unlike Hardebeck & Michael (2006), this program does not assume equal shear stress on all fault planes.

How to Use the Program

    ⦁ Run install.m to add the program to your MATLAB path.
    
    ⦁ Open SFI.m and run it section by section. Each section performs a specific task.
    
      Explanations are provided in the code for each section.
