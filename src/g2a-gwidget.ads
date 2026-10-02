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
with G2a.GProperty;     use G2a.GProperty;
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GWidget is

   type Widget_Flags_Enum is (Visible, Can_Focus, Can_Default, App_Paintable,
                              No_Show_All, Has_Focus, Has_Default, Double_Buffered,
                              Sensitive, Is_Focus, Receives_Default);
   Default_Widget_Flag_Visible          : constant Boolean := False;
   Default_Widget_Flag_Can_Focus        : constant Boolean := False;
   Default_Widget_Flag_Can_Default      : constant Boolean := False;
   Default_Widget_Flag_App_Paintable    : constant Boolean := False;
   Default_Widget_Flag_No_Show_All      : constant Boolean := False;
   Default_Widget_Flag_Has_Focus        : constant Boolean := False;
   Default_Widget_Flag_Has_Default      : constant Boolean := False;
   Default_Widget_Flag_Double_Buffered  : constant Boolean := True;
   Default_Widget_Flag_Sensitive        : constant Boolean := True;
   Default_Widget_Flag_Is_Focus         : constant Boolean := False;
   Default_Widget_Flag_Received_Default : constant Boolean := False;

   type Widget_Flags_Array is array (Widget_Flags_Enum) of Boolean;
   Default_Widget_Flags : constant Widget_Flags_Array :=
                            (Visible          => Default_Widget_Flag_Visible,
                             Can_Focus        => Default_Widget_Flag_Can_Focus,
                             Can_Default      => Default_Widget_Flag_Can_Default,
                             App_Paintable    => Default_Widget_Flag_App_Paintable,
                             No_Show_All      => Default_Widget_Flag_No_Show_All,
                             Has_Focus        => Default_Widget_Flag_Has_Focus,
                             Has_Default      => Default_Widget_Flag_Has_Default,
                             Double_Buffered  => Default_Widget_Flag_Double_Buffered,
                             Sensitive        => Default_Widget_Flag_Sensitive,
                             Is_Focus         => Default_Widget_Flag_Is_Focus,
                             Receives_Default => Default_Widget_Flag_Received_Default);

   type Margin_Enum is (Top_Margin, Bottom_Margin, Start_Margin, End_Margin,
                       Left_Margin, Right_Margin);
   Default_Top_Margin    : constant Natural := 0;
   Default_Bottom_Margin : constant Natural := 0;
   Default_Start_Margin  : constant Natural := 0;
   Default_End_Margin    : constant Natural := 0;
   Default_Left_Margin   : constant Natural := 0;
   Default_Right_Margin  : constant Natural := 0;

   type Margin_Array is array (Margin_Enum) of Natural;
   Default_Margin_Array : constant Margin_Array :=
                            (Top_Margin    => Default_Top_Margin,
                             Bottom_Margin => Default_Bottom_Margin,
                             Start_Margin  => Default_Start_Margin,
                             End_Margin    => Default_End_Margin,
                             Left_Margin   => Default_Left_Margin,
                             Right_Margin  => Default_Right_Margin);

   type Resize_Mode_Enum is (Parent, Queue, Immediate);
   Default_Resize_Mode : constant Resize_Mode_Enum := Parent;

   type Tooltip_Block is record
      Custom_Tooltip     : Boolean;
      Use_Markup_Tooltip : Boolean;
      Text               : Text_Block;
   end record;
   Default_Tooltip_Block : constant Tooltip_Block
     := Tooltip_Block'(Custom_Tooltip     => False,
                       Use_Markup_Tooltip => False,
                       Text               => Default_Text_Block);


   Default_Opacity                : constant Float   := 1.0;  --  range 0.0 .. 1.0
   Default_H_Expand_Flag          : constant Boolean := False;
   Default_H_Expand               : constant Boolean := False;
   Default_V_Expand_Flag          : constant Boolean := False;
   Default_V_Expand               : constant Boolean := False;
   Default_Width_Requested        : constant Boolean := False;
   Default_Width_Request          : constant Natural := 0;
   Default_Height_Requested       : constant Boolean := False;
   Default_Height_Request         : constant Natural := 0;
   Default_Border_Width_Requested : constant Boolean := False;
   Default_Border_Width           : constant Natural := 0;

   type Widget_Block is new Object_Block with record
      Name                   : String_Access;
      Style_Classes          : Integer;  --  pending
      Tooltip                : Tooltip_Block;
      Opacity                : Float;    -- range 0.0 .. 1.0
      Accelerators           : String_Access;  --  pending
      Events                 : String_Access;
      Resize_Mode            : Resize_Mode_Enum;
      Widget_Flags           : Widget_Flags_Array;
      H_Expand_Flag          : Boolean;
      H_Expand               : Boolean;
      V_Expand_Flag          : Boolean;
      V_Expand               : Boolean;
      H_Align                : Alignment_Enum;
      V_Align                : Alignment_Enum;
      Margins                : Margin_Array;
      Width_Requested        : Boolean;
      Width_Request          : Natural;
      Height_Requested       : Boolean;
      Height_Request         : Natural;
      Border_Width_Requested : Boolean; --  only for windows
      Border_Width           : Natural; --  only for windows
      Next_Focus             : access all Widget_Block'Class;
   end record;
   type Widget is access all Widget_Block'Class;

   procedure Get_New (Wdg : out Widget;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Widget_Block;
                                          P  : Property);

   Default_Widget_Block : constant Widget_Block :=
                            (Default_Object_Block with
                             Name                   => null,
                             Style_Classes          => 0,  --  pending
                             Tooltip                => Default_Tooltip_Block,
                             Opacity                => Default_Opacity,
                             Accelerators           => null,  --  pending
                             Events                 => null,
                             Resize_Mode            => Default_Resize_Mode,
                             Widget_Flags           => Default_Widget_Flags,
                             H_Expand_Flag          => Default_H_Expand_Flag,
                             H_Expand               => Default_H_Expand,
                             V_Expand_Flag          => Default_V_Expand_Flag,
                             V_Expand               => Default_V_Expand,
                             H_Align                => Default_Alignment,
                             V_Align                => Default_Alignment,
                             Margins                => Default_Margin_Array,
                             Width_Requested        => Default_Width_Requested,
                             Width_Request          => Default_Width_Request,
                             Height_Requested       => Default_Height_Requested,
                             Height_Request         => Default_Height_Request,
                             Border_Width_Requested => Default_Border_Width_Requested,
                             Border_Width           => Default_Border_Width,
                             Next_Focus             => null);

   function Is_Widget (Obj : not null Object) return Boolean;

   ----------------------------------------------------------------------

   procedure Insert_In_Focus_Chain (Wdg : Widget);

end G2a.GWidget;
