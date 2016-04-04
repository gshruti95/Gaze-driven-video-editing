# Gaze-driven-video-editing

This is an implementation of the 2015 paper in the ACM Transactions on Graphics by Jain et al.
The project page can be seen at http://www.cise.ufl.edu/~ejain/VideoRe-editing.html

To run the implementation:-

Run 'minimization.m' with the appropriate csv file in the csv_files directory
Each entry in the csv file corresponds to eye tracking data observed for a frame in the original video.
The output is a plot of the final cropping window path along with the output frames.
In 'croppath.m' change the directory path to folder which contains the input frames.

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
