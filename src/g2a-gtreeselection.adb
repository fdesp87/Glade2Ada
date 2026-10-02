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

package body G2a.GTreeselection is

   procedure Get_New (Ts : out Treeselection;
                      ID : String := "") is
   begin
      Ts := new Treeselection_Block'(Default_Treeselection_Block);
      Ts.ID := new String'(ID);
      Ts.Gtk_Class := Gtk_Tree_Selection;
      Insert_In_Object_Table (Object (Ts));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Treeselection_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Mode_Property =>
            OB.Selection_Mode := Convert_To_Selection_Mode (P.String_Value.all);
            return;
         when others => null;
      end case;
      --  call the parent to process parent's properties
      Object_Block (OB).Process_Property (P);
   end Process_Property;


end G2a.GTreeselection;
