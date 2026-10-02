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

with G2a.GBin;          use G2a.GBin;
with G2a.GProperty;     use G2a.GProperty;

package G2a.GMenuitem is

   type Menuitem_Block is new Bin_Block with record
      Right_Justified : Boolean;
      Use_Underline   : Boolean;
      Accel_Path      : String_Access;
      The_Label       : Text_Block;
      Action          : Action_Block;
   end record;

   type Menuitem is access all Menuitem_Block'Class;

   procedure Get_New (Mi : out Menuitem;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Menuitem_Block;
                                          P  : Property);

   Default_Right_Justified              : constant Boolean := False;
   Default_Use_Underline                : constant Boolean := False;

   Default_Menuitem_Block : constant Menuitem_Block :=
                              (Default_Bin_Block with
                               Right_Justified   => Default_Right_Justified,
                               Use_Underline     => Default_Use_Underline,
                               The_Label         => Default_Text_Block,
                               Action            => Default_Action_Block,
                               Accel_Path        => null);

end G2a.GMenuitem;
