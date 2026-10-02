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

with G2a.GFrame;        use G2a.GFrame;
with G2a.GProperty;     use G2a.GProperty;

package G2a.GAspectframe is

   type Aspectframe_Block is new Frame_Block with record
      H_Alignment : Float;
      V_Alignment : Float;
      Ratio       : Float;
      Obey_Child  : Boolean;
   end record;

   type Aspectframe is access all Aspectframe_Block'Class;

   procedure Get_New (Afr : out Aspectframe;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Aspectframe_Block;
                                          P  : Property);

   Default_H_Alignment : constant Float := 0.5;
   Default_V_Alignment : constant Float := 0.5;
   Default_Ratio       : constant Float := 1.0;
   Default_Obey_Child  : constant Boolean := True;

   Default_Aspectframe_Block : constant Aspectframe_Block :=
     (Default_Frame_Block with
      H_Alignment => Default_H_Alignment,
      V_Alignment => Default_V_Alignment,
      Ratio       => Default_Ratio,
      Obey_Child  => Default_Obey_Child);

end G2a.GAspectframe;
