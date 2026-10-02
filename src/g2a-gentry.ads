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

with G2a.GWidget;       use G2a.GWidget;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GEntry is

   type Input_Hints_Enum is (None, SpellCheck, No_SpellCheck, Word_Completion,
                             Lowercase, Uppercase_Chars, Uppercase_Words,
                             Uppercase_Sentences,
                             Inhibit_On_Screen_Keyboard, Vertical_Writing,
                             Emoi_Support, No_Emoji_Support);
   type Input_Hints_Array is array (Input_Hints_Enum) of Boolean;

   type Entry_Block is new Widget_Block with record
      Max_Width_In_Characters    : Integer;
      Emoji_Icon                 : Boolean;
      Enable_Emoji_Completion    : Boolean;
      Completion                 : String_Access;
      Input_Purpose              : Input_Purpose_Enum;
      Inputs_Hint                : Input_Hints_Array;
      Maximun_Length             : Natural;
      Width_In_Chars             : Integer;
      H_Alignment                : Float;
      Visibility                 : Boolean;
      Invisible_Character_Flag   : Boolean;
      Invisible_Character        : Character;
      Has_Frame                  : Boolean;
      Shadow_Type                : Shadow_Type_Enum;
      Editable                   : Boolean;
      Overwrite_Mode             : Boolean;
      Caps_Lock_Warning          : Boolean;
      Activates_Default          : Boolean;
      Truncate_Multiline         : Boolean;
      Populate_All               : Boolean;
      Text                       : Text_Block;
      Text_Buffer                : String_Access;
      Placeholdertext            : Text_Block;
      Progress_Fraction          : Float;
      Progress_Pulse_Step        : Float;
      Primary_Stock_Icon         : String_Access;
      Primary_Icon_Name          : String_Access;
      Primary_Icon_Pixbuf        : String_Access;
      Primary_Icon_Tooltip       : Tooltip_Block;
      Primary_Icon_Sensitive     : Boolean;
      Primary_Icon_Activatable   : Boolean;
      Secondary_Stock_Icon       : String_Access;
      Secondary_Icon_Name        : String_Access;
      Secondary_Icon_Pixbuf      : String_Access;
      Secondary_Icon_Tooltip     : Tooltip_Block;
      Secondary_Icon_Sensitive   : Boolean;
      Secondary_Icon_Activatable : Boolean;
   end record;
   type Entry_Ptr is access all Entry_Block'Class;

   procedure Get_New (Ent : out Entry_Ptr;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Entry_Block;
                                          P  : Property);

   Default_Max_Width_In_Characters    : constant Integer := -1;
   Default_Emoji_Icon                 : constant Boolean := False;
   Default_Enable_Emoji_Completion    : constant Boolean := False;
   Default_Inputs_Hint                : constant Input_Hints_Array
   := (None => True, others => False);
   Default_Maximun_Length             : constant Natural := 0;
   Default_Width_In_Chars             : constant Integer := -1;
   Default_H_Alignment                : constant Float := 0.0;
   Default_Visibility                 : constant Boolean := False;
   Default_Invisible_Character_Flag   : constant Boolean := False;
   Default_Invisible_Character        : constant Character := '*';
   Default_Has_Frame                  : constant Boolean := True;
   Default_Entry_Shadow_Type          : constant Shadow_Type_Enum := In_Shadow;
   Default_Editable                   : constant Boolean := True;
   Default_Overwrite_Mode             : constant Boolean := False;
   Default_Caps_Lock_Warning          : constant Boolean := True;
   Default_Activates_Default          : constant Boolean := True;
   Default_Truncate_Multiline         : constant Boolean := False;
   Default_Populate_All               : constant Boolean := False;
   Default_Progress_Fraction          : constant Float := 0.0;
   Default_Progress_Pulse_Step        : constant Float := 0.10;
   Default_Primary_Icon_Sensitive     : constant Boolean := True;
   Default_Primary_Icon_Activatable   : constant Boolean := True;
   Default_Secondary_Icon_Sensitive   : constant Boolean := True;
   Default_Secondary_Icon_Activatable : constant Boolean := True;

   Default_Entry_Block : constant
     Entry_Block :=
       (Default_Widget_Block with
        Max_Width_In_Characters    => Default_Max_Width_In_Characters,
        Emoji_Icon                 => Default_Emoji_Icon,
        Enable_Emoji_Completion    => Default_Enable_Emoji_Completion,
        Completion                 => null,
        Input_Purpose              => Default_Input_Purpose,
        Inputs_Hint                => Default_Inputs_Hint,
        Maximun_Length             => Default_Maximun_Length,
        Width_In_Chars             => Default_Width_In_Chars,
        H_Alignment                => Default_H_Alignment,
        Visibility                 => Default_Visibility,
        Invisible_Character_Flag   => Default_Invisible_Character_Flag,
        Invisible_Character        => Default_Invisible_Character,
        Has_Frame                  => Default_Has_Frame,
        Shadow_Type                => Default_Entry_Shadow_Type,
        Editable                   => Default_Editable,
        Overwrite_Mode             => Default_Overwrite_Mode,
        Caps_Lock_Warning          => Default_Caps_Lock_Warning,
        Activates_Default          => Default_Activates_Default,
        Truncate_Multiline         => Default_Truncate_Multiline,
        Populate_All               => Default_Populate_All,
        Text                       => Default_Text_Block,
        Text_Buffer                => null,
        Placeholdertext            => Default_Text_Block,
        Progress_Fraction          => Default_Progress_Fraction,
        Progress_Pulse_Step        => Default_Progress_Pulse_Step,
        Primary_Stock_Icon         => null,
        Primary_Icon_Name          => null,
        Primary_Icon_Pixbuf        => null,
        Primary_Icon_Tooltip       => Default_Tooltip_Block,
        Primary_Icon_Sensitive     => Default_Primary_Icon_Sensitive,
        Primary_Icon_Activatable   => Default_Primary_Icon_Activatable,
        Secondary_Stock_Icon       => null,
        Secondary_Icon_Name        => null,
        Secondary_Icon_Pixbuf      => null,
        Secondary_Icon_Tooltip     => Default_Tooltip_Block,
        Secondary_Icon_Sensitive   => Default_Secondary_Icon_Sensitive,
        Secondary_Icon_Activatable => Default_Secondary_Icon_Activatable);

end G2a.GEntry;
