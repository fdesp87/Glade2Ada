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
with G2a.GObject; use G2a.GObject;

package body G2a.GCalendar is

   procedure Get_New (Cal : out Calendar;
                      ID  : String := "") is
   begin
      Cal := new Calendar_Block'(Default_Calendar_Block);
      Cal.ID := new String'(ID);
      Cal.Gtk_Class := Gtk_Calendar;
      Insert_In_Object_Table (Object (Cal));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Calendar_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Year_Property =>
            OB.Year := P.Integer_Value;
            return;
         when Month_Property =>
            OB.Month := P.Integer_Value;
            return;
         when Day_Property =>
            OB.Day := P.Integer_Value;
            return;
         when Detail_Height_Rows =>
            OB.Details_Height := P.Integer_Value;
            return;
         when Detail_Width_Chars =>
            OB.Details_Width := P.Integer_Value;
            return;
         when Show_Heading_Property =>
            OB.Show_Heading := P.Boolean_Value;
            return;
         when Show_Day_Names_Property =>
            OB.Show_Day_Names := P.Boolean_Value;
            return;
         when No_Month_Change_Property =>
            OB.No_Month_Change := P.Boolean_Value;
            return;
         when Show_Week_Numbers_Property =>
            OB.Show_Week_Numbers := P.Boolean_Value;
            return;
         when Show_Details_Property =>
            OB.Show_Details := P.Boolean_Value;
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Widget_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GCalendar;
