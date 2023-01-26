# FlyAnalysis

Routines to analyze data collected with FlySound acquisition software. FlySound and FlyAnalysis were written in MATLAB in order to use the data acquisition toolbox to interface with NI daq boards. FlySound stores acquired data in .mat files representing each trial, a.k.a. epoch, a block of time that typically falls before during and after a stimulus. Each trial is a MATLAB structure data type, with fields for each stream of data acquired, e.g. membrane potential and exposure times of a camera. FlyAnalysis includes example scripts and routines that leverage these native datatypes and file formats to quickly view and analyze data.

`quickShow.m` is the central data viewer. Calling `quickShow()` starts the routine from the current folder. QuickShow consists of a simple gui that allows the user to navigate through the trials in sequential order. To display each trial, a quickShow_<protocol_name>.m function must be found in the quickShow directory. Each quickShow_<protocol_name>.m function can be tailored to display the data acquired by each Protocol. To learn more about Protocols, see the FlySound documentation.

For more script-like analysis routines, the Record directory contains example scripts, with different sections, to analyze data within and across experiments. As an example, a Record_<name>.m script my make several plots that together would go into a figure of a paper. Script_<script_name>.m files typically contain specific analyses which might be run in a section of a record. Often, Script_<name>.m files start as a section of a record and typically gets moved to its own file for readability of the Record_<name>.m, rather than to repeat a code snippet.

Finally, FlySound can acquire continuous data. FlyAnalysis provides routines, in the continousAnalysis directory, to extract individual trials from the continously acquired data and to save them to .mat files, as for discrete trial based analyasis. In addition, `continousDataReader()` opens a simple viewer that allows the user to scan through recordings of continuous data, zoom in, annotate, and extract data.

## Installation

### Requirements
 - MATLAB 2017B or above
 - FlyAnalysis
 - FlySound

### Toolboxes

MATLAB toolboxes are not necessary to simply open and view data. Some analysis scripts may require additional toolboxes. Typically those analysis scripts are for specific protocols that a user creates, such as protocols that acquire images along with analog or digital streams. 

### Install FlyAnalysis
 - fork and clone the FlyAnalysis and FlySound repositories. 
 - Add the directory paths to MATLAB

TODO:
 - add an example experiment to the repo for users to play with.
 - generalize for any data path
 - create version names.

## Versions
Master branch:
Clean install of FlyAnalysis routines.

Originally developed:
Wilson Lab
Dept of Neurobiology
Harvard Medical School

TutLabMaster branch:
Tuthill lab 
Department of Physiology and Biophysics
University of Washington

