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
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GCombobox is

   type Combobox_Block is new Bin_Block with record
      Treemodel               : String_Access;
      Id_Column               : Integer;
      Active_Item             : Integer;
      Active_Id               : String_Access;
      Button_Sensitivity      : Button_Sensitivity_Enum;
      Has_Entry               : Boolean;
      Draw_Frame_Around_Entry : Boolean;
      Entry_Text_Column       : Integer;
      Tearoff_Menus           : Boolean;
      Tearoff_Title           : Text_Block;
      Focus_On_Click          : Boolean;
      Popup_Fixed_Width       : Boolean;
      Wrap_Width              : Natural;
      Row_Span_Column         : Integer;
      Column_Span_Column      : Integer;
   end record;
   type Combobox is access all Combobox_Block'Class;

   procedure Get_New (Cbb : out Combobox;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Combobox_Block;
                                          P  : Property);


   Default_Id_Column               : Integer := -1;
   Default_Active_Item             : Integer := -1;
   Default_Has_Entry               : Boolean := False;
   Default_Draw_Frame_Around_Entry : Boolean := True;
   Default_Entry_Text_Column       : Integer := -1;
   Default_Tearoff_Menus           : Boolean := False;
   Default_Focus_On_Click          : Boolean := True;
   Default_Popup_Fixed_Width       : Boolean := True;
   Default_Wrap_Width              : Natural := 0;
   Default_Row_Span_Column         : Integer := -1;
   Default_Column_Span_Column      : Integer := -1;

   Default_Combobox_Block : constant
     Combobox_Block :=
       (Default_Bin_Block
            with
      Treemodel               => null,
      Id_Column               => Default_Id_Column,
      Active_Item             => Default_Active_Item,
      Active_Id               => null,
      Button_Sensitivity      => Default_Button_Sensitivity,
      Has_Entry               => Default_Has_Entry,
      Draw_Frame_Around_Entry => Default_Draw_Frame_Around_Entry,
      Entry_Text_Column       => Default_Entry_Text_Column,
      Tearoff_Menus           => Default_Tearoff_Menus,
      Tearoff_Title           => Default_Text_Block,
      Focus_On_Click          => Default_Focus_On_Click,
      Popup_Fixed_Width       => Default_Popup_Fixed_Width,
      Wrap_Width              => Default_Wrap_Width,
      Row_Span_Column         => Default_Row_Span_Column,
      Column_Span_Column      => Default_Column_Span_Column);

end G2a.GCombobox;
