FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN conda install jupyter -y --quiet
RUN conda env create -f polyanka.yml
RUN mkdir -p /opt/notebooks
ENTRYPOINT exec jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root