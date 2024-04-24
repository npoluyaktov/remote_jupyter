FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN conda install jupyter -y --quiet
RUN conda env create -f polyanka.yml
RUN mkdir -p /opt/notebooks
CMD jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root