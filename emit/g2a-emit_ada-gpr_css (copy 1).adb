------------------------------------------------------------------------------
--                 G L A D E    T O     A d a                               --
--                                                                          --
--                     Copyright (C) 2025 Juan L. Freniche                  --
--                                                                          --
-- This program is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. It is is distributed in the hope that it will be useful,        --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the file COPYING3.  If not, see <http://www.gnu.org/licenses/>.      --
--                                                                          --
------------------------------------------------------------------------------
with Ada.Text_IO;
with G2a.Version;
with G2a.Support;   use G2a.Support;

package body G2a.Emit_Ada.Gpr_Css is

   package TIO renames Ada.Text_IO;

   ---------------------------------------------------------------------------
   procedure GPR (Ada_Path : String; Filename : String) is
      GPRFile : TIO.File_Type;
   begin
      Log ("Generating gpr...");

      TIO.Create (File => GPRFile,
                  Mode => TIO.Out_File,
                  Name => Ada_Path & "/" & Filename & ".gpr");

      TIO.New_Line (GPRFile);
      TIO.Put_Line (GPRFile, "----------------------------------");
      TIO.Put_Line (GPRFile, "--  generated with glade2ada "
                    & G2a.Version.Version & "  --");
      TIO.Put_Line (GPRFile, "----------------------------------");
      TIO.New_Line (GPRFile);
      TIO.Put_Line (GPRFile, "with ""gnatcoll_core"";");
      TIO.Put_Line (GPRFile, "with ""gtkada"";");
      TIO.Put_Line (GPRFile, "with ""gtkada_contributions"";");
      TIO.Put_Line (GPRFile, "project "
                    & Filename
                    & " is");
      TIO.Put_Line (GPRFile, "   for Source_Dirs use ("".""); "
                    & "-- source files");
      TIO.Put_Line (GPRFile, "   for Object_Dir use ""./obj"";");
      TIO.Put_Line (GPRFile, "   for Main use ("""
                    & Filename
                    & ".adb"");");
      TIO.Put_Line (GPRFile, "   for Exec_Dir use "".."";");
      TIO.Put_Line (GPRFile, "   package Compiler is");
      TIO.Put_Line (GPRFile, "      for Switches (""Ada"") use");
      TIO.Put_Line (GPRFile, "        (""-g"","
                    & "             --  debug");
      TIO.Put_Line (GPRFile, "         ""-gnat2022"","
                    & "      --  Ada 2022");
      TIO.Put_Line (GPRFile, "         ""-gnatX"","
                    & "         --  GNAT extensions");
      TIO.Put_Line (GPRFile, "         ""-O0"","
                    & "            --  optimization level 0");
      TIO.Put_Line (GPRFile, "         ""-fstack-check"","
                    & "  --  stact check");
      TIO.Put_Line (GPRFile, "         ""-gnata"","
                    & "         --  enable assettions");
      TIO.Put_Line (GPRFile, "         ""-gnateE"","
                    & "        --  generate extra info in exception msgs");
      TIO.Put_Line (GPRFile, "         ""-gnatQ"","
                    & "         --  generate ALI even if illegalities");
      TIO.Put_Line (GPRFile, "         ""-gnatVa"","
                    & "        --  validity checking all");
      TIO.Put_Line (GPRFile, "         ""-gnaty"","
                    & "         --  enable built-in style checks");
      TIO.Put_Line (GPRFile, "         ""-gnaty3"","
                    & "        --  Identation level");
      TIO.Put_Line (GPRFile, "         ""-gnatya"","
                    & "        --  Check attribute casing");
      TIO.Put_Line (GPRFile, "         ""-gnatyb"","
                    & "        --  Blanks not allowed at statement end");
      TIO.Put_Line (GPRFile, "         ""-gnatyc"","
                    & "        --  Check comments, double space");
      TIO.Put_Line (GPRFile, "         ""-gnatye"","
                    & "        --  Check end/exit labels");
      TIO.Put_Line (GPRFile, "         ""-gnatyf"","
                    & "        --  No form feeds or vertical tabs");
      TIO.Put_Line (GPRFile, "         ""-gnatyh"","
                    & "        --  No horizontal tabs");
      TIO.Put_Line (GPRFile, "         ""-gnatyi"","
                    & "        --  Check if-then layout");
      TIO.Put_Line (GPRFile, "         ""-gnatyk"","
                    & "        --  Check keyword casing");
      TIO.Put_Line (GPRFile, "         ""-gnatyl"","
                    & "        --  Check layout");
      TIO.Put_Line (GPRFile, "         ""-gnatyM120"","
                    & "     --  Set maximum line length");
      TIO.Put_Line (GPRFile, "         ""-gnatyn"","
                    & "        --  Check casing of entities in Standard");
      TIO.Put_Line (GPRFile, "         ""-gnatyp"","
                    & "        --  Check pragma casing");
      TIO.Put_Line (GPRFile, "         ""-gnatyr"","
                    & "        --  Check references");
      TIO.Put_Line (GPRFile, "         ""-gnatys"","
                    & "        --  Check separate specs");
      TIO.Put_Line (GPRFile, "         ""-gnatyS"","
                    & "        --  Check no statements after then/else");
      TIO.Put_Line (GPRFile, "         ""-gnatyt"","
                    & "        --  Check token spacing");
      TIO.Put_Line (GPRFile, "--         ""-gnatwe"","
                    & "        --  warnings and style checks are errors");
      TIO.Put_Line (GPRFile, "         ""-gnatwa"","
                    & "        --  all optional warnings");
      TIO.Put_Line (GPRFile, "         ""-gnatwC"","
                    & "        --  Suppress warnings on conditionals");
      TIO.Put_Line (GPRFile, "         ""-gnatwJ"","
                    & "        --  Disable warnings on obsolescent features");
      TIO.Put_Line (GPRFile, "         ""-gnatwM"""
                    & "         --  Disable warnings on modified but "
                    & "unreferenced variables");
      TIO.Put_Line (GPRFile, "        );");
      TIO.Put_Line (GPRFile, "   end Compiler;");
      TIO.Put_Line (GPRFile, "   package Binder is");
      TIO.Put_Line (GPRFile, "      for Switches (""Ada"") use (""-E"");");
      TIO.Put_Line (GPRFile, "   end Binder;");
      TIO.Put_Line (GPRFile, "   package Builder is");
      TIO.Put_Line (GPRFile, "      for Switches (""Ada"") use (""-j2"");");
      TIO.Put_Line (GPRFile, "   end Builder;");
      TIO.Put_Line (GPRFile, "end "
                    & Filename
                    & ";");

      TIO.Close (GPRFile);
   end GPR;

   ---------------------------------------------------------------------------
   procedure CSS (Ada_Path : String; Filename : String) is
      CSSFile : TIO.File_Type;
   begin
      Log ("Generating css...");

      TIO.Create (File => CSSFile,
                  Mode => TIO.Out_File,
                  Name => Ada_Path & "/" & Filename & ".css");

      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "/********************************/");
      TIO.Put_Line (CSSFile, "/*  generated with glade2ada "
                    & G2a.Version.Version & "  */");
      TIO.Put_Line (CSSFile, "/********************************/");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "/* Colors */");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "@define-color bg_all        #CECECE; /* bg */");
      TIO.Put_Line (CSSFile, "@define-color bg_tab        #F8F8F8; /* notebook tab */");
      TIO.Put_Line (CSSFile, "@define-color bg_sel_tab    #A3B8CB; /* notebook selected tab */");
      TIO.Put_Line (CSSFile, "@define-color bg_hd         #EAEBEF; /* treeview header */");
      TIO.Put_Line (CSSFile, "@define-color bg_hover_hd   #F8F8F8; /* treeview header hovered */");
      TIO.Put_Line (CSSFile, "@define-color bg_tv_hd_ldg  #96B183; /* treeview header ledger */");
      TIO.Put_Line (CSSFile, "@define-color bg_even_row   #EEEEEE; /* treeview even row */");
      TIO.Put_Line (CSSFile, "@define-color bg_sel_row    #FFEF98; /* treeview selected row */");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "/* lost focus */");
      TIO.Put_Line (CSSFile, "window:backdrop menubar,");
      TIO.Put_Line (CSSFile, "window:backdrop toolbar,");
      TIO.Put_Line (CSSFile, "window:backdrop notebook tab:active {");
      TIO.Put_Line (CSSFile, "    opacity: 1;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "entry, spinbutton, combobox, button {");
      TIO.Put_Line (CSSFile, "    min-height: 23px;");
      TIO.Put_Line (CSSFile, "    padding-top: 0px;");
      TIO.Put_Line (CSSFile, "    padding-bottom: 0px;");
      TIO.Put_Line (CSSFile, "    border-width: 1px;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "combobox button.combo {");
      TIO.Put_Line (CSSFile, "    min-height: 23px;");
      TIO.Put_Line (CSSFile, "    padding-top: 0px;");
      TIO.Put_Line (CSSFile, "    padding-bottom: 0px;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "combobox cellview {");
      TIO.Put_Line (CSSFile, "    padding: 0px;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "spinbutton entry {");
      TIO.Put_Line (CSSFile, "    min-height: 23px;");
      TIO.Put_Line (CSSFile, "    padding-top: 0px;");
      TIO.Put_Line (CSSFile, "    padding-bottom: 0px;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "/* scrollbar */");
      TIO.Put_Line (CSSFile, ".scrollbar {");
      TIO.Put_Line (CSSFile, "   background-clip: padding-box");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "scrollbar slider {");
      TIO.Put_Line (CSSFile, "    min-width: 10px;");
      TIO.Put_Line (CSSFile, "    min-height: 10px;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "/* tooltip */");
      TIO.Put_Line (CSSFile, "tooltip, .tooltip {");
      TIO.Put_Line (CSSFile, "    background-color: black;");
      TIO.Put_Line (CSSFile, "    color: white;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "/* Menubar and Menus */");
      TIO.Put_Line (CSSFile, "menubar, menubar:backdrop {");
      TIO.Put_Line (CSSFile, "    border-style: solid;");
      TIO.Put_Line (CSSFile, "    border-color: @bg_all;");
      TIO.Put_Line (CSSFile, "    border-bottom-width: 1px;");
      TIO.Put_Line (CSSFile, "    border-top-width: 0px;");
      TIO.Put_Line (CSSFile, "    border-left-width: 0px;");
      TIO.Put_Line (CSSFile, "    border-right-width: 0px;");
      TIO.Put_Line (CSSFile, "    background-image: linear-gradient(to bottom, @bg_all, @bg_all);");
      TIO.Put_Line (CSSFile, "    color: #000000;");
      TIO.Put_Line (CSSFile, "    opacity: 1;");
      TIO.Put_Line (CSSFile, "    margin: 0px;");
      TIO.Put_Line (CSSFile, "    padding: 0px;");
      TIO.Put_Line (CSSFile, "    box-shadow: none;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "menubar > menuitem, ");
      TIO.Put_Line (CSSFile, "menubar > menuitem:backdrop,");
      TIO.Put_Line (CSSFile, "menubar > menuitem label, ");
      TIO.Put_Line (CSSFile, "menubar > menuitem label:backdrop {");
      TIO.Put_Line (CSSFile, "    color: #000000;");
      TIO.Put_Line (CSSFile, "    opacity: 1;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "menu, ");
      TIO.Put_Line (CSSFile, "menu:backdrop,");
      TIO.Put_Line (CSSFile, "menu popover,");
      TIO.Put_Line (CSSFile, "menu popover:backdrop {");
      TIO.Put_Line (CSSFile, "    color: #000000;");
      TIO.Put_Line (CSSFile, "    opacity: 1;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "menu menuitem,");
      TIO.Put_Line (CSSFile, "menu menuitem:backdrop,");
      TIO.Put_Line (CSSFile, "menu menuitem *,");
      TIO.Put_Line (CSSFile, "menu menuitem *:backdrop {");
      TIO.Put_Line (CSSFile, "    color: #000000;");
      TIO.Put_Line (CSSFile, "    opacity: 1;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "GtkMenuItem {");
      TIO.Put_Line (CSSFile, "    padding-top: 2px;");
      TIO.Put_Line (CSSFile, "    padding-bottom: 2px;");
      TIO.Put_Line (CSSFile, "    color: #000000;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "/* Toolbar */");
      TIO.Put_Line (CSSFile, "toolbar, toolbar:backdrop {");
      TIO.Put_Line (CSSFile, "    border-style: solid;");
      TIO.Put_Line (CSSFile, "    border-color: @bg_all;");
      TIO.Put_Line (CSSFile, "    border-bottom-width: 1px;");
      TIO.Put_Line (CSSFile, "    border-top-width: 0px;");
      TIO.Put_Line (CSSFile, "    border-left-width: 0px;");
      TIO.Put_Line (CSSFile, "    border-right-width: 0px;");
      TIO.Put_Line (CSSFile, "    background-image: linear-gradient(to bottom, @bg_all, @bg_all);");
      TIO.Put_Line (CSSFile, "    color: inherit;");
      TIO.Put_Line (CSSFile, "    opacity: 1;");
      TIO.Put_Line (CSSFile, "    margin: 0px;");
      TIO.Put_Line (CSSFile, "    padding: 0px;");
      TIO.Put_Line (CSSFile, "    box-shadow: none;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "toolbar button, toolbar button:backdrop {");
      TIO.Put_Line (CSSFile, "    color: inherit;");
      TIO.Put_Line (CSSFile, "    opacity: 1;");
      TIO.Put_Line (CSSFile, "    box-shadow: none;");
      TIO.Put_Line (CSSFile, "}");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "/* Notebook */");
      TIO.Put_Line (CSSFile, "/* empty */");
      TIO.New_Line (CSSFile);
      TIO.Put_Line (CSSFile, "/* TreeView Headers */");
      TIO.Put_Line (CSSFile, "GtkTreeView column-header .button:backdrop label,");
      TIO.Put_Line (CSSFile, "treeview header button:backdrop label {");
      TIO.Put_Line (CSSFile, "    color: inherit;");
      TIO.Put_Line (CSSFile, "    opacity: 1;");
      TIO.Put_Line (CSSFile, "}");

      TIO.Close (CSSFile);
   end CSS;

end G2a.Emit_Ada.Gpr_Css;
