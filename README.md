# Online Short Spatial Ability Battery (OSSAB)

<!-- badges: start -->
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://tidyverse.org/lifecycle/#maturing)
[![Travis build status](https://travis-ci.org/fmhoeger/OSSAB.svg?branch=master)](https://travis-ci.org/fmhoeger/OSSAB)
[![Coverage status](https://codecov.io/gh/fmhoeger/OSSAB/branch/master/graph/badge.svg)](https://codecov.io/github/fmhoeger/OSSAB?branch=master)
<!-- badges: end -->

The OSSAB package contains spatial ability tests.


## Citation

We also advise mentioning the software versions you used,
in particular the versions of the `OSSAB`, `psychTestR`, and `psychTestRCAT` packages.
You can find these version numbers from R by running the following commands:

``` r
library(OSSAB)
library(psychTestR)
if (!require(devtools)) install.packages("devtools")
x <- devtools::session_info()
x$packages[x$packages$package %in% c("OSSAB", "psychTestR", "psychTestRCAT"), ]
```

## Installation instructions (local use)

1. If you don't have R installed, install it from here: https://cloud.r-project.org/

2. Open R.

3. Install the ‘devtools’ package with the following command:

`install.packages('devtools')`

4. Install the OSSAB package:

`devtools::install_github('fmhoeger/OSSAB')`


### Testing a participant

The `MRT_standalone()`, `PAT_standalone()`, `PFT_standalone()` and `SRT_standalone()` function is designed for real data collection.
In particular, the participant doesn't receive feedback during this version.

``` r
# Load the OSSAB package
library(OSSAB)

# Run the tests as if for a participant, using default settings,
# saving data, and with a custom admin password, e.g.
MRT_standalone(admin_password = "put-your-password-here")
```

You will need to enter a participant ID for each participant.
This will be stored along with their results.

Each time you test a new participant,
rerun the `MRT_standalone()`, `PAT_standalone()`, `PFT_standalone()` or `SRT_standalone()` function, and a new participation session will begin.

You can retrieve your data by starting up a participation session,
entering the admin panel using your admin password,
and downloading your data.
For more details on the psychTestR interface, 
see http://psychtestr.com/.

The OSSAB currently supports Russian (ru, default) and English (en).
You can select one of these languages by passing a language code as 
an argument to `OSSAB()`, e.g. `OSSAB(languages = "en")`,
or alternatively by passing it as an URL parameter to the test browser,
eg. http://127.0.0.1:4412/?language=DE (note that the `p_id` argument must be empty).

## Installation instructions (Shiny Server)

1. Complete the installation instructions described under 'Local use'.
2. If not already installed, install Shiny Server Open Source:
https://www.rstudio.com/products/shiny/download-server/
3. Navigate to the Shiny Server app directory.

`cd /srv/shiny-server`

4. Make a folder to contain your new Shiny app.
The name of this folder will correspond to the URL.

`sudo mkdir OSSAB`

5. Make a text file in this folder called `app.R`
specifying the R code to run the app.

- To open the text editor: `sudo nano OSSAB/app.R`
- Write the following in the text file:

``` r
library(OSSAB)
OSSAB(admin_password = "put-your-password-here")
```

- Save the file (CTRL-O).

6. Change the permissions of your app directory so that `psychTestR`
can write its temporary files there.

`sudo chown -R shiny OSSAB`

where `shiny` is the username for the Shiny process user
(this is the usual default).

7. Navigate to your new shiny app, with a URL that looks like this:
`http://my-web-page.org:3838/OSSAB

## Implementation notes

By default, the OSSAB  implementation always estimates participant abilities
using weighted-likelihood estimation.
We adopt weighted-likelihood estimation for this release 
because this technique makes fewer assumptions about the participant group being tested.
This makes the test better suited to testing with diverse participant groups
(e.g. children, clinical populations).

## Usage notes

- The OSSAB runs in a web browser.
- Image files are included in the package. All tests can be run offline.
