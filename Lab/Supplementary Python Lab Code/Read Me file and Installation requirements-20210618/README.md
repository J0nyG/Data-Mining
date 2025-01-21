# data-mining-python

Install Annaconda with Python: https://www.anaconda.com/products/individual

First create a conda environment for DataMining, go into the Annaconda terminal, run the following:

> conda create --name DataMining python=3.7
> conda activate DataMining
> pip install -r requirements.txt

Add the DataMining kernel to all jupyter notebook

> conda activate DataMining
>conda install ipykernel
>ipython kernel install --user --name=DataMiningPython
>conda deactivate

To use run the jupyter notebook, open an Annaconda terminal, and run the following:

> conda activate DataMining
> jupyter lab .

Select the DataMiningPython kernel instead of Python 3 kernel.