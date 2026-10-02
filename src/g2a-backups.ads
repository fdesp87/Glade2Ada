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

package G2a.Backups is

   --  function Perform_Patch (The_Path          : String;
   --                          Filename_With_Ext : String) return Integer;

   function Perform_Chop (Ada_Path  : String;
                          Filename  : String) return Integer;

   procedure Generate_Backups (The_Path     : String;
                               Filename     : String;
                               Main_Program : Boolean;
                               Max_Gen      : in out Integer);

   function Generate_Diffs (The_Path       : String;
                            Lower_Filename : String;
                            Main_Program   : Boolean;
                            Max_Gen        : Integer) return Integer;

end G2a.Backups;
