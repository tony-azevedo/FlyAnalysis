FlyAnalysis
===========

Routines to analyze data collected with FlySound acquisition software. FlySound and FlyAnalysis were written in MATLAB in order to use the data acquisition toolbox to interface with NI daq boards. FlySound stores acquired data in .mat files representing each trial, a.k.a. epoch, a block of time that typically falls before during and after a stimulus. Each trial is a MATLAB structure data type, with fields for each stream of data acquired, e.g. membrane potential and exposure times of a camera. FlyAnalysis includes example scripts and routines that leverage these native datatypes and file formats to quickly view and analyze data.

`quickShow.m` is the central data viewer. Calling `quickShow()` starts the routine from the current folder. QuickShow consists of a simple gui that allows the user to navigate through the trials in sequential order. To display each trial, a quickShow_<protocol_name>.m function must be found in the quickShow directory. Each quickShow_<protocol_name>.m function can be tailored to display the data acquired by each Protocol. To learn more about Protocols, see the FlySound documentation (coming soon).

For more script-like analysis routines, the Record directory contains example scripts, with different sections, to analyze data within and across experiments. As an example, a Record_<name>.m script my make several plots that together would go into a figure of a paper. Script_<script_name>.m files typically contain specific analyses which might be run in a section of a record. Often, Script_<name>.m files start as a section of a record and typically gets moved to its own file for readability of the Record_<name>.m, rather than to repeat a code snippet.

Finally, FlySound can acquire continuous data. FlyAnalysis provides routines, in the continousAnalysis directory, to extract individual trials from the continously acquired data and to save them to .mat files, so that the same trial based analysis can be done on those trial structures. In addition, `continousDataReader()` opens a simple viewer that allows the user to scan through recordings of continuous data, zoom in, annotate, and extract data.

Installation
------------

Requirements
^^^^^^^^^^^^
 - MATLAB 2017B or above
 - FlyAnalysis
 - FlySound

Toolboxes
^^^^^^^^^

MATLAB toolboxes are not necessary to simply open and view data. Some analysis scripts may require additional toolboxes. Typically those analysis scripts are for specific protocols that a user creates, such as protocols that acquire images along with analog or digital streams. 

Install FlyAnalysis
^^^^^^^^^^^^^^^^^^^

 - fork and clone the FlyAnalysis and FlySound repositories. 
 - Add the directory paths to MATLAB path.

TODO:
 - add an example experiment to the repo for users to play with.
 - generalize for any data path
 - create version names.

Data location and naming
------------------------

 FlyAnalysis does not assume a particular location for the data, but does assume a directory structure as follows. 
  - Assume the top level data location is in a directory Data on storage drive D:, assuming a windows operating system: 'D:\Data'. 
  - Each experiment is saved to its own folder, YYMMDD.
  - Each sample is saved to a sub folder, YYMMDD_F<N>_C<M>, where N is the nth fly of the day, and M is the mth cell of that fly, in the case where multiple cells can be recorded from the same fly. 
  - Each trial is named according to the protocol used to produce the trial

 A typical file location would thus be as follows: "D:\Data\230120\230120_F2_C1\LEDArduinoFlashControl_Raw_230120_F2_C1_1.mat"
 
Conventions
###########

Versions
--------

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

