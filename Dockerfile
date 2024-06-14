FROM continuumio/miniconda3:latest
WORKDIR /app
COPY . .
RUN mkdir -p /opt/notebooks
COPY data /opt/notebooks
RUN git submodule update --init --recursive
RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git /opt/vowpal_wabbit
RUN conda env create -f polyanka.yml
SHELL ["conda", "run", "-n", "polyanka", "/bin/bash", "-c"]
RUN conda install -c anaconda cmake ninja rapidjson spdlog fmt boost zlib flatbuffers
RUN conda install -c conda-forge gxx
RUN conda install jupyter -y --quiet
WORKDIR /opt/vowpal_wabbit
RUN cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE:STRING="Release" \
    -DFMT_SYS_DEP:BOOL="ON" \
    -DRAPIDJSON_SYS_DEP:BOOL="ON" \
    -DSPDLOG_SYS_DEP:BOOL="ON" \
    -DVW_BOOST_MATH_SYS_DEP:BOOL="ON" \
    -DVW_GTEST_SYS_DEP:BOOL="ON" \
    -DVW_ZLIB_SYS_DEP:BOOL="ON" \
    -DBUILD_TESTING:BOOL="OFF"
RUN cmake --build build
CMD ["conda", "run", "--no-capture-output", "-n", "polyanka", "jupyter", "notebook", "--notebook-dir", "/opt/notebooks", "--ip", "*", "--port", "8888", "--no-browser", "--allow-root"]