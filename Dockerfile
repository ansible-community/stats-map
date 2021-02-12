# Base image
FROM rocker/r-ver:4.0.3

# Deps
RUN apt-get update && apt-get install -y  gdal-bin git-core libcurl4-openssl-dev libgdal-dev libgeos-dev libgeos++-dev libgit2-dev libicu-dev libpng-dev libsasl2-dev libssl-dev libudunits2-dev libxml2-dev make pandoc pandoc-citeproc && rm -rf /var/lib/apt/lists/*

# Setup
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("renv")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone

# Packages
# RUN R -e 'install.packages("stringi", force = TRUE)' #why is this needed?
RUN R -e 'renv::init()'
RUN R -e 'renv::restore()'

# Go!
EXPOSE 3838
CMD  ["R", "-e", "options('shiny.port'=3838,shiny.host='0.0.0.0');AnsibleMap::run_app()"]

# Build with
# sudo docker build -t ansible_map:latest . --no-cache && matrix -m "build complete"
