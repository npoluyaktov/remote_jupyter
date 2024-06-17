FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN mkdir -p /opt/notebooks
COPY data /opt/notebooks
RUN conda env create -f polyanka.yml
SHELL ["conda", "run", "-n", "polyanka", "/bin/bash", "-c"]
RUN conda install -c anaconda cmake ninja rapidjson spdlog fmt boost zlib flatbuffers
RUN conda install -c conda-forge gxx help2man binutils sysroot_linux-64=2.17
RUN conda install jupyter -y --quiet
RUN echo $CONDA_PREFIX
RUN pip install vowpalwabbit
CMD ["conda", "run", "--no-capture-output", "-n", "polyanka", "jupyter", "notebook", "--notebook-dir", "/opt/notebooks", "--ip", "*", "--port", "8888", "--no-browser", "--allow-root"]