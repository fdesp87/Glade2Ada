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

with G2a.GAttribute;    use G2a.GAttribute;
with G2a.GMisc_Record;  use G2a.GMisc_Record;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GLabel is

   type Label_Block is new Misc_Record_Block with record
      Text                      : Text_Block;
      Use_Markup                : Boolean;
      Pattern                   : String_Access;
      Selectable                : Boolean;
      Use_Underline             : Boolean;
      Track_Visited_Links       : Boolean;
      Ellipsize                 : Ellipsize_Enum;
      Angle                     : Float;
      Justification             : Justification_Enum;
      Automatic_Wrap            : Boolean;
      Wrap_Mode                 : Wrap_Mode_Enum;
      Wrap_Only_On_New_Line     : Boolean;
      Ellipsize_Wrap_Lines      : Integer;
      Never_Wrap                : Boolean;
      Mnemonic_Widget           : String_Access;
      Width_In_Characters       : Integer;
      Max_Width_In_Characters   : Integer;
      Xpad                      : Integer;
      Ypad                      : Integer;
      Xalign                    : Float;
      Yalign                    : Float;
      With_Xpad                 : Boolean;
      With_Ypad                 : Boolean;
      With_Xalign               : Boolean;
      With_Yalign               : Boolean;
      --
      Attributes                : Attribute_List;
      Font_Desc_Attr            : String_Access;
      Style_Attr_Attr           : String_Access;
      Weight_Attr               : String_Access;
      Variant_Attr              : String_Access;
      Stretch_Attr              : String_Access;
      Scale_Attr                : String_Access;
      Underline_Attr            : String_Access;
      Strikethrough_Attr        : String_Access;
      Foreground_Attr           : String_Access;
      Background_Attr           : String_Access;
      Underline_Color_Attr      : String_Access;
      Strikethrough_Color_Attr  : String_Access;
      Gravity_Attr              : String_Access;
      Gravity_Hint_Attr         : String_Access;
      Size_Attr                 : String_Access;
      Absolute_Size_Attr        : String_Access;
   end record;

   type Label is access all Label_Block'Class;

   procedure Get_New (Lab : out Label;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Label_Block;
                                          P  : Property);
   procedure Process_Attribute (OB  : in out Label_Block;
                                Att : Attribute);

   Default_Use_Markup              : constant Boolean := False;
   Default_Selectable              : constant Boolean := False;
   Default_Use_Underline           : constant Boolean := False;
   Default_Track_Visited_Links     : constant Boolean := True;
   Default_Ellipsize_Wrap_Lines    : constant Integer := -1;
   Default_Angle                   : constant Float := 0.0;
   Default_Automatic_Wrap          : constant Boolean := False;
   Default_Wrap_Only_On_New_Line   : constant Boolean := False;
   Default_Never_Wrap              : constant Boolean := True;
   Default_Width_In_Characters     : constant Integer := -1;
   Default_Max_Width_In_Characters : constant Integer := -1;
   Default_Xpad                    : constant Integer := 0;
   Default_Ypad                    : constant Integer := 0;
   Default_Xalign                  : constant Float   := 0.5;
   Default_Yalign                  : constant Float   := 0.5;

   Default_Label_Block : constant Label_Block :=
     (Default_Misc_Record_Block with
      Text                    => Default_Text_Block,
      Use_Markup              => Default_Use_Markup,
      Pattern                 => null,
      Selectable              => Default_Selectable,
      Use_Underline           => Default_Use_Underline,
      Track_Visited_Links     => Default_Track_Visited_Links,
      Ellipsize               => Default_Ellipsize,
      Angle                   => Default_Angle,
      Justification           => Default_Justification,
      Automatic_Wrap          => Default_Automatic_Wrap,
      Wrap_Mode               => Default_Wrap_Mode,
      Wrap_Only_On_New_Line   => Default_Wrap_Only_On_New_Line,
      Ellipsize_Wrap_Lines    => Default_Ellipsize_Wrap_Lines,
      Never_Wrap              => Default_Never_Wrap,
      Width_In_Characters     => Default_Width_In_Characters,
      Max_Width_In_Characters => Default_Max_Width_In_Characters,
      Xpad                    => Default_Xpad,
      Ypad                    => Default_Ypad,
      Xalign                  => Default_Xalign,
      Yalign                  => Default_Yalign,
      With_Xpad               => False,
      With_Ypad               => False,
      With_Xalign             => False,
      With_Yalign             => False,

      Attributes              => Empty_Attribute_List,
      others                  => null);

end G2a.GLabel;
