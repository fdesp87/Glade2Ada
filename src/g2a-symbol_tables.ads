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
with G2a.GProperty;         use G2a.GProperty;
with GNATCOLL.Tribooleans;  use GNATCOLL.Tribooleans;
with G2a.GAttribute;        use G2a.GAttribute;

package G2a.Symbol_Tables is

   procedure Initialize;

   function Get_Node_Type (Obj : String) return GTK_Enum;

   function Get_Signal (Sgn : String) return Triboolean;

   function To_Gtk (N : GTK_Enum) return String;

   procedure Get_Property (S : String;
                           P : Property);

   procedure Get_Attribute (S : String; Att : Attribute);

   function Insert_Handler (H : String) return Boolean;

end G2a.Symbol_Tables;
