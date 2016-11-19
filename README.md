# Gaze-driven-video-editing

This repository contains:
1. An implementation of the 2015 paper in the ACM Transactions on Graphics by Jain et al. 
Their project page can be seen at http://www.cise.ufl.edu/~ejain/VideoRe-editing.html <br/>
2. A work in progress to improve the system (l1-optimization directory), which can model 2-D movement. 


To run the implementation:-

Run `minimization.m` with the appropriate csv file in the csv_files directory
Each entry in the csv file corresponds to eye tracking data observed for a frame in the original video.
The output is a plot of the final cropping window path along with the output frames.
In `croppath.m` change the directory path to folder which contains the input frames. <br/>

Run `l1-main.m` in l1-optimization directory to test the second model. <br/>

The implementation has been tested on test videos of different scene types.

Test videos:-

1. Herbie Rides Again (waterfront scene)
2. Herbie Rides Again (chauffeur scene)
3. Analyze This (Hotel room conversation)
4. Analyze This (Hotel Shooting)
5. Fast Five (Stealing the vault)
6. Tranformers 3 (Highway chase)
7. Transformers 3 (Slow motion scene)
8. Batman vs Superman trailer
9. Brazil vs Germany 3rd goal
10. Matrix clip-1
11. Matrix clip-2
12. Harry Potter scene
13. Scene from a French theater drama
