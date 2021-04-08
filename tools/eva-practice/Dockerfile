# Set the base image to Ubuntu 16.04
FROM rocker/tidyverse:3.6.3

LABEL authors="alex.thiery@crick.ac.uk" \
      description="Practice Docker image"

# update apt-get and install TEST
RUN R -e "install.packages('getopt')"