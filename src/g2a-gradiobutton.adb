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

with G2a.GObject;       use G2a.GObject;

package body G2a.GRadiobutton is

   ----------------------------------------------------------------------
   procedure Get_New (Rbt : out Radiobutton;
                      ID  : String := "") is
   begin
      Rbt := new Radiobutton_Block'(Default_Radiobutton_Block);
      Rbt.ID := new String'(ID);
      Rbt.Gtk_Class := Gtk_Radio_Button;
      Insert_In_Object_Table (Object (Rbt));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Radiobutton_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Group_Property =>
            declare
               Obj : constant Object := Get_Object_By_ID (P.String_Value.all);
            begin
               if Obj /= null then
                  OB.Group := Radiobutton (Obj);
               end if;
               return;
            end;
         when Inconsistent_Property =>
            OB.Inconsistent := P.Boolean_Value;
            return;
         when Draw_Indicator_Property =>
            OB.Draw_Indicator := P.Boolean_Value;
            return;
         when Active_Property =>
            OB.Active := P.Boolean_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Button_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GRadiobutton;
