# Glade2Ada
Galde to Ada program helper

Oerview
-------
Given a Glade UI XML file, this program produces a serie of Ada files that help to build the GTK application in Ada.

The Ada pacakges produced are:

- the main form package
- the main window package
- the object collection package
- the register signal package
- the signal package
- the cell renderer package (in case of having treeviews)
- the stores numeration package
- the Ada main (if it is a main program)
- The GPR (if it is a main program)
- The CSS (if it is a main program)

The user must complete each form with the effective code for the signals.

The Glade UI CML file, for each form, must conform to the schema produced by the companion application
winforms2gtk, which converts a Microsoft Visual Basic Windows Form to a Glade UI XML file (really winforms2gtk
is able to produce also a old non-updated vesion of the Ada files; do not use this option, use instead the more
recent Glade2Ada).

Dependencies
------------

You should have the following tools installed:

- The GNAT Ada Compilation System, including GNAT Studio.. Ada Core Technologies (ACT) 
Community editions are OK
- GTK Libraries
- Glade
- The GtkAda library also from ACT
- The gnatcoll_core library

Building
--------
Use the gpr provided.

Note: Glade2Ada uses the result of Ada lexer and parser (aflex and ayacc, non reentrants) from Stephane Carrez (https://blog.vacs.fr/vacs/index.html).

Using
-----
Just type in the terminal glade2ada to obtain:

usage: glade2ada [options] Path/Filename
options:
-l             produce a log file
-n=lexfilename symbolic states, full path of lex filename
-d             parser in debug mode
-tpisa         produce a tree with objects, properties, items, signals and attributes
-A=Adapath     produce Ada code under Adapath
-m             produce Ada main/GPR/CSS

The first step is to obtain a Glade UI XML file. Use the winform2gtk program. Adjust the Visual Basic files until a satisfactory UI XML is obtained. Then apply glade2ada to obtain the Ada files, build the application, test and if necessary, ou can either touch the UI XML or go back to the Visual Basic files. 

Bug reports
-----------
Please send questions and bug reports to the author. Of course, any help/contributions are
welcome.
