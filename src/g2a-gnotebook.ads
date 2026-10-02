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

with G2a.GContainer;      use G2a.GContainer;
with G2a.GProperty;       use G2a.GProperty;
with G2a.GEnumerations;   use G2a.GEnumerations;

package G2a.GNotebook is

   type Notebook_Block is new Container_Block with record
      Show_Tabs           : Boolean;
      Show_Border         : Boolean;
      Start_Action        : Boolean;
      End_Action          : Boolean;
      Tab_Position        : Position_Enum;
      Group_Name          : String_Access;
      Scrollable          : Boolean;
      Enable_Popup        : Boolean;
   end record;

   type Notebook is access all Notebook_Block'Class;

   procedure Get_New (Nb  : out Notebook;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Notebook_Block;
                                          P  : Property);

   Default_Show_Tabs    : constant Boolean := True;
   Default_Show_Border  : constant Boolean := True;
   Default_Start_Action : constant Boolean := False;
   Default_End_Action   : constant Boolean := False;
   Default_Tab_Position : constant Position_Enum := Top;
   Default_Scrollable   : constant Boolean := False;
   Default_Enable_Popup : constant Boolean := False;

   Default_Notebook_Block : constant Notebook_Block :=
     (Default_Container_Block with
      Show_Tabs        => Default_Show_Tabs,
      Show_Border      => Default_Show_Border,
      Start_Action     => Default_Start_Action,
      End_Action       => Default_End_Action,
      Tab_Position     => Default_Tab_Position,
      Group_Name       => null,
      Scrollable       => Default_Scrollable,
      Enable_Popup     => Default_Enable_Popup);

end G2a.GNotebook;
