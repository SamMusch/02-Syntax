```
https://bookdown.org/mike/data_analysis/
```



### Initial

```r
options(warn=-1)
options(repr.matrix.max.cols = 50,
       repr.matrix.max.rows = 50)

suppressWarnings(suppressMessages(library(tidyverse)))
```

```r
title:
subtitle:
author:
date: "`r format(Sys.time(), '%b %d %Y')"
urlcolor: "blue"
output:
	html_document:
		css:
		toc: true
		toc_depth: 6
		toc_float: true
		code_folding: 'hide'
params:
	pwd:
		label: 'Enter the Password'
		value: ''
		input: password
	keys: !r c('A1', 'A2', 'B1', 'B2', 
             'U1', 'U2', 'S1', 'S2') #, 'UNK')
	qs_lim: 15
	st_d: '2021-05-05'
	end_d: !r lubridate::today()
	base_dir: '/Users/path/repo'
editor_options:
	chunk_output_type: inline
```



### Datatable

~~~r
library(plotly)
rstudio.github.io/DT/
scales
DT
gganimate
dygraphs


```{r table, echo = FALSE, fig.fullwidth = TRUE,
    fig.width = 10, fig.height = 6}

data %>% 
	datatable(extensions = 'Buttons',
           options = list(
           dom = 'Blfrtip',
           bottons = c('copy', 'csv', 'excel', 'pdf'),
           lengthMenu = list(
           c(10, 25, 50, -1),
           c(10, 25, 50, 'All'))))
```
~~~





```r
# File structure

# _knit_in_background.R
# docs
# markdown
# sql_and_scripts


fld <- 'my/path/folder'

my_render <- function(fn, pr, wd = 'my/path/folder') {
  sewd(wd)
	rmarkdown::render(
  	input = paste0('my/path/folder/markdown/', fn, '.Rmd'),
  	output_format = 'html_document',
  	output_dir = 'my/path/folder/docs/',
  	knit_root_dir = wd,
  	params = pr
  )
}

my_render('File_Name_Only', 
          pr = list(base_dir = fld), 
          wd = fld)


---

​```{sql, eval=FALSE, 
    code = readLines(paste0(params$base_dir,
                           'sql_and_scripts/___.sql'))}

​```
```



## Time Series

[Tsibble](tsibble.tidyverts.org)

[Tidyverts Book](https://tidyverts.github.io/tidy-forecasting-principles/)

[Time Series Book](https://otexts.com/fpp3/hts.html)



### Filter

```r
filter_all(all_vars(!is.infinite))

factor(data$col, 
       order = TRUE,
      levels = c('', ''))
```



### Plots

```r
# Distributions behind each other (ridge)
https://www.r-graph-gallery.com/294-basic-ridgeline-plot.html

# Big resource
https://socviz.co/refineplots.html
https://brshallo.github.io/r4ds_solutions/
data-to-viz.com/graph/density.html
bookdown.org/yihui/rmarkdown/blogdown-directory.html
```



