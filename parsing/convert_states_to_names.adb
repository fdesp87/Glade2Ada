

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
with Ada.Strings;           use Ada.Strings;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with GNAT.Strings;          use GNAT.Strings;
with GNATCOLL.Utils;        use GNATCOLL.Utils;
with Ada.Containers.Vectors;

package body Convert_States_To_Names is

   package TIO renames Ada.Text_IO;

   package Vector_Pkg is new Ada.Containers.Vectors
     (Element_Type => String_Access,
      Index_Type   => Natural,
      "="          => "=");
   Name : Vector_Pkg.Vector := Vector_Pkg.Empty_Vector;

   Index : Natural;

   --------------------------------------------------------------------------
   function Process (S : String) return Boolean;
   function Process (S : String) return Boolean is
   begin
      if Trim (S, Both) /= "" then
         Name.Append (new String'(Trim (S, Both)));
      end if;
      return True;
   end Process;

   --------------------------------------------------------------------------
   procedure Initialize (Scanner_Filename : String) is
      SF   : TIO.File_Type;
      Line : String (1 .. 1024);
      Last : Natural;
   begin
      TIO.Open (SF, TIO.In_File, Scanner_Filename);

      Name.Append (new String'("INITIAL"));

      while not TIO.End_Of_File (SF) loop
         TIO.Get_Line (SF, Line, Last);
         Index := 1;
         Skip_Blanks (Line (1 .. Last), Index);
         if Index < Last then
            if Starts_With (Line (Index .. Last), "%s ") then
               Split (Line (Index + 2 .. Last), " ", Process'Access);
            elsif Starts_With (Line (Index .. Last), "%start ") then
               Split (Line (Index + 6 .. Last), " ", Process'Access);
            elsif Starts_With (Line (Index .. Last), "%x ") then
               Split (Line (Index + 6 .. Last), " ", Process'Access);
            end if;
         end if;
      end loop;

      TIO.Close (SF);
   end Initialize;

   --------------------------------------------------------------------------
   function  State_Name (I : Integer) return String is
   begin
      if I > Integer (Name.Length) then
         return "Invalid";
      end if;
      return Name.Element (I).all;
   end State_Name;

end Convert_States_To_Names;
