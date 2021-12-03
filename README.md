# InstrControl-MATLAB
Instrument control codes using MATLAB environment

Prerequisites can be specific instrument drivers, or general drivers such as NI-VISA

This project is also used as a Github practice object.

The vision is that there won't be 10 versions of RCWA circulating within the group in the future.



# Naming conventions:

Every instrument will be a MATLAB class and have its own .m file. Each instrument class will have one property, which will be the instrument handle once it opens, and a series of methods, which are some wrapper functions to do everyday tasks, such as reading a waveform on an oscilloscope.

Other folders are self-explanatory. Some scripts may involve multiple instruments, some may involve interchangable instruments (e.g. you can use this oscilloscope or that oscilloscope). What instruments are used should be pretty clear once you see the class initiation codes. Still, clear annotations will always be helpful, too.


# Usage of the codes:

If you decide to use GitHub to clone this repository, in the event of you contributing to the codes in the future, you can add the repository path to your MATLAB path, which will then give MATLAB access to all the .m class files. You can then put the measurement scripts and, consequently, generated data elsewhere so they don't interfere with this repository. 
This is the recommended way to use these codes, as there are always more wrapper methods that can be added to each instrument class.

If you only decide to use these codes as they are, then just download the codes as a .zip file, extract them somewhere and do whatever you might need.

# Contributing to the library

Updating exisiting .m class files are relatively straightforward in the GitHub logic if you did the clone repository method mentioned above. Simply send a pull request after you applied changes to the .m class files. The changes can be anything from new wrapper functions to improved robustness of exisiting wrapper functions, tidier annotations, and many more. All contributions will be appreciated by others who use these instruments in the future!

If you need to create a new .m class file for a new instrument, you can start with an existing one. Most instruments should support some form of SCPI standards, so a lot of the commands are actually directly usable from one instrument to another. For example, WAV:DATA? is often the same query command for waveform data on many different oscilloscopes. Some time can be saved here if you start from the .m file for another oscilloscope.

When adding a new wrapper function, your best guide is always the programming manual for that specific instrument. They usually have a full list of all the commands they support, the syntax, and, often times, example commands.