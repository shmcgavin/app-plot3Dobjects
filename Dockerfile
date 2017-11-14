
FROM neurodebian:nd16.04

MAINTAINER Lindsey Kitchell <kitchell@indiana.edu>

RUN apt update && \
    apt install -y git python-vtk python-numpy python-scipy python-pip
RUN pip install h5py dicom six Cython scipy tables opencv-python
RUN git clone https://github.com/nipy/nibabel.git /nibabel
RUN cd /nibabel && python setup.py build_ext --inplace
RUN git clone https://github.com/nipy/dipy.git /dipy
RUN cd /dipy && PYTHONPATH=/nibabel python setup.py build_ext --inplace
RUN git clone https://github.com/cgoldberg/xvfbwrapper.git /xvfbwrapper
RUN cd /xvfbwrapper && PYTHONPATH=/xvfbwrapper python setup.py build_ext --inplace

COPY main.py /main.py
COPY render3D.py /render3D.py 

ENV PYTHONPATH /dipy:$PYTHONPATH
ENV PYTHONPATH /nibabl:$PYTHONPATH
ENV PYTHONPATH /xvfbwrapper:$PYTHONPATH

RUN mkdir /output && ldconfig

WORKDIR /output
ENTRYPOINT ["/main.py"]
