FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN mkdir -p /opt/notebooks
COPY data /opt/notebooks
RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git /opt/vowpal_wabbit
RUN conda env create -f polyanka.yml
SHELL ["conda", "run", "-n", "polyanka", "/bin/bash", "-c"]
RUN conda install -c anaconda cmake ninja rapidjson spdlog fmt boost zlib flatbuffers
RUN conda install jupyter -y --quiet
RUN python /opt/vowpal_wabbit/setup.py install
CMD ["conda", "run", "--no-capture-output", "-n", "polyanka", "jupyter", "notebook", "--notebook-dir", "/opt/notebooks", "--ip", "*", "--port", "8888", "--no-browser", "--allow-root"]