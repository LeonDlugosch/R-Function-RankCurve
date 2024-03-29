RankCurve = function(df, summarize = F, groups = NULL, col = NULL, lwd = 1, lty = 1, top_percent_only = 100,
                     main = "", ylab = "Relative abundance [%]", xlab = "Number of species", plot_legend = F, axes = T, na.action = "keep"){
  
  ### Checking and loading packages ###
  if(is.element("RColorBrewer", installed.packages()[,1]) == T){
    library(RColorBrewer)
  }else{
    stop("RColorBrewer package not installed")
  }
    if(is.element("dplyr", installed.packages()[,1]) == T){
    library(dplyr)
  }else{
    stop("dplyr package not installed")
  }
  #####################################
  
  ########## Data preparation #########
  if(is.null(col)){
    col = as.character(c("#ED5565", "#DA4453", "#B22222", "#FF7F50", "#FF6347", "#FF4500", "#FFCE54", "#F6BB42", "#A0D468",
                         "#8CC152", "#6B8E23", "#48CFAD", "#37BC9B", "#4FC1E9", "#3BAFDA", "#00BFFF", "#5D9CEC", "#4A89DC",
                         "#AC92EC", "#967ADC"))
  }else{col = as.character(col)}
  
  if(summarize == T){
    if(is.null(groups) | length(groups) != nrow(df)){stop("No valid grouping data provided!")}
    df = as.data.frame(SummarizeDataset(df = df, by = groups))
    if(na.action == "exclude"){
      df = Normalize100(df[which(!is.na(df[,1])),-1])
    }
    if(na.action == "keep"){
      df = Normalize100(df[,-1])
    }
  }
  
  if(summarize == F && !is.null(groups) && length(groups) == nrow(df)){
    if(na.action == "exclude"){
      if(is.null(groups) | length(groups) != nrow(df)){stop("No valid grouping data provided!")}
      df = Normalize100(df[which(!is.na(groups)),])
    }
    if(na.action == "keep"){
      df = Normalize100(df[,])
    }
    }

  if(summarize == F && is.null(groups)){
    df = Normalize100(df)
  }
  
  #####################################
  
  for (j in 1:ncol(df)){
    if (j == 1){
      vec.list = list()
      max.length = NULL
    }
    vec = rev(sort(df[,j]))
    vec = as.data.frame(vec[which(vec > 0)])
    vec.list[[j]] = vec
    max.length = c(max.length, nrow(vec.list[[j]]))
  }
  
  for (l in 1:length(vec.list)){
    vec.sorted = as.data.frame(vec.list[[l]])
    names(vec.sorted) = c("Abundance")
    vec.sorted$Rank = 1:nrow(vec.sorted) 
    vec.sorted$CumSum = 100 - cumsum(vec.sorted$Abundance)
    
    if (plot_legend == T && l == 1){
      col = colorRampPalette(col)(length(max.length))
      layout(matrix(c(2,2,2,1,2,2,2,1,2,2,2,1,2,2,2,1), nrow=4, ncol = 4, byrow = T))
      plot(0,0, type = "n", axes = F, main = "", xlab = "", ylab = "")
      legend("center", legend = names(df), col = col, lty = lty, lwd = lwd, xpd = NA, bty = "n")
    }
    if (plot_legend == F && l == 1){
      col = colorRampPalette(col)(length(max.length))
      par(mfrow = c(1,1))
      }
    
    if (l == 1){
      plot(x = c(0,vec.sorted$Rank), y = c(100,vec.sorted$CumSum),
           type = "l", main = main, xlab = xlab, ylab = ylab,
           xlim = c(0, (max(max.length)*(top_percent_only/100))), las = 1, axes = axes,
           col = col[l], lwd = lwd)
      
    }else{
      lines(x = c(0,vec.sorted$Rank), y = c(100,vec.sorted$CumSum),
            col = col[l], lwd = lwd)  
    }
  }
}

