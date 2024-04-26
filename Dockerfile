FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN conda install jupyter -y --quiet
RUN conda env create -f polyanka.yml
RUN mkdir -p /opt/notebooks
CMD ["conda", "run", "--no-capture-output", "-n", "polyanka", "python", "test.py"]