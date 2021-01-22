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
	wget -O cellranger-4.0.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-4.0.0.tar.gz?Expires=1611379168&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci00LjAuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MTEzNzkxNjh9fX1dfQ__&Signature=Lp7RnnKiSWlNz~R4R9aMK7Od3PUNjfg8dRmcG0xdp4ZA4vrx8m8IVUcLP3zylXMnbys6QvcBJq2EiG2Cz0BNGmMNm-G27cN8s6y06Ao2j0oCKc8OxCVCqmZ220MnHKlSiy1sOaAVbTKa92yV38kPrBdinFWHOtw41YOpkOU3BEwExvQ~OCatjZRdwfOqXqSe0JO-MUlOKOS8MyLeUrR~2NhD6yF8S7hnwPN3~2r5w90lPwG1mei4X0~bGrXahFgzfRl1Sg0sLTytNE2D-QS5mXyGLd~4gybXmTPCSuzzuBNuyQ6l-SAA444EdeAXf~sfJXyTDCRRglFtrs5ZF4EbZg__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA" && \	
	tar -xzvf cellranger-4.0.0.tar.gz && \
	rm -f cellranger-4.0.0.tar.gz

# Set path
ENV PATH /opt/cellranger-4.0.0:$PATH