The script "run_analysis.R" is commented in a way which explains each data transformation in detail.  Those comments
are summarized here as well.  I recommend reading each block of my code to see how each comment lines up with the transform.

The mean and std values columns of the raw data were extracted by the following method:
The documentation in "features_info.txt" clearly describes the mean of each feature as
being appended with "mean()" and the standard deviation of each feature being
appended as "std()".  Parsing the "features.txt" file with these rules results in 33
data points of each type, which is expected as a mean and std are typically computed
and reported together.

The column names corresponding to these variables in my dataset are the exact column names as used by the study
authors in "features_info.txt", as I feel that using the precise nomenclature is always the best way to avoid
confusion when working with another scientist(s) provided data.

The "tidyDataSet" file appends the text "mean-" to each column header, in order to signfy that it is a mean value, while
still maintaining the raw variable name.
