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

with G2a.GCellrenderer; use G2a.GCellrenderer;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GAttribute;   use G2a.GAttribute;

package G2a.GCellrenderertoggle is

   type Cellrenderertoggle_Block is new Cellrenderer_Block with record
      Activatable_Column        : Integer := -1;
      Toggle_State_Column       : Integer := -1;
      Radio_State_Column        : Integer := -1;
      Inconsistent_State_Column : Integer := -1;
      Indicator_Size_Column     : Integer := -1;
   end record;

   type Cellrenderertoggle is access all Cellrenderertoggle_Block'Class;

   procedure Get_New (Cr : out Cellrenderertoggle;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Cellrenderertoggle_Block;
                                          P  : Property);

   overriding procedure Process_Attribute (OB : in out Cellrenderertoggle_Block;
                                           A  : Attribute);

   Default_Cellrenderertoggle_Block : constant Cellrenderertoggle_Block :=
                                        (Default_Cellrenderer_Block with
                                        others => -1);

end G2a.GCellrenderertoggle;
