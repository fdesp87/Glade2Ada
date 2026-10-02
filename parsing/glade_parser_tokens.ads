with Ada.Strings.Unbounded;
package Glade_Parser_Tokens is

   subtype Yystype is Ada.Strings.Unbounded.Unbounded_String;

   Yylval, Yyval : Yystype;
   type Token is
     (End_Of_Input, Error, T_Identifier, T_Quoted_Identifier, T_Decimal,
      T_Integer, T_Quoted_Integer, T_Quoted_Decimal, T_Natural,
      T_Quoted_String, T_Word, T_Text, T_Quoted_Text, T_Quoted_Boolean, T_Path,
      T_Comment_End, T_End, T_End_Alone, T_Xml_Line, T_Xml_Version,
      T_Xml_Encoding, T_Xml_Line_End, T_Generated, T_End_Comment,
      T_Interface_Line, T_Interface_Line_End, T_Requires_Line, T_Lib_Version,
      T_Local_Interface_Line, T_Object, T_Object_Id, T_Object_End, T_Property,
      T_Property_End, T_Property_Translatable, T_Property_Label,
      T_Property_Title, T_Property_Text, T_Property_Tearofftitle, T_Context,
      T_Comments, T_Property_Tooltiptext, T_Property_Tooltipmarkup,
      T_Property_Tooltip, T_Property_Short_Label, T_Property_Placeholdertext,
      T_Property_Icon1_Tooltiptext, T_Property_Icon1_Tooltipmarkup,
      T_Property_Icon2_Tooltiptext, T_Property_Icon2_Tooltipmarkup,
      T_Gtkseparatormenuitem, T_Gtkimage, T_Gtkcellrenderertext,
      T_Gtkcellrenderertoggle, T_Gtkfilefilter, T_Patterns, T_Patterns_End,
      T_Pattern, T_Pattern_End, T_Mime_Types, T_Mime_Types_End, T_Mime_Type,
      T_Mime_Type_End, T_Gtkliststore, T_Gtktreestore, T_Columns,
      T_Columns_End, T_Column_Name, T_Gboolean, T_Gchararray,
      T_Gtkbuttonboxstyle, T_Gfloat, T_Gint, T_Signal, T_Handler,
      T_Signal_Object, T_Signal_Swap, T_Signal_After, T_Child, T_Child_Type,
      T_Child_End, T_Placeholder, T_Child_Internal_Child_Action_Area,
      T_Child_Internal_Child_Vbox, T_Child_Internal_Child_Selection,
      T_Internal_Gtkbox, T_Internal_Gtkbuttonbox, T_Internal_Gtktreeselection,
      T_Internal_Child_Entry, T_Packing, T_Packing_End, T_Action_Widgets,
      T_Action_Widgets_End, T_Action_Widget_Response,
      T_Action_Widget_Response_End, T_Attributes, T_Attributes_End,
      T_Attribute_Name, T_Attribute_Val, T_Attribute_End, T_Data, T_Row,
      T_Row_End, T_Data_End, T_Col0, T_Col0_End, T_Coln, T_Coln_Id,
      T_Coln_Transl, T_Coln_End, T_Items, T_Items_End, T_Item, T_Item_End);

   Syntax_Error : exception;

end Glade_Parser_Tokens;
