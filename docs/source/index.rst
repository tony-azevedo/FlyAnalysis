FlyAnalysis
===========

Routines to analyze data collected with FlySound acquisition software. FlySound and FlyAnalysis were written in MATLAB in order to use the data acquisition toolbox to interface with NI daq boards. FlySound stores acquired data in .mat files representing each trial, a.k.a. epoch, a block of time that typically falls before during and after a stimulus. Each trial is a MATLAB structure data type, with fields for each stream of data acquired, e.g. membrane potential and exposure times of a camera. FlyAnalysis includes example scripts and routines that leverage these native datatypes and file formats to quickly view and analyze data.

`quickShow.m` is the central data viewer. Calling `quickShow()` starts the routine from the current folder. QuickShow consists of a simple gui that allows the user to navigate through the trials in sequential order. To display each trial, a quickShow_<protocol_name>.m function must be found in the quickShow directory. Each quickShow_<protocol_name>.m function can be tailored to display the data acquired by each Protocol. To learn more about Protocols, see the FlySound documentation (coming soon).

For more script-like analysis routines, the Record directory contains example scripts, with different sections, to analyze data within and across experiments. As an example, a Record_<name>.m script my make several plots that together would go into a figure of a paper. Script_<script_name>.m files typically contain specific analyses which might be run in a section of a record. Often, Script_<name>.m files start as a section of a record and typically gets moved to its own file for readability of the Record_<name>.m, rather than to repeat a code snippet.

Check out the :doc:`usage` section for further information, including
how to :ref:`installation` the project.

installation
------------

.. note::

   This project is under active development.

Contents
--------

.. toctree::

   usage
   api
