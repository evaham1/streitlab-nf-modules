# Set the base image to Ubuntu 16.04
FROM ubuntu:16.04

LABEL authors="alex.thiery@crick.ac.uk" \
      description="Docker image containing cellranger"

# update apt-get and install
RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

# Install cellranger
RUN cd /opt/ && \
	wget -O cellranger-4.0.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-4.0.0.tar.gz?Expires=1611627277&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci00LjAuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MTE2MjcyNzd9fX1dfQ__&Signature=DsG0QMLyLJ9fxy-TVch-i3DdWvJkzkRRjudZO9v5GZ4ZCGjviX95CT81UbPIsqg42D5gHw2eGbEpEk7r6q~wJqgdY4B2rHBCmfAVahgp5eYnKNwc-wH6GyvfI6YGD7HAWsR0LBWL5NLH5zkGHT8KYgLNh~40LwAJilVq5VMUd2ypHzGkWzQq4CHjNft0HIKilF6c9~11C8LMylBvAIHReZZ8KRyIzurg-S2UWickNRMTwdwksgtonUBGLNed4BpyfbYjcxeuePAaJWemktqBN0buBA4wi2R8H14FL2EUQGV9rnFXl8bSFSU5Ygj7aVlGso4bIxgGiqmVsCBt8EPFrA__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA" && \	
	tar -xzvf cellranger-4.0.0.tar.gz && \
	rm -f cellranger-4.0.0.tar.gz

# Set path
ENV PATH /opt/cellranger-4.0.0:$PATH