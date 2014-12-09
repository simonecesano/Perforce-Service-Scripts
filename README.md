Perforce on Mac hacks
=====================

This project aims at building scripts and tools can be used to make life with Perforce on a Mac easier.

- __scripts__ contains scripts (bash or other) that need to be transformed into Automator scripts.

- __tools__ contains utility scripts for developing the workflows or scripts 

- __installers__ contains that can be run directly, or fed into bash from curl to install workflows or other tools

- __zips__ contains zipped versions of the automator workflows 

How it works
------------

the standard process starts with downloading a bash/perl/something script that typically downloads further files, and
places them in the right place on the user's home directory.

It works because executable can sit in the user's home directory, as long as -bash_profile is updated, or because
Automator workflows are nothing more than special folders with the suffix ".workflow" that sit in ~/Library/Services.

This makes it possible to install a workflow simply by downloading a zip file and unzipping it in the right place  
