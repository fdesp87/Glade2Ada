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

package G2a.Emit_Ada is

   function Sp (N : Integer) return String;
   procedure Insert_Your_Code (Spaces : Integer;
                               Marker : String);
   procedure Include_Banner;
   function Quoted (M : String) return String;

   function Date_Picker_Name (Obj : not null Object) return String;
   function Is_Date_Picker (Obj : not null Object) return Boolean;
   function Is_Date_Picker_Calendar (Obj : not null Object) return Boolean;
   function Is_Date_Picker_Button (Obj : not null Object) return Boolean;
   function Is_Date_Picker_Year_Entry (Obj : not null Object) return Boolean;
   function Is_Date_Picker_Month_Entry (Obj : not null Object) return Boolean;
   function Is_Date_Picker_Day_Entry (Obj : not null Object) return Boolean;

   function Time_Picker_Name (Obj : not null Object) return String;
   function Is_Time_Picker (Obj : not null Object) return Boolean;
   function Is_Time_Picker_Button (Obj : not null Object) return Boolean;
   function Is_Time_Picker_Hour_Entry (Obj : not null Object) return Boolean;
   function Is_Time_Picker_Min_Entry (Obj : not null Object) return Boolean;
   function Is_Time_Picker_Sec_Entry (Obj : not null Object) return Boolean;

   procedure Emit_Package_Spec (Pkgname : String;
                                Prev_Line : Boolean := True);
   procedure Emit_Package_Body (Pkgname  : String;
                                Prev_Line : Boolean := True);
   procedure Emit_Package_End (Pkgname  : String;
                               Prev_Line : Boolean := True);
   procedure Emit_With_Use (Pkg : String);
   procedure Emit_Without_Use (Pkg : String);

   function Generate_Ada_Packages return Integer;

end G2a.Emit_Ada;
