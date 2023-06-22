# Collective Migration

*Written by Frank Charbonier, Chaudhuri Lab, Stanford University, 2023*
*Adapted from work by Jacob Notbohm and Christian Franck, University of Wisconsin-Madison*
Analysis code for research on collective cell migration

## Required repositories

https://github.com/frank-charbonier/Cell-Velocity-Analysis
https://github.com/frank-charbonier/Cell-Traction-Stress-Velocity-Plots
https://github.com/frank-charbonier/Cell-Traction-Stress
https://github.com/takuno7/saveastiff
https://github.com/tamaskis/load_config-MATLAB/



## Files needed

*beads.tif*

*cells.tif*

*domain.tif*: binary mask of monolayer boundary generated from segmentation(background = black, foreground/cells = white)

*experiment-settings.txt*: see example in root folder

*analysis-settings.txt*: see example in root folder


## Files to run

*loop_through_datasets.m*: Use this to run batch analyses on multiple datsets within current working directory


## Additional Notes

It is a good idea to sanity-check the displacements produced after running FIDIC on your images (i.e., look at the cell velocities and the actual cell images to see if they make sense).




## Reference repositories
 
This code uses software written by and adapted from Jacob Notnohm and the Notbohm Research Group, and by the Franck Lab, both at University of Wisconsin-Madison.
https://github.com/FranckLab/FIDIC
https://github.com/jknotbohm/FIDIC
https://github.com/jknotbohm/Cell-Velocity-Analysis
https://github.com/jknotbohm/Cell-Traction-Stress
https://github.com/jknotbohm/Cell-Traction-Stress-Velocity-Plots

Also makes use of software from Matthew Heinrich and the Cohen lab at Princeton University:
https://github.com/heinrich-m/FreelyExpandingTissues
