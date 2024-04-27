FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN conda env create -f polyanka.yml
SHELL ["conda", "run", "-n", "polyanka", "/bin/bash", "-c"]
RUN conda install jupyter -y --quiet
RUN mkdir -p /opt/notebooks
COPY data /opt/notebooks
CMD ["conda", "run", "--no-capture-output", "-n", "polyanka", "jupyter", "notebook", "--notebook-dir", "/opt/notebooks", "--ip", "*", "--port", "8888", "--no-browser", "--allow-root"]