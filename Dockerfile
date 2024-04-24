FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN conda env create -f polyanka.yml
RUN mkdir -p /opt/notebooks
CMD conda run -n polyanka python sgd_classif.py