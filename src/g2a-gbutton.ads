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

with G2a.GContainer;     use G2a.GContainer;
with G2a.GProperty;      use G2a.GProperty;
with G2a.GEnumerations;  use G2a.GEnumerations;

package G2a.GButton is

   type Response_Id_Enum is (None, Reject, Accept_Response, Delete_Event,
                             OK, Cancel, Close, Yes, No, Apply, Help);
   type Button_Content_Enum is (Custom, Stock_Button, Label_With_Optional_Image);

   type Button_Block is new Container_Block with record
      Action                 : Action_Block;
      Border_Relief          : Border_Relief_Enum;
      Response_Id            : Response_Id_Enum;
      With_H_Child_Alignment : Boolean;
      With_V_Child_Alignment : Boolean;
      H_Child_Alignment      : Float;
      V_Child_Alignment      : Float;
      Focus_On_Click         : Boolean;
      Button_Content         : Button_Content_Enum;
      Add_Custom_Content     : Boolean;
      Image_Position         : Position_Enum;
      Always_Show_Image      : Boolean;
      Use_Stock              : Boolean;
      Stock_Id               : String_Access;
      Label_Name             : String_Access;
      Image                  : String_Access;
      Use_Underline          : Boolean;
   end record;
   type Button is access all Button_Block'Class;

   procedure Get_New (But : out Button;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Button_Block;
                                          P  : Property);

   Default_Add_Custom_Content : constant Boolean := True;
   Default_Button_Content     : constant Button_Content_Enum := Label_With_Optional_Image;
   Default_Response_Id        : constant Response_Id_Enum   := None;
   Default_With_H_Child_Alignment : constant Boolean := False;
   Default_With_V_Child_Alignment : constant Boolean := False;
   Default_H_Child_Alignment : constant Float := 0.50;
   Default_V_Child_Alignment : constant Float := 0.50;
   Default_Focus_On_Click    : constant Boolean := True;
   Default_Always_Show_Image : constant Boolean := False;
   Default_Use_Stock         : constant Boolean := False;
   Default_Stock_Button_Name : constant String_Access := null;
   Default_Label_Name        : constant String_Access := null;
   Default_Image             : constant String_Access := null;
   Default_Use_Underline     : constant Boolean := False;

   Default_Button_Block : constant
     Button_Block :=
       (Default_Container_Block
            with
        Action                 => Default_Action_Block,
        Border_Relief          => Default_Border_Relief,
        Response_Id            => Default_Response_Id,
        With_H_Child_Alignment => Default_With_H_Child_Alignment,
        With_V_Child_Alignment => Default_With_V_Child_Alignment,
        H_Child_Alignment      => Default_H_Child_Alignment,
        V_Child_Alignment      => Default_V_Child_Alignment,
        Focus_On_Click         => Default_Focus_On_Click,
        Button_Content         => Default_Button_Content,
        Add_Custom_Content     => Default_Add_Custom_Content,
        Image_Position         => Default_Position,
        Always_Show_Image      => Default_Always_Show_Image,
        Use_Stock              => Default_Use_Stock,
        Stock_Id               => Default_Stock_Button_Name,
        Label_Name             => Default_Label_Name,
        Image                  => Default_Image,
        Use_Underline          => Default_Use_Underline);

end G2a.GButton;
