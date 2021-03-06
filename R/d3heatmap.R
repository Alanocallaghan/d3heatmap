#' @import htmlwidgets
#' @importFrom grDevices col2rgb rgb
#' @importFrom stats as.dendrogram dendrapply dist hclust is.leaf order.dendrogram reorder sd
NULL

`%||%` <- function(a, b) {
  if (!is.null(a))
    a
  else
    b
}

#' D3 Heatmap widget
#'
#' Creates a D3.js-based heatmap widget.
#'
#' @param x A numeric matrix
#'   Defaults to \code{TRUE} unless \code{x} contains any \code{NA}s.
#' @param main Plot title
#' @param theme A custom CSS theme to use. Currently the only valid values are
#'   \code{""} and \code{"dark"}. \code{"dark"} is primarily intended for
#'   standalone visualizations, not R Markdown or Shiny.
#' @param scalecolors Colors to be used in scale. Length
#' must be equal to breaks
#' @param na_color Color of NA values in heatmap. Defaults to black
#' @param colors TEMPORARILY DISABLED WHILE TRANSITIONING
#' METHOD FOR GENERATING COLORS. USE scalecolors INSTEAD.
#' Either a colorbrewer2.org palette name (e.g. \code{"YlOrRd"} or
#'   \code{"Blues"}), or a vector of colors to interpolate in hexadecimal
#'   \code{"#RRGGBB"} format, or a color interpolation function like
#'   \code{\link[grDevices]{colorRamp}}.
#' @param show_color_legend Show color key and density
#'    information? (TRUE/FALSE)
#' @param colorkey_title Name of color key
#' @param breaks Analagous to heatmap.2 breaks. Should
#'   be the same number of breaks as colors
#' @param symbreaks Breaks symmetrical around zero?
#' @param width Width in pixels (optional, defaults to automatic sizing).
#' @param height Height in pixels (optional, defaults to automatic sizing).
#'
#' @param xaxis_height Size of axes, in pixels.
#' @param yaxis_width Size of axes, in pixels.
#' @param xaxis_font_size Font size of axis labels, as a CSS size (e.g. "14px" or "12pt").
#' @param yaxis_font_size Font size of axis labels, as a CSS size (e.g. "14px" or "12pt").
#'
#' @param brush_color The base color to be used for the brush. The brush will be
#'   filled with a low-opacity version of this color. \code{"#RRGGBB"} format
#'   expected.
#' @param show_grid \code{TRUE} to show gridlines, \code{FALSE} to hide them, or
#'   a numeric value to specify the gridline thickness in pixels (can be a
#'   non-integer).
#' @param anim_duration Number of milliseconds to animate zooming in and out.
#'   For large \code{x} it may help performance to set this value to \code{0}.
#'
#' @param Rowv determines if and how the row dendrogram should be reordered.	By default, it is TRUE, which implies dendrogram is computed and reordered based on row means. If NULL or FALSE, then no dendrogram is computed and no reordering is done. If a dendrogram, then it is used "as-is", ie without any reordering. If a vector of integers, then dendrogram is computed and reordered based on the order of the vector.
#' @param Colv determines if and how the column dendrogram should be reordered.	Has the options as the Rowv argument above and additionally when x is a square matrix, Colv = "Rowv" means that columns should be treated identically to the rows.
#' @param distfun function used to compute the distance (dissimilarity) between both rows and columns. Defaults to dist.
#' @param hclustfun function used to compute the hierarchical clustering when Rowv or Colv are not dendrograms. Defaults to hclust.
#' @param dendrogram character string indicating whether to draw 'none', 'row', 'column' or 'both' dendrograms. Defaults to 'both'. However, if Rowv (or Colv) is FALSE or NULL and dendrogram is 'both', then a warning is issued and Rowv (or Colv) arguments are honoured.
#' @param reorderfun function(d, w) of dendrogram and weights for reordering the row and column dendrograms. The default uses stats{reorder.dendrogram}
#'
#' @param k_row an integer scalar with the desired number of groups by which to color the dendrogram's branches in the rows (uses \link[dendextend]{color_branches})
#' @param k_col an integer scalar with the desired number of groups by which to color the dendrogram's branches in the columns (uses \link[dendextend]{color_branches})
#'
#' @param symm logical indicating if x should be treated symmetrically; can only be true when x is a square matrix.
#' @param revC logical indicating if the column order should be reversed for plotting.
#' Default (when missing) - is FALSE, unless symm is TRUE.
#' This is useful for cor matrix.
#'
#' @param scale character indicating if the values should be centered and scaled in either the row direction or the column direction, or none. The default is "none".
#' @param na.rm logical indicating whether NA's should be removed.
#'
#' @param digits integer indicating the number of decimal places to be used by \link{round} for 'label'.
#' @param cellnote (optional) matrix of the same dimensions as \code{x} that has the human-readable version of each value, for displaying to the user on hover. If \code{NULL}, then \code{x} will be coerced using \code{\link{as.character}}.
#' If missing, it will use \code{x}, after rounding it based on the \code{digits} parameter.
#' @param cellnote_scale logical (default is FALSE). IF cellnote is missing and x is used,
#' should cellnote be scaled if x is also scaled?
#'
#' @param cexRow positive numbers. If not missing, it will override \code{xaxis_font_size}
#' and will give it a value cexRow*14
#' @param cexCol positive numbers. If not missing, it will override \code{yaxis_font_size}
#' and will give it a value cexCol*14
#'
#' @param ColSideFactors (optional) character vector of length ncol(x) containing
#'   the color names for a horizontal side bar that may be used to annotate the
#'   columns of x.
#' @param ColSideColors An alias for ColSideFactors.
#' @param row_side_palette,col_side_palette A vector of colours used to generate
#'  the row or column side colour bar.
#' @param RowSideFactors (optional) character vector of length nrow(x) containing
#'   the color names for a vertical side bar that may be used to annotate the
#'   rows of x.
#' @param RowSideColors An alias for RowSideFactors.
#' @param col_cols,row_cols Colors to be used in RowSideColors and ColSideColors respectively
#' @param labRow character vectors with row labels to use (from top to bottom); default to rownames(x).
#' @param labCol character vectors with column labels to use (from left to right); default to colnames(x).
#' @param padding css/html padding around app
#'
#' @param ... Undocumented/experimental options (currently \code{xcolors_height} and \code{ycolors_width})
#'
#' @import htmlwidgets
#'
#' @export
#' @source
#' The interface was designed based on \link{heatmap} and \link[gplots]{heatmap.2}
#'
#' @seealso
#' \link{heatmap}, \link[gplots]{heatmap.2}
#'
#' @examples
#' library(d3heatmap)
#' d3heatmap(mtcars, scale = "column", colors = "Blues")
#'
#'
d3heatmap <- function(x,
  main = "Heatmap",
  ## dendrogram control
  Rowv = TRUE,
  Colv = if (symm) "Rowv" else TRUE,
  distfun = dist,
  hclustfun = hclust,
  dendrogram = c("both", "row", "column", "none"),
  reorderfun = function(d, w) reorder(d, w),

  k_row,
  k_col,

  symm = FALSE,
  revC,

  ## data scaling
  scale = c("none", "row", "column"),
  na.rm = TRUE,

  ColSideFactors = ColSideColors,
  RowSideFactors = RowSideColors,

  RowSideColors = NULL,
  ColSideColors = NULL,

  row_side_palette = c("purple", "orange", "black"),
  col_side_palette = c("cyan", "maroon", "green"),

  labRow = rownames(x),
  labCol = colnames(x),

  cexRow,
  cexCol,
  na_color="#000000",
  ## value formatting
  digits = 3L,
  cellnote,
  cellnote_scale = FALSE,

  ##TODO: decide later which names/conventions to keep
  theme = NULL,
  colors = "RdYlBu",
  breaks=30,
  scalecolors = NULL,
  symbreaks=FALSE,
  colorkey_title="Value",
  show_color_legend = TRUE,

  col_cols=NULL,
  row_cols=NULL,

  width = NULL,
  height = NULL,
  xaxis_height = 80,
  yaxis_width = 120,
  xaxis_font_size = NULL,
  yaxis_font_size = NULL,
  brush_color = "#0000FF",
  show_grid = TRUE,
  anim_duration = 500,
  padding=0,
  ...
) {

  ## x is a matrix!
  ##====================
  if(!is.matrix(x)) {
    x <- as.matrix(x)
  }
  if(!is.matrix(x)) stop("x must be a matrix")

  nr <- dim(x)[1]
  nc <- dim(x)[2]
  ### TODO: debating if to include this or not:
  #   if(nr <= 1 || nc <= 1)
  #     stop("`x' must have at least 2 rows and 2 columns")


  ## Labels for Row/Column
  ##======================
  rownames(x) <- labRow %||% paste(1:nrow(x))
  colnames(x) <- labCol %||% paste(1:ncol(x))

  if(!missing(cexRow)) {
    if(is.numeric(cexRow)) {
      xaxis_font_size <- cexRow * 14
    } else {
      warning("cexRow is not numeric. It is ignored")
    }
  }
  if(!missing(cexCol)) {
    if(is.numeric(cexCol)) {
      yaxis_font_size <- cexCol * 14
    } else {
      warning("cexCol is not numeric. It is ignored")
    }
  }


  ## Dendrograms for Row/Column
  ##=======================
  dendrogram <- match.arg(dendrogram)

  # Use dendrogram argument to set defaults for Rowv/Colv
  if (missing(Rowv)) {
    Rowv <- dendrogram %in% c("both", "row")
  }
  if (missing(Colv)) {
    Colv <- dendrogram %in% c("both", "column")
  }


  if (isTRUE(Rowv)) {
    Rowv <- rowMeans(x, na.rm = na.rm)
  }
  if (is.numeric(Rowv)) {
    Rowv <- reorderfun(as.dendrogram(hclustfun(distfun(x))), Rowv)
  }
  if (is.dendrogram(Rowv)) {
    Rowv <- rev(Rowv)
    rowInd <- order.dendrogram(Rowv)
    if(nr != length(rowInd))
      stop("Row dendrogram is the wrong size")
  } else {
    if (!is.null(Rowv) && !is.na(Rowv) && !identical(Rowv, FALSE))
      warning("Invalid value for Rowv, ignoring")
    Rowv <- NULL
    rowInd <- 1:nr
  }

  if (identical(Colv, "Rowv")) {
    Colv <- Rowv
  }
  if (isTRUE(Colv)) {
    Colv <- colMeans(x, na.rm = na.rm)
  }
  if (is.numeric(Colv)) {
    Colv <- reorderfun(as.dendrogram(hclustfun(distfun(t(x)))), Colv)
  }
  if (is.dendrogram(Colv)) {
    colInd <- order.dendrogram(Colv)
    if (nc != length(colInd))
      stop("Col dendrogram is the wrong size")
  } else {
    if (!is.null(Colv) && !is.na(Colv) && !identical(Colv, FALSE))
      warning("Invalid value for Colv, ignoring")
    Colv <- NULL
    colInd <- 1:nc
  }


  # TODO:  We may wish to change the defaults a bit in the future
  ## revC
  ##=======================
  if(missing(revC)) {
    if (symm) {
      revC <- TRUE
    } else if(is.dendrogram(Colv) & is.dendrogram(Rowv) & identical(Rowv, rev(Colv))) {
      revC <- TRUE
    } else {
      revC <- FALSE
    }
  }
  if(revC) {
    Colv <- rev(Colv)
    colInd <- rev(colInd)
  }

  ## reorder x (and others)
  ##=======================
  ## TODO: Sensible dimensions plus deal with data.frames
  x <- x[rowInd, colInd, drop = FALSE]
  if (!missing(cellnote))
    cellnote <- cellnote[rowInd, colInd]
  if (!is.null(RowSideFactors)) {
    if (is.data.frame(RowSideFactors)) {
      RowSideFactors <- as.matrix(RowSideFactors)
    }
    if (!is.matrix(ColSideFactors)) {
      RowSideFactors <- matrix(RowSideFactors, nrow = 1)
    }

    RowSideFactors <- RowSideFactors[rowInd, , drop = FALSE]

    if (is.matrix(RowSideFactors)) {
      rowcolor_colnames <- colnames(RowSideFactors)
    } else {
      rowcolor_colnames <- NULL
    }

    if (!is.matrix(RowSideFactors)) {
      RowSideFactors <- as.matrix(RowSideFactors)
    }
    rsc_labs <- unique(as.factor(RowSideFactors))
    row_cols <- colorRampPalette(row_side_palette)(length(rsc_labs))

  }
  if (!is.null(ColSideFactors)) {
    if (is.data.frame(ColSideFactors)) {
      ColSideFactors <- as.matrix(ColSideFactors)
    }
    if (!is.matrix(ColSideFactors)) {
      ColSideFactors <- matrix(ColSideFactors, nrow = 1)
    }
    ColSideFactors <- ColSideFactors[, colInd, drop = FALSE]


    if (is.matrix(ColSideFactors)) {
      colcolor_colnames <- colnames(ColSideFactors)
    } else {
      colcolor_colnames <- NULL
    }

    csc_labs <- unique(as.factor(ColSideFactors))
    col_cols <- colorRampPalette(col_side_palette)(length(csc_labs))
  }

  ## Dendrograms - Update the labels and change to dendToTree
  ##=======================

  # color branches?
  #----------------
    # Due to the internal working of dendextend, in order to use it we first need
      # to populate the dendextend::dendextend_options() space:
  if(!missing(k_row) | !missing(k_col)) dendextend::assign_dendextend_options()

  if(is.dendrogram(Rowv) & !missing(k_row)) {
    Rowv <- dendextend::color_branches(Rowv, k = k_row)
  }
  if(is.dendrogram(Colv) & !missing(k_col)) {
    Colv <- dendextend::color_branches(Colv, k = k_col)
  }

  rowDend <- if(is.dendrogram(Rowv)) dendToTree(Rowv) else NULL
  colDend <- if(is.dendrogram(Colv)) dendToTree(Colv) else NULL


  ## Scale the data?
  ##====================
  scale <- match.arg(scale)

  if(!cellnote_scale) x_unscaled <- x #keeps a backup for cellnote

  if(scale == "row") {
    x <- sweep(x, 1, rowMeans(x, na.rm = na.rm))
    x <- sweep(x, 1, apply(x, 1, sd, na.rm = na.rm), "/")
  }
  else if(scale == "column") {
    x <- sweep(x, 2, colMeans(x, na.rm = na.rm))
    x <- sweep(x, 2, apply(x, 2, sd, na.rm = na.rm), "/")
  }


  ## cellnote
  ##====================
  if(missing(cellnote)) {
    if(cellnote_scale) {
      cellnote <- round(x, digits = digits)
    } else { # default
      cellnote <- round(x_unscaled, digits = digits)
    }
  }

  # Check that cellnote is o.k.:
  if (is.null(dim(cellnote))) {
    if (length(cellnote) != nr*nc) {
      stop("Incorrect number of cellnote values")
    }
    dim(cellnote) <- dim(x)
  }
  if (!identical(dim(x), dim(cellnote))) {
    stop("cellnote matrix must have same dimensions as x")
  }


  ## Final touches before htmlwidgets
  ##=======================

  mtx <- list(
              x = as.numeric(t(round(x, digits=digits))),
              # data = as.character(t(cellnote)),
              dim = dim(x),
              rows = rownames(x),
              cols = colnames(x)
  )


  if (is.factor(x)) {
    colors <- scales::col_factor(colors, x, na.color = "transparent")
  } else {
    rng <- range(x, na.rm = TRUE)
    if (scale %in% c("row", "column")) {
      rng <- c(max(abs(rng)), -max(abs(rng)))
    }

    colors <- scales::col_numeric(colors, rng, na.color = "transparent")
  }


  imgUri <- encodeAsPNG(t(x), colors)
  options <- list(...)


  if(is.null(scalecolors)) {
    scalecolors <- colorRampPalette(c("blue", "white", "red"))(breaks + 1)
  } else if(is.character(scalecolors)) {
    scalecolors <- colorRampPalette(scalecolors)(breaks + 1)
  }

  side_colors <- list(
    col_cols=col_cols,
    row_cols=row_cols,
    rowcolor_colnames = if (exists("rowcolor_colnames", inherits = FALSE)) rowcolor_colnames
      else NULL,
    colcolor_colnames =  if (exists("colcolor_colnames", inherits = FALSE)) colcolor_colnames
      else NULL,
    rowcolors = if (!is.null(RowSideFactors)) RowSideFactors else NULL,
    colcolors = if (!is.null(ColSideFactors)) ColSideFactors else NULL
  )

  options <- c(options,
    list(
      xaxis_height = xaxis_height,
      yaxis_width = yaxis_width,
      xaxis_font_size = xaxis_font_size,
      yaxis_font_size = yaxis_font_size,
      brush_color = brush_color,
      show_grid = show_grid,
      anim_duration = anim_duration,
      breaks=breaks,
      symbreaks=symbreaks,
      colorkey_title=colorkey_title,
      colors=scalecolors,
      na_color=na_color,
      show_color_legend = show_color_legend
    )
  )

  if (is.null(rowDend)) {
    c(options, list(yclust_width = 0))
  }
  if (is.null(colDend)) {
    c(options, list(xclust_height = 0))
  }

  payload <- list(rows = rowDend,
    cols = colDend,
    matrix = mtx,
    side_colors = side_colors,
    title = main,
    image = imgUri,
    theme = theme, options = options)

  # create widget
  htmlwidgets::createWidget(
    name = 'd3heatmap',
    payload,
    width = width,
    height = height,
    package = 'd3heatmap',
    sizingPolicy = htmlwidgets::sizingPolicy(browser.fill = TRUE, padding=padding)
  )
}

#' @import png base64enc
encodeAsPNG <- function(x, colors) {
  colorData <- as.raw(col2rgb(colors(x), alpha = TRUE))
  dim(colorData) <- c(4, ncol(x), nrow(x))
  pngData <- png::writePNG(colorData)
  encoded <- base64enc::base64encode(pngData)
  paste0("data:image/png;base64,", encoded)
}

#' Wrapper functions for using d3heatmap in shiny
#'
#' Use \code{d3heatmapOutput} to create a UI element, and \code{renderD3heatmap}
#' to render the heatmap.
#'
#' @param outputId Output variable to read from
#' @param width,height The width and height of the map (see
#'   \link[htmlwidgets]{shinyWidgetOutput})
#' @param expr An expression that generates a \code{\link{d3heatmap}} object
#' @param env The environment in which to evaluate \code{expr}
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @examples
#' \donttest{
#' library(d3heatmap)
#' library(shiny)
#'
#' ui <- fluidPage(
#'   h1("A heatmap demo"),
#'   selectInput("palette", "Palette", c("YlOrRd", "RdYlBu", "Greens", "Blues")),
#'   checkboxInput("cluster", "Apply clustering"),
#'   d3heatmapOutput("heatmap")
#' )
#'
#' server <- function(input, output, session) {
#'   output$heatmap <- renderD3heatmap({
#'     d3heatmap(
#'       scale(mtcars),
#'       colors = input$palette,
#'       dendrogram = if (input$cluster) "both" else "none"
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
d3heatmapOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'd3heatmap', width, height, package = 'd3heatmap')
}

#' @rdname d3heatmapOutput
#' @export
renderD3heatmap <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, d3heatmapOutput, env, quoted = TRUE)
}

#' are_colors
#' Helper function to check for valid color strings
#' @param x color vector (etc) to test.
#'
#' Taken (untested) from:
#' http://stackoverflow.com/questions/13289009/check-if-character-string-is-a-valid-color-representation#13290832

are_colors <- function(x) {
  if(is.numeric(x)) return(FALSE)
  sapply(x, function(X) {
    res <- try(col2rgb(x),silent=TRUE)
    return(!"try-error"%in%class(res))
  })
}

