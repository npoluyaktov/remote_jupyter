FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN mkdir -p /opt/notebooks
COPY data /opt/notebooks
RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git /opt
RUN conda env create -f polyanka.yml
SHELL ["conda", "run", "-n", "polyanka", "/bin/bash", "-c"]
RUN conda install -c anaconda boost
RUN export LD_LIBRARY_PATH="/opt/conda/lib"
RUN export LIBRARY_PATH="/opt/conda/lib"
RUN export CPLUS_INCLUDE_PATH="/opt/conda/include"
RUN conda install jupyter -y --quiet
RUN python /opt/vowpal_wabbit/setup.py install
CMD ["conda", "run", "--no-capture-output", "-n", "polyanka", "jupyter", "notebook", "--notebook-dir", "/opt/notebooks", "--ip", "*", "--port", "8888", "--no-browser", "--allow-root"]