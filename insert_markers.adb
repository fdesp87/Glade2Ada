with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with Ada.Characters.Handling;
with Ada.Containers.Vectors;
with Ada.Command_Line;

procedure Insert_Markers is

   use Ada.Text_IO;
   use Ada.Strings.Unbounded;
   use Ada.Strings.Fixed;
   use Ada.Characters.Handling;
   use Ada.Command_Line;

   type Line_Block is record
      S : Unbounded_String;
      L : Natural;
   end record;

   package With_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Line_Block);

   package Name_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Unbounded_String);

   Name_Stack  : Name_Vectors.Vector;
   Verbose     : Boolean := False;
   FileIn      : File_Type;
   FileOut     : File_Type;
   Inserting   : Boolean := False;
   Commenting  : Boolean := False;
   InFile_Num  : Natural;
   OutFile_Num : Natural;
   NLine       : Natural := 0;

   Insert_Marker_Line  : Natural := 0;
   Comment_Marker_Line : Natural := 0;

   Wrong_Arguments           : exception;
   Nested_Insert_Marker      : exception;
   Orphan_Insert_Marker      : exception;
   Orphan_End_Insert_Marker  : exception;
   Nested_Comment_Marker     : exception;
   Orphan_Comment_Marker     : exception;
   Orphan_End_Comment_Marker : exception;
   Mixed_Markers             : exception;

   ------------------------------------------------------------------------
   function Trim (S : String) return String;
   function Trim (S : String) return String is
   begin
      return Trim (S, Ada.Strings.Both);
   end Trim;

   ------------------------------------------------------------------------
   function Strip_Comment (Line : String) return String;
   function Strip_Comment (Line : String) return String is
      Pos : constant Natural := Index (Line, "--");
   begin
      if Pos > 0 then
         return Trim (Line (Line'First .. Pos - 1));
      else
         return Trim (Line);
      end if;
   end Strip_Comment;

   ------------------------------------------------------------------------
   function Is_Marker_Line (Line : String) return Boolean;
   function Is_Marker_Line (Line : String) return Boolean is
      Result : Boolean := False;
   begin
      if
        Index (Line, "--  INSERT YOUR CODE HERE") > 0 or else
        Index (Line, "--  INSERT YOUR CODE") > 0
      then
         if Inserting then
            raise Nested_Insert_Marker;
         elsif Commenting then
            raise Mixed_Markers;
         end if;
         Inserting := True;
         Result    := True;
         Insert_Marker_Line := NLine;
      elsif
        Index (Line, "--  END OF INSERT YOUR CODE HERE") > 0 or else
        Index (Line, "--  END OF INSERT YOUR CODE") > 0
      then
         if not Inserting then
            raise Orphan_End_Insert_Marker;
         elsif Commenting then
            raise Mixed_Markers;
         end if;
         Inserting := False;
         Result    := True;
      end if;

      if Index (Line, "--  START COMMENTED OUT") > 0 then
         if Commenting then
            raise Nested_Comment_Marker;
         elsif Inserting then
            raise Mixed_Markers;
         end if;
         Commenting := True;
         Result     := True;
         Comment_Marker_Line := NLine;
      elsif Index (Line, "--  END COMMENTED OUT") > 0 then
         if not Commenting then
            raise Orphan_End_Comment_Marker;
         elsif Inserting then
            raise Mixed_Markers;
         end if;
         Commenting := False;
         Result     := True;
      end if;

      return Result;
   end Is_Marker_Line;

   ------------------------------------------------------------------------
   function Remove_Existing_Marker (Line : String) return String;
   function Remove_Existing_Marker (Line : String) return String is
      Pos : Natural;
   begin
      Pos := Index (Line, " [", Ada.Strings.Backward);
      if Pos > 0 and then Index (Line (Pos .. Line'Last), "]") = Line'Last then
         return Line (Line'First .. Pos - 1);
      end if;
      return Line;
   end Remove_Existing_Marker;

   ------------------------------------------------------------------------
   function Get_Current_Name return String;
   function Get_Current_Name return String is
   begin
      if Name_Stack.Is_Empty then
         return "";
      else
         return To_String (Name_Stack.Last_Element);
      end if;
   end Get_Current_Name;

   ------------------------------------------------------------------------
   function Get_Marker return String;
   function Get_Marker return String is
      N : constant String := Get_Current_Name;
   begin
      if N = "" then
         return "";
      else
         return " [" & N & "]";
      end if;
   end Get_Marker;

   ------------------------------------------------------------------------
   function Extract_Name (Line : String) return String;
   function Extract_Name (Line : String) return String is
      Clean   : constant String := Strip_Comment (Line);
      L       : constant String := To_Lower (Clean);
      Start_P : Natural := 0;
      K : Natural;
   begin
      if Index (L, "package ") = 1 then
         Start_P := Index (L, "package ") + 8;
         K := Index (L (Start_P .. L'Last), "body ");
         declare
            LL : constant String (1 .. L'Last - 8) := L (9 .. L'Last);
         begin
            if Index (LL, "body ") = 1 then
               Start_P := Start_P + 5;
            end if;
         end;
      elsif Index (L, "procedure ") > 0 then
         Start_P := Index (L, "procedure ") + 10;
      elsif Index (L, "function ") > 0 then
         Start_P := Index (L, "function ") + 9;
      else
         return "";
      end if;

      if Index (L, "generic") = 1 then
         return "";
      end if;

      declare
         End_P : Natural := Index (L (Start_P .. L'Last), " ");
      begin
         if End_P = 0 then
            End_P := Index (L (Start_P .. L'Last), "(");
         end if;
         if End_P = 0 then
            End_P := Index (L (Start_P .. L'Last), " is");
         end if;
         if End_P = 0 then
            End_P := L'Last + 1;
         end if;
         return Trim (Slice (To_Unbounded_String (Clean), Start_P, End_P - 1));
      end;
   end Extract_Name;

   ------------------------------------------------------------------------
   function Is_Closing_End (Line : String; Current_Name : String) return Boolean;
   function Is_Closing_End (Line : String; Current_Name : String) return Boolean is
      Clean    : constant String := Strip_Comment (Line);
      L        : constant String := Trim (Clean);
      L_Lower  : constant String := To_Lower (L);
      Pos      : Natural;
   begin
      if Index (L_Lower, "end ") /= 1 then
         return False;
      end if;

      if Index (L_Lower, "end if") = 1 or else Index (L_Lower, "end loop") = 1 or else
        Index (L_Lower, "end case") = 1 or else Index (L_Lower, "end record") = 1 or else
        Index (L_Lower, "end select") = 1 or else Index (L_Lower, "end accept") = 1 or else
        Index (L_Lower, "end protected") = 1 or else Index (L_Lower, "end task") = 1
      then
         return False;
      end if;

      if Trim (L_Lower) = "end;" then
         return True;
      end if;

      Pos := Index (L_Lower, "end ") + 4;
      declare
         End_Name : constant String := Trim (L (Pos .. L'Last));
         Clean_End : constant String :=
           (if End_Name'Length > 0 and then End_Name (End_Name'Last) = ';' then
              End_Name (End_Name'First .. End_Name'Last - 1)
            else End_Name);
      begin
         return To_Lower (Trim (Clean_End)) = To_Lower (Current_Name);
      end;
   end Is_Closing_End;

   ------------------------------------------------------------------------
   procedure Update_Context (Line : String);
   procedure Update_Context (Line : String) is
      Name : constant String := Extract_Name (Line);
      L    : constant String := To_Lower (Strip_Comment (Line));
   begin
      if Name /= "" then
         Name_Stack.Append (To_Unbounded_String (Name));
      elsif Index (L, "declare") = 1 or else Index (L, " declare") > 0 then
         Name_Stack.Append (To_Unbounded_String ("(declare)"));
      elsif Index (L, "begin") = 1 or else Index (L, " begin") > 0 then
         null;
      elsif Is_Closing_End (Line, Get_Current_Name) or else
        (Get_Current_Name = "(declare)" and then Is_Closing_End (Line, ""))
      then
         if not Name_Stack.Is_Empty then
            Name_Stack.Delete_Last;
         end if;
      end if;
   end Update_Context;

   ------------------------------------------------------------------------
   procedure Put_Marked_Line (S : String; L : Natural);
   procedure Put_Marked_Line (S : String; L : Natural) is
   begin
      Put_Line (FileOut, S);
      if Verbose then
         Put_Line (Standard_Output, L'Image & " " & S);
      end if;
   end Put_Marked_Line;

   ------------------------------------------------------------------------
   procedure Put_Unmarked_Line (S : String; L : Natural);
   procedure Put_Unmarked_Line (S : String; L : Natural) is
   begin
      Put_Line (FileOut, S);
      if Commenting then
         if Index (Trim (S), "--") = 0 then
            Put_Line (Standard_Output,
                      L'Image & " ERROR: This line should be commented out");
         end if;
      end if;
   end Put_Unmarked_Line;

   ------------------------------------------------------------------------
   procedure Process_Input;
   procedure Process_Input is
      Line       : Unbounded_String;
      With_Lines : With_Vectors.Vector;
      In_With    : Boolean := True;
   begin
      while not End_Of_File (FileIn) loop
         Line := To_Unbounded_String (Get_Line (FileIn));
         NLine := NLine + 1;

         if In_With then
            declare
               L_Trim : constant String := Trim (To_String (Line));
            begin
               if
                 Index (To_Lower (L_Trim), "package") = 1 or else
                 Index (To_Lower (L_Trim), "procedure") = 1 or else
                 Index (To_Lower (L_Trim), "function") = 1
               then
                  Update_Context (To_String (Line));
                  for W of With_Lines loop
                     if Is_Marker_Line (To_String (W.S)) then
                        Put_Marked_Line (Remove_Existing_Marker (To_String (W.S))
                                         & Get_Marker, W.L);
                     else
                        Put_Unmarked_Line (To_String (W.S), W.L);
                     end if;
                  end loop;
                  With_Lines.Clear;
                  In_With := False;

                  if Is_Marker_Line (To_String (Line)) then
                     Put_Marked_Line (Remove_Existing_Marker (To_String (Line))
                                      & Get_Marker, NLine);
                  else
                     Put_Unmarked_Line (To_String (Line), NLine);
                  end if;
               else
                  With_Lines.Append (Line_Block'(Line, NLine));
               end if;
            end;
         else
            Update_Context (To_String (Line));

            if Is_Marker_Line (To_String (Line)) then
               Put_Marked_Line (Remove_Existing_Marker (To_String (Line))
                                & Get_Marker, NLine);
            else
               Put_Unmarked_Line (To_String (Line), NLine);
            end if;
         end if;
      end loop;

      --  Only if no package/procedure/function of the compilation unit was found
      for W of With_Lines loop
         if Is_Marker_Line (To_String (W.S)) then
            Put_Marked_Line (Remove_Existing_Marker (To_String (W.S))
                             & Get_Marker, W.L);
         else
            Put_Unmarked_Line (To_String (W.S), W.L);
         end if;
      end loop;

      Close (FileIn);
      Close (FileOut);

      if Inserting then
         raise Orphan_Insert_Marker;
      end if;
      if Commenting then
         raise Orphan_Comment_Marker;
      end if;

   end Process_Input;

   ------------------------------------------------------------------------
begin
   if Argument (1) = "-v" or else
     Argument (1) = "--verbose"
   then
      Verbose := True;
      if Argument_Count /= 3 then
         raise Wrong_Arguments;
      end if;
      InFile_Num  := 2;
      OutFile_Num := 3;
   else
      if Argument_Count /= 2 then
         raise Wrong_Arguments;
      end if;
      InFile_Num  := 1;
      OutFile_Num := 2;
   end if;
   Open   (File => FileIn,  Mode => In_File,  Name => Argument (InFile_Num));
   Create (File => FileOut, Mode => Out_File, Name => Argument (OutFile_Num));
   if Verbose then
      New_Line (Standard_Output);
      Put_Line (Standard_Output, "=== " & Argument (OutFile_Num) & " ===");
   end if;

   Process_Input;

exception
   when Nested_Insert_Marker =>
      Put_Line (Standard_Error, "Error: Nested Insert Market at line" & NLine'Image);
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   when Orphan_Insert_Marker =>
      Put_Line (Standard_Error, "Error: Orphan Insert Market at line" & Insert_Marker_Line'Image);
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   when Orphan_End_Insert_Marker =>
      Put_Line (Standard_Error, "Error: Orphan End Insert Market at line" & NLine'Image);
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   when Nested_Comment_Marker =>
      Put_Line (Standard_Error, "Error: Nested Comment Market at line" & NLine'Image);
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   when Orphan_Comment_Marker =>
      Put_Line (Standard_Error, "Error: Orphan Comment Market at line" & Comment_Marker_Line'Image);
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   when Orphan_End_Comment_Marker =>
      Put_Line (Standard_Error, "Error: Orphan End Comment Market at line" & NLine'Image);
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   when Mixed_Markers =>
      Put_Line (Standard_Error, "Error: Mixed Market at line" & NLine'Image);
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   when Wrong_Arguments =>
      Put_Line (Standard_Error,
                "Usage: insert_markers [-v|--verbose] input_file_name output_file_name");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   when others =>
      Put_Line (Standard_Error, "Error: Unexpected error processing input.");
      Put_Line (Standard_Error, "Input File " & Argument (InFile_Num));
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
end Insert_Markers;
