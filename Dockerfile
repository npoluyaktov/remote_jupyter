FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN cd /opt
RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git
RUN cd /opt/vowpal_wabbit/python
RUN conda install -c anaconda boost
RUN python setup.py install
RUN conda env create -f polyanka.yml
SHELL ["conda", "run", "-n", "polyanka", "/bin/bash", "-c"]
RUN export LD_LIBRARY_PATH="/opt/conda/lib"
RUN export LIBRARY_PATH="/opt/conda/lib"
RUN export CPLUS_INCLUDE_PATH="/opt/conda/include"
RUN conda install jupyter -y --quiet
RUN mkdir -p /opt/notebooks
COPY data /opt/notebooks
CMD ["conda", "run", "--no-capture-output", "-n", "polyanka", "jupyter", "notebook", "--notebook-dir", "/opt/notebooks", "--ip", "*", "--port", "8888", "--no-browser", "--allow-root"]