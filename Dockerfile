FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN apt-get update
RUN apt-get install -y texlive texlive-latex-extra texlive-fonts-recommended dvipng cm-super
RUN mkdir -p /opt/notebooks
COPY data /opt/notebooks
RUN conda env create -f polyanka.yml
SHELL ["conda", "run", "-n", "polyanka", "/bin/bash", "-c"]
RUN conda install jupyter -y --quiet
RUN echo $CONDA_PREFIX
RUN pip install vowpalwabbit
RUN pip install giotto-tda
CMD ["conda", "run", "--no-capture-output", "-n", "polyanka", "jupyter", "notebook", "--notebook-dir", "/opt/notebooks", "--ip", "*", "--port", "8888", "--no-browser", "--allow-root"]