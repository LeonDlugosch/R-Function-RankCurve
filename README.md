# R-Function-RankCurve
Function for quick and easy plotting of rank abundance curves for ecological abundance data,
including summarization functionality for different taxonomic levels and some filtering and plotting options. 
Outputs a rank abundance curve of basically any abundance matrix/dataframe.


## Defaults
```
RankCurve(df, summarize_by = NULL, col = NULL, lwd = 1, lty = 1, top_percent_only = 100,
                     main = "", ylab = "Relative abundance [%]", xlab = "Ranks", plot_legend = T, axes = T, na.action = "exclude")
```

## Generating some data for testing
```
df = as.data.frame(matrix(nrow = 20, ncol = 10))
for (i in 1:10){
  df[,i] = sample(100, 20)
  names(df)[i] = paste("Sample", i, sep = "_") 
}
df$Group = c(rep("A", 5), rep("B", 2), rep("C", 3), rep("D", 7), rep(NA, 3))

```
## Usage
Using default settings rank abundance curves are generated for every sample using the full dataset.
```
RankCurve(df[,1:10])
```

Data from unknown species can be excluded (e.g. unclassified sequencing data) by setting the "na.action" option to "exclude".
Of course, you need to specifies which group each row in the data belongs to.
In this case 3 rows are excluded from further analysis.
```
RankCurve(df[,1:10], na. exclude = "exclude", groups = df$Group)
```

The "groups" variable can also be used to summarize the whole dataset.
This is especially when you want to analyse the abundance profiles of your samples on different taxonomic levels.
```
RankCurve(df[,1:10], na. exclude = "exclude", groups = df$Group, summarize = T)
```

By setting plot_legend = T, you can plot a legend for the samples used for the rank abundance curves. 
```
RankCurve(df[,1:10], na. exclude = "exclude", groups = df$Group, summarize = T, plot_legend = T)
```




### Full List of options
```
df                dataframe or matrix containing count or abundance data of sample features (e.g. species, ASWs, OTUs, compounds, etc.)
group             vector containing species name or taxonomic level, mandatory if data should be summarized or filtered
summarize         toggle TRUE/FALSE to summarize data by "group" variable
na.action         handling of not unavailable classifications; option can be set to "exclude" to exclude all rows with NA as contained in the "groups"-variable 
top_percent_only  displays only x percent of most abundant species, this basically acts as a zoom, default = 100 (displays everything)

col               vector for rank abundance curve coloration, if not set, defaults colours are used
lty               set linetype
lwd               set linewidth
main              plot title
xlab              name of x-axis
ylab              name of x-axis
axes              should axes be plotted? default = TRUE
```
