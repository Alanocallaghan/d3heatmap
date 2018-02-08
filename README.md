___

# Fork of d3heatmap to add colorlegend and row/column bar labels
___

Note: this repository is not under active development. 
Bug reports and feature requests are welcome, but 
may not be implemented quickly. It is recommended to 
instead use a more recent package, such as [heatmaply](https://github.com/talgalili/heatmaply)
or [iheatmapr](https://github.com/ropensci/iheatmapr)

[![Build Status](https://travis-ci.org/Alanocallaghan/d3heatmap.svg?branch=master)](https://travis-ci.org/Alanocallaghan/d3heatmap)

# D3 Heatmap for R

This is an R package that implements a heatmap [htmlwidget](http://htmlwidgets.org). It has the following features:

* Highlight rows/columns by clicking axis labels
* Click and drag over colormap to zoom in (click on colormap to zoom out)
* Optional clustering and dendrograms, courtesy of `base::heatmap`

New functionality:

* Color legend and histogram
* ColSideColors and RowSideColors legend
* Mouseover for ColSideColors and RowSideColors

### Example

https://jsfiddle.net/jhhf67qv/13/

### Installation

To install:

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("Alanocallaghan/d3heatmap")

Alternatively you can download the package as an archive and install locally using `devtools::install()`, eg:
`devtools::install("[path_to_package]/d3heatmap")`
```

### Usage

Like any htmlwidget, you can visualize a d3 heatmap directly from the R console:

```r
library(d3heatmap)
d3heatmap(mtcars, scale = "column", colors = "Spectral")
```

You can also include them in R Markdown chunks, or use them in Shiny applications with the `d3heatmapOutput` and `renderD3heatmap` functions.

You can also create standalone pages using 
`htmlwidgets::saveWidget()`, eg


    install("./d3heatmap")

    library("d3heatmap")
    d <- d3heatmap(mtcars, 
        main = "mtcars demo", 
        scale = "column", 
        RowSideColors = t(mtcars[, c("cyl", "gear")]),
        show_grid = FALSE,
        cellnote_scale = TRUE,
        symbreaks = TRUE
    )
    
    htmlwidgets::saveWidget(d, file="testd3.html", selfcontained=TRUE)

See `?d3heatmap` for options.
