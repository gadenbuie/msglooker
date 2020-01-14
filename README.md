
# msglooker

<!-- badges: start -->
<!-- badges: end -->

A small Shiny app to break an Outlook message out of its proprietary format and into an HTML document.

![](https://i.imgur.com/3G5qxpJ.gif)

## Installation

You can install the released version of msglooker from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("gadenbuie/msglooker")
```

## How To Use

``` r
library(msglooker)

## Run the Shiny app
msg_look_app()

## Or convert a .msg into an .html
msg2html("email.msg", "email.html")
```

***

## Thanks

Built using the [msgxtractor](https://github.com/hrbrmstr/msgxtractr) package by Bob Rudis and the [base64enc](https://cran.r-project.org/web/packages/base64enc/) package by Simon Urbanek.
