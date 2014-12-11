Perforce on Mac hacks
=====================

This project aims at building scripts and tools can be used to make life with Perforce on a Mac easier.

- __scripts__ contains scripts (bash or other) that need to be transformed into Automator scripts.

- __tools__ contains utility scripts for developing the workflows or scripts 

- __installers__ contains that can be run directly, or fed into bash from curl to install workflows or other tools

- __zips__ contains zipped versions of the automator workflows 

How it works
------------

The standard process starts with downloading a bash/perl/something script that typically downloads further files, and
places them in the right place on the user's home directory.

It works because executable can sit in the user's home directory, as long as -bash_profile is updated, or because
Automator workflows are nothing more than special folders with the suffix ".workflow" that sit in ~/Library/Services.

This makes it possible to install a workflow simply by downloading a zip file and unzipping it in the right place  

Workflows
---------

Workflows can be created almost directly from bash, python or perl scripts. However, one needs to exercise some caution:
the script does not get run inside the normal bash environment. As a consequence, the path may not be set in the same
way, and environmental variables may not be available.

Making it easy
==============

Services
--------

Once a workflow is created and debugged, it can be converted to a service. Services let the user quickly preform actions that
usually require launching additional programs and taking many steps, that usually are available through the application
menu - for example in PowerPoint it's the third item in the PowerPoint menu. A good explanation of services is found
[here](http://www.macworld.com/article/1163996/how_to_use_services_in_mac_os_x.html).

Applications
------------

Another way of making things easy for the user is creating an application from the workflow. This can be done manually from
Automator (Save as... and then choose application), or one can just download an app.

Sometimes the computer is configured to block apps downloaded from anywhere else but the Mac store to be run, a workaround
is to download the application as a workflow and _then_ to have the user convert it. This is easily done with a script that
looks like this:

     tell application "Automator"
	     set f to open alias POSIX file "/Users/myhome/Desktop/foo.workflow"
	     save f as "Application" in POSIX file "/Users/myhome/Desktop/foo.app"
	     quit
     end tell

where /Users/myhome/Desktop/foo.workflow is the original file and /Users/myhome/Desktop/foo.app becomes the application.

This can obviously run from the shell, in which case it could neatly be downloaded via curl and fed into bash to execute
without user interaction.