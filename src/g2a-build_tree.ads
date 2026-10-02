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

package G2a.Build_Tree is

   procedure Create_Object (GtkObjName : String; Idq : String);
   procedure Close_Current_Object;
   procedure Attach_Signal (Name      : String;
                            Handler   : String;
                            User_Data : String;
                            Swap      : String;
                            After     : String);

   procedure Attach_Property (Name  : String; Value : String);
   procedure Attach_Translatable_String_Property (Name         : String;
                                                  Translatable : String;
                                                  Value        : String;
                                                  Context      : String := "";
                                                  Comments     : String := "");

   procedure Items_Start;
   procedure Attach_Item (Translatable : String;
                          Value        : String;
                          Context      : String := "";
                          Comments     : String := "");
   procedure Items_End;

   procedure Restart_Column_Number;
   procedure Attach_Integer_Column (Name : String);
   procedure Attach_Float_Column (Name : String);
   procedure Attach_Boolean_Column (Name : String);
   procedure Attach_String_Column (Name : String);
   procedure Attach_Buttonbox_Column (Name : String);

   procedure Attach_Liststore_Data_Start;
   procedure Attach_Liststore_Row_Data_Start (Col_Name : String);
   procedure Attach_Liststore_Row_Data (Col_Number : String;
                                    Col_Data   : String);
   procedure Attach_Liststore_Row_Data_End;
   procedure Attach_Liststore_Data_End;

   procedure Packing_Start;
   procedure Packing_End;

   procedure Attributes_Start;
   procedure Attach_Attribute (Name  : String; Value : String);
   procedure Attributes_End;

   procedure Attach_Mime_Type (Name : String);
   procedure Attach_Pattern (Name : String);

   Unknown_Object : exception;
   Unknown_Signal : exception;
end G2a.Build_Tree;
