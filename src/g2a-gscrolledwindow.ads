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

with G2a.GBin;           use G2a.GBin;
with G2a.GProperty;      use G2a.GProperty;
with G2a.GEnumerations;  use G2a.GEnumerations;

package G2a.GScrolledwindow is

   type Scrolledwindow_Block is new Bin_Block with record
      Shadow                    : Shadow_Type_Enum;
      Window_Placement_Set      : Boolean;
      Window_Placement          : Scrolledwindow_Placement_Enum;
      Kinetic_Scrolling         : Boolean;
      Overlay_Scrolling         : Boolean;
      Min_Content_Width         : Integer;
      Max_Content_Width         : Integer;
      Min_Content_Height        : Integer;
      Max_Content_Height        : Integer;
      Propagate_Natural_Width   : Boolean;
      Propagate_Natural_Height  : Boolean;
      H_Scrollbar_Policy        : Scrollbar_Policy_Enum;
      V_Scrollbar_Policy        : Scrollbar_Policy_Enum;
      H_Adjustment              : String_Access; --  pending
      V_Adjustment              : String_Access; --  pending
   end record;

   type Scrolledwindow is access all Scrolledwindow_Block'Class;

   procedure Get_New (Sw : out Scrolledwindow;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Scrolledwindow_Block;
                                          P  : Property);

   Default_Shadow                   : constant Shadow_Type_Enum := In_Shadow;
   Default_Window_Placement_Set     : constant Boolean := True;
   Default_Kinetic_Scrolling        : constant Boolean := True;
   Default_Overlay_Scrolling        : constant Boolean := True;
   Default_Min_Content_Width        : constant Integer := -1;
   Default_Max_Content_Width        : constant Integer := -1;
   Default_Min_Content_Height       : constant Integer := -1;
   Default_Max_Content_Height       : constant Integer := -1;
   Default_Propagate_Natural_Width  : constant Boolean := False;
   Default_Propagate_Natural_Height : constant Boolean := False;

   Default_Scrolledwindow_Block : constant Scrolledwindow_Block :=
      (Default_Bin_Block with
       Shadow                       => Default_Shadow,
       Window_Placement_Set         => Default_Window_Placement_Set,
       Window_Placement             => Default_Window_Placement,
       Kinetic_Scrolling            => Default_Kinetic_Scrolling,
       Overlay_Scrolling            => Default_Overlay_Scrolling,
       Min_Content_Width            => Default_Min_Content_Width,
       Max_Content_Width            => Default_Max_Content_Width,
       Min_Content_Height           => Default_Min_Content_Height,
       Max_Content_Height           => Default_Max_Content_Height,
       Propagate_Natural_Width      => Default_Propagate_Natural_Width,
       Propagate_Natural_Height     => Default_Propagate_Natural_Height,
       H_Scrollbar_Policy           => Default_Scrollbar_Policy,
       V_Scrollbar_Policy           => Default_Scrollbar_Policy,
       H_Adjustment                 => null,  --  pending
       V_Adjustment                 => null); --  pending

end G2a.GScrolledwindow;
