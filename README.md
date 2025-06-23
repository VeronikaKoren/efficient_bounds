This code repository was written by Veronika Koren and Gabriel Matias Lorenz, members of the Institute of Neural Information Processing, Center for Molecular Neurobiology Hamburg,
University Medical Center Hamburg-Eppendorf, Hamburg, Germany. 

This code repository is associated with the paper _Firing rates and representational error in efficient spiking networks are bounded by design_ , authored by M Urdu, GM Lorenz, CP Huang, S Panzeri and V Koren, accepted to appear in proceedings of **The 34th International Conference on Artificial Neural Networks (ICANN 2025)**.

The copy of this repository is publicly available at Zenodo with the following DOI:

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15720893.svg)](https://doi.org/10.5281/zenodo.15720893)

In case of partial of complete use of the code, please cite the repository.

---------------------------------------

**How to open and run a script** 

a) open Matlab   
b) cd to the path …/this_repository/  
c) use the "Open" icon on the top left to open the desired script   
d) before running the script, Matlab issues a window about the file not being on the current path and asking to either Change the current folder or Add it to Path - choose Add to Path

**Dependencies**

a) Folder “get_result” contains scripts that generate results. Some of the scripts inside this folder also generate a figure.  
b) Folder “get_plot” contains scripts that generate a figure from computed results.   
c) Folder “function” contains functions used scripts in “get_results” and in “get_plot”.  
d) Folder "results" contains .mat files with simulation results.  
e) File optimal_params.m contains the default set of parameters.   
f) The PDF "Simulation details for efficient bounds" contains a table of default model parameters, specifications about numerical integration and other details useful for reproducing the numerical results.
