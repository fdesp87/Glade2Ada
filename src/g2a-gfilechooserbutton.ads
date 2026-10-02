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

with G2a.GFilechooserdialog;    use G2a.GFilechooserdialog;
with G2a.GProperty;             use G2a.GProperty;

package G2a.GFilechooserbutton is

   type Filechooserbutton_Block is new Filechooserdialog_Block with record
      The_Title              : Text_Block;
      The_Dialog             : String_Access;
      Width_In_Characters    : Integer;
      Focus_On_Click         : Boolean;
   end record;
   type Filechooserbutton is access all Filechooserbutton_Block'Class;

   procedure Get_New (Fcb : out Filechooserbutton;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Filechooserbutton_Block;
                                          P  : Property);

   Default_Width_In_Characters    : constant Integer := -1;
   Default_Focus_On_Click         : constant Boolean := True;


   Default_Filechooserbutton_Block : constant
     Filechooserbutton_Block :=
       (Default_Filechooserdialog_Block
            with
        The_Title              => Default_Text_Block,
        The_Dialog             => null,
        Width_In_Characters    => Default_Width_In_Characters,
        Focus_On_Click         => Default_Focus_On_Click);

end G2a.GFilechooserbutton;
