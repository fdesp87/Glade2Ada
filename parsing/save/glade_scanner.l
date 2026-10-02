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

%unit Glade_Scanner
%option case-insensitive
%option yylineno

--  ----------------------------------------------------------------------
--  Start conditions
--  ----------------------------------------------------------------------
--  Refactored: Shared state machine (S_TR_PROP*) for all translatable
--  properties (label, title, text, tooltip-text, tooltip-markup,
--  placeholder-text, primary/secondary icon tooltips).
--  ----------------------------------------------------------------------

%s   S_XML S_GENERATED
%s   S_REQUIRES S_REQUIRES_1 S_REQUIRES_2
%s   S_LOCAL_INTERFACE
%s   S_OBJECT S_OBJECT_1
%s   S_CHILD_TYPE S_CHILD_TAG
%s   S_COMMENT

%s   S_SEPARATORMENUITEM
%s   S_STORE
%s   S_SIGNAL S_SIGNAL_HANDLER S_SIGNAL_OBJECT S_SIGNAL_AFTER S_SIGNAL_SWAP
%s   S_ACTION_RESPONSE S_ACTION_RESPONSE_1

%s   S_PROPERTY S_PROPERTY_VALUE S_PROPERTY_EMPTY
%s   S_TR_PROP S_TR_PROP_TRANSL S_TR_PROP_CTXT S_TR_PROP_COMM S_TR_PROP_TEXT
%s   S_TR_PROP_EMPTY

%s   S_ATTRIBUTE S_ATTRIBUTE_VAL S_ATTRIBUTE_INTEGER
%s   S_RENDERERTEXT S_RENDERERTOGGLE
%s   S_FILEFILTER S_PATTERN S_MIME_TYPE
%s   S_DATA S_ROW S_COL0
%s   S_COLN S_COLN_0 S_COLN_1 S_COLN_2 S_COLN_3 S_COLN_4 S_COLN_5 S_COLN_6 S_COLN_7
%s   S_COLUMNS S_COLUMN
%s   S_ITEMS

BOOLEAN             ([tT]rue|[fF]alse)
QUOTED_BOOLEAN      \"([yY]es|[nN]o|[tT]rue|[fF]alse)\"

QUOTED_STRING       \"[^\n\r\f\"]*\"|\'[^\n\r\f\']*\'

WORD                [^\n\r\f\t\ \"\<\>]+
TEXT                [^\<]+
QUOTED_TEXT         \"{TEXT}\"

LETTER              [a-zA-Z]
DIGIT               [0-9]

IDENTIFIER          {LETTER}([_]?({LETTER}|{DIGIT}))*
QUOTED_IDENTIFIER   \"{IDENTIFIER}\"
PATH_COMPONENT      "/"|"."|"-"|"_"|{LETTER}|{DIGIT}
PATH                {PATH_COMPONENT}+

SIGN                \+|\-
DIGIT_SEQUENCE      {DIGIT}+
NATURAL             {DIGIT_SEQUENCE}
QUOTED_INTEGER      \"{SIGN}?{DIGIT_SEQUENCE}\"
EXPONENT            "E"{SIGN}?{DIGIT}+
QUOTED_DECIMAL      \"{SIGN}?{DIGIT_SEQUENCE}("."{DIGIT_SEQUENCE})?{EXPONENT}?\"

COMMENT_START       \<!\-\-" "
COMMENT_END         \-\-\>
%%
-----------------------------------------------------------------------------------------------
\<\?xml                                               {ECHO_L (T_XML_LINE);
                                                       Enter (S_XML);
                                                       ECHO_P;
                                                       return T_XML_LINE;}
<S_XML>version[ \t]*\=                                {ECHO_L (T_XML_VERSION);
                                                       ECHO_P;
                                                       return T_XML_VERSION;}
<S_XML>{QUOTED_DECIMAL}                               {ECHO_L (T_QUOTED_DECIMAL);
                                                       ECHO_P;
                                                       return T_QUOTED_DECIMAL;}
<S_XML>encoding[ \t]*\=                               {ECHO_L (T_XML_ENCODING);
                                                       ECHO_P;
                                                       return T_XML_ENCODING;}
<S_XML>{QUOTED_STRING}                                {ECHO_L (T_QUOTED_STRING);
                                                       ECHO_P;
                                                       return T_QUOTED_STRING;}
<S_XML>\?[ \t]*\>                                     {ECHO_L (T_XML_LINE_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_XML_LINE_END;}

-----------------------------------------------------------------------------------------------
<INITIAL>{COMMENT_START}Generated[ \t]with            {ECHO_L (T_GENERATED);
                                                       Enter (S_GENERATED);
                                                       ECHO_P;
                                                       return T_GENERATED;}
<S_GENERATED>{IDENTIFIER}                             {ECHO_L (T_IDENTIFIER);
                                                       ECHO_P;
                                                       return T_IDENTIFIER;}
<S_GENERATED>{WORD}                                   {ECHO_L (T_WORD);
                                                       ECHO_P;
                                                       return T_WORD;}
<S_GENERATED>{COMMENT_END}                            {ECHO_L (T_COMMENT_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_COMMENT_END;}

-----------------------------------------------------------------------------------------------
<INITIAL>\<interface[ \t]*\>                           {ECHO_L (T_INTERFACE_LINE);
                                                       ECHO_P;
                                                       return T_INTERFACE_LINE;}
<INITIAL>\<\/interface[ \t]*\>                        {ECHO_L (T_INTERFACE_LINE_END);
                                                       ECHO_P;
                                                       return T_INTERFACE_LINE_END;}

-----------------------------------------------------------------------------------------------
<INITIAL>\<requires[ \t]+lib[ \t]*\=                  {ECHO_L (T_REQUIRES_LINE);
                                                       Enter (S_REQUIRES);
                                                       ECHO_P;
                                                       return T_REQUIRES_LINE;}
<S_REQUIRES>{QUOTED_STRING}                           {ECHO_L (T_QUOTED_STRING);
                                                       Enter (S_REQUIRES_1);
                                                       ECHO_P;
                                                       return T_QUOTED_STRING;}
<S_REQUIRES_1>version[ \t]*\=                         {ECHO_L (T_QUOTED_STRING);
                                                       Enter (S_REQUIRES_2);
                                                       ECHO_P;
                                                       return T_LIB_VERSION;}
<S_REQUIRES_2>{QUOTED_STRING}                         {ECHO_L (T_QUOTED_STRING);
                                                       ECHO_P;
                                                       return T_QUOTED_STRING;}
<S_REQUIRES_2>\/[ \t]*\>                              {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END;}

-----------------------------------------------------------------------------------------------
<INITIAL>{COMMENT_START}interface\-local\-resource\-path {ECHO_L (T_LOCAL_INTERFACE_LINE);
                                                              Enter (S_LOCAL_INTERFACE);
                                                              ECHO_P;
                                                              return T_LOCAL_INTERFACE_LINE;}
<S_LOCAL_INTERFACE>{PATH}                             {ECHO_L (T_PATH);
                                                       ECHO_P;
                                                       return T_PATH;}
<S_LOCAL_INTERFACE>{COMMENT_END}                      {ECHO_L (T_COMMENT_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_COMMENT_END;}

-----------------------------------------------------------------------------------------------
<INITIAL,S_OBJECT,S_PROPERTY>\<!\-\-   { Enter (S_COMMENT); }
<S_COMMENT>\-\-\>                      { Enter (INITIAL); }
<S_COMMENT>.                           { null; }
<S_COMMENT>[\n\r]                      { null; }

-----------------------------------------------------------------------------------------------
<INITIAL>\<object[ \t]+class[ \t]*\=                  {ECHO_L (T_OBJECT);
                                                       Enter (S_OBJECT);
                                                       ECHO_P;
                                                       return T_OBJECT;}
<S_OBJECT>{QUOTED_IDENTIFIER}                         {ECHO_L (T_QUOTED_IDENTIFIER);
                                                       Enter (S_OBJECT_1);
                                                       ECHO_P;
                                                       return T_QUOTED_IDENTIFIER;}
<S_OBJECT_1>id[ \t]*\=                                {ECHO_L (T_OBJECT_ID);
                                                       ECHO_P;
                                                       return T_OBJECT_ID;}
<S_OBJECT_1>{QUOTED_IDENTIFIER}                       {ECHO_L (T_QUOTED_IDENTIFIER);
                                                       ECHO_P;
                                                       return T_QUOTED_IDENTIFIER;}
<S_OBJECT_1>[ \t]*\>                                  {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END;}
<S_OBJECT_1>\/[ \t]*\>                                {ECHO_L (T_END_ALONE);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END_ALONE;}
<INITIAL>\<\/object[ \t]*\>                           {ECHO_L (T_OBJECT_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_OBJECT_END;}

-----------------------------------------------------------------------------------------------
<INITIAL>\<object[ \t]+class[ \t]*\=\"GtkTreeStore\"  {ECHO_L (T_GTKTREESTORE);
                                                       Enter (S_STORE);
                                                       ECHO_P;
                                                       return T_GTKTREESTORE;}
<INITIAL>\<object[ \t]+class[ \t]*\=\"GtkListStore\"  {ECHO_L (T_GTKLISTSTORE);
                                                       Enter (S_STORE);
                                                       ECHO_P;
                                                       return T_GTKLISTSTORE;}
<S_STORE>id[ \t]*\=                                   {ECHO_L (T_OBJECT_ID);
                                                       ECHO_P;
                                                       return T_OBJECT_ID;}
<S_STORE>{QUOTED_IDENTIFIER}                          {ECHO_L (T_QUOTED_IDENTIFIER);
                                                       ECHO_P;
                                                       return T_QUOTED_IDENTIFIER;}
<S_STORE>[ \t]*\>                                     {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END;}
<S_STORE>\/[ \t]*\>                                   {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END_ALONE;}

-----------------------------------------------------------------------------------------------
<INITIAL>\<object[ \t]+class[ \t]*\=\"GtkSeparatorMenuItem\" {ECHO_L (T_GTKSEPARATORMENUITEM);
                                                               Enter (S_SEPARATORMENUITEM);
                                                               ECHO_P;
                                                               return T_GTKSEPARATORMENUITEM;}
<S_SEPARATORMENUITEM>[ \t]*\>                         {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END;}

-----------------------------------------------------------------------------------------------
<INITIAL>\<object[ \t]+class[ \t]*\=\"GtkImage\"[ \t]*\> {ECHO_L (T_GTKIMAGE);
                                                         ECHO_P;
                                                         return T_GTKIMAGE;}

-----------------------------------------------------------------------------------------------
<INITIAL>\<object[ \t]+class[ \t]*\=\"GtkCellRendererText\" {ECHO_L (T_GTKCELLRENDERERTEXT); 
                                                             Enter (S_RENDERERTEXT); 
                                                             ECHO_P;
                                                             return T_GTKCELLRENDERERTEXT;}
<S_RENDERERTEXT>id[ \t]*\=                            {ECHO_L (T_OBJECT_ID);
                                                       ECHO_P;
                                                       return T_OBJECT_ID;}
<S_RENDERERTEXT>{QUOTED_IDENTIFIER}                   {ECHO_L (T_QUOTED_IDENTIFIER);
                                                       ECHO_P;
                                                       return T_QUOTED_IDENTIFIER;}
<S_RENDERERTEXT>[ \t]*\>                              {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END;}

-----------------------------------------------------------------------------------------------
<INITIAL>\<object[ \t]+class[ \t]*\=\"GtkCellRendererToggle\" {ECHO_L (T_GTKCELLRENDERERTOGGLE);
                                                                 Enter (S_RENDERERTOGGLE);
                                                                 ECHO_P;
                                                                 return T_GTKCELLRENDERERTOGGLE;}
<S_RENDERERTOGGLE>id[ \t]*\=                          {ECHO_L (T_OBJECT_ID);
                                                       ECHO_P;
                                                       return T_OBJECT_ID;}
<S_RENDERERTOGGLE>{QUOTED_IDENTIFIER}                 {ECHO_L (T_QUOTED_IDENTIFIER);
                                                       ECHO_P;
                                                       return T_QUOTED_IDENTIFIER;}
<S_RENDERERTOGGLE>[ \t]*\>                            {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END;}

-----------------------------------------------------------------------------------------------
<INITIAL>\<object[ \t]+class[ \t]*\=\"GtkFileFilter\" {ECHO_L (T_GTKFILEFILTER);
                                                       Enter (S_FILEFILTER);
                                                       ECHO_P;
                                                       return T_GTKFILEFILTER;}
<S_FILEFILTER>id[ \t]*\=                              {ECHO_L (T_OBJECT_ID);
                                                       ECHO_P;
                                                       return T_OBJECT_ID;}
<S_FILEFILTER>{QUOTED_IDENTIFIER}                     {ECHO_L (T_QUOTED_IDENTIFIER);
                                                       ECHO_P;
                                                       return T_QUOTED_IDENTIFIER;}
<S_FILEFILTER>[ \t]*\>                                {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END;}

-----------------------------------------------------------------------------------------------
\<mime\-types[ \t]*\>                                 {ECHO_L (T_MIME_TYPES);
                                                       ECHO_P;
                                                       return T_MIME_TYPES;}
\<\/mime\-types[ \t]*\>                               {ECHO_L (T_MIME_TYPES_END);
                                                       ECHO_P;
                                                       return T_MIME_TYPES_END;}
\<mime\-type[ \t]*\>                                  {ECHO_L (T_MIME_TYPE);
                                                       Enter (S_MIME_TYPE);
                                                       ECHO_P;
                                                       return T_MIME_TYPE;}
<S_MIME_TYPE>{TEXT}                                   {ECHO_L (T_TEXT);
                                                       ECHO_P;
                                                       return T_TEXT;}
<S_MIME_TYPE>\<\/mime\-type[ \t]*\>                   {ECHO_L (T_MIME_TYPE_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_MIME_TYPE_END;}

-----------------------------------------------------------------------------------------------
\<patterns[ \t]*\>                                    {ECHO_L (T_PATTERNS);
                                                       ECHO_P;
                                                       return T_PATTERNS;}
\<\/patterns[ \t]*\>                                  {ECHO_L (T_PATTERNS_END);
                                                       ECHO_P;
                                                       return T_PATTERNS_END;}
\<pattern[ \t]*\>                                     {ECHO_L (T_PATTERN);
                                                       Enter (S_PATTERN);
                                                       ECHO_P;
                                                       return T_PATTERN;}
<S_PATTERN>{TEXT}                                     {ECHO_L (T_TEXT);
                                                       ECHO_P;
                                                       return T_TEXT;}
<S_PATTERN>\<\/pattern[ \t]*\>                        {ECHO_L (T_PATTERN_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_PATTERN_END;}

-----------------------------------------------------------------------------------------------
\<property[ \t]+name[ \t]*\=                          {ECHO_L (T_PROPERTY);
                                                       Enter (S_PROPERTY);
                                                       ECHO_P;
                                                       return T_PROPERTY;}
<S_PROPERTY>{QUOTED_STRING}                           {ECHO_L (T_QUOTED_STRING);
                                                       ECHO_P;
                                                       return T_QUOTED_STRING;}
<S_PROPERTY>[ \t]*\>                                  {ECHO_L (T_END);
                                                       Enter (S_PROPERTY_VALUE);
                                                       ECHO_P;
                                                       return T_END;}

<S_PROPERTY_VALUE>{TEXT}                              {ECHO_L (T_TEXT);
                                                       Enter (S_PROPERTY);
                                                       ECHO_P;
                                                       return T_TEXT;}


<S_PROPERTY>\<\/property[ \t]*\>                      {ECHO_L (T_PROPERTY_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_PROPERTY_END;}

-----------------------------------------------------------------------------------------------
\<property[ \t]+name[ \t]*\=\"label\"                   {ECHO_L (T_PROPERTY_LABEL);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_PROPERTY_LABEL;}

\<property[ \t]+name[ \t]*\=\"short-label\"            {ECHO_L (T_PROPERTY_LABEL);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_PROPERTY_SHORT_LABEL;}

\<property[ \t]+name[ \t]*\=\"title\"                   {ECHO_L (T_PROPERTY_TITLE);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_PROPERTY_TITLE;}

\<property[ \t]+name[ \t]*\=\"tearoff[\-_]title\"      {ECHO_L (T_PROPERTY_TEAROFFTITLE);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_PROPERTY_TEAROFFTITLE;}

\<property[ \t]+name[ \t]*\=\"text\"                    {ECHO_L (T_PROPERTY_TEXT);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_PROPERTY_TEXT;}

\<property[ \t]+name[ \t]*\=\"tooltip\"                {ECHO_L (T_PROPERTY_TOOLTIP);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_PROPERTY_TOOLTIP;}

\<property[ \t]+name[ \t]*\=\"tooltip[\-_]text\"        {ECHO_L (T_PROPERTY_TOOLTIPTEXT);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_PROPERTY_TOOLTIPTEXT;}

\<property[ \t]+name[ \t]*\=\"tooltip[\-_]markup\"      {ECHO_L (T_PROPERTY_TOOLTIPMARKUP);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_PROPERTY_TOOLTIPMARKUP;}

\<property[ \t]+name[ \t]*\=\"placeholder[\-_]text\"    {ECHO_L (T_PROPERTY_PLACEHOLDERTEXT);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_PROPERTY_PLACEHOLDERTEXT;}

\<property[ \t]+name[ \t]*\=\"primary[\-_]icon[\-_]tooltip[\-_]text\"   {ECHO_L (T_PROPERTY_ICON1_TOOLTIPTEXT);
                                                                         Enter (S_TR_PROP);
                                                                         ECHO_P;
                                                                         return T_PROPERTY_ICON1_TOOLTIPTEXT;}

\<property[ \t]+name[ \t]*\=\"primary[\-_]icon[\-_]tooltip[\-_]markup\" {ECHO_L (T_PROPERTY_ICON1_TOOLTIPMARKUP);
                                                                         Enter (S_TR_PROP);
                                                                         ECHO_P;
                                                                         return T_PROPERTY_ICON1_TOOLTIPMARKUP;}

\<property[ \t]+name[ \t]*\=\"secondary[\-_]icon[\-_]tooltip[\-_]text\" {ECHO_L (T_PROPERTY_ICON2_TOOLTIPTEXT);
                                                                         Enter (S_TR_PROP);
                                                                         ECHO_P;
                                                                         return T_PROPERTY_ICON2_TOOLTIPTEXT;}

\<property[ \t]+name[ \t]*\=\"secondary[\-_]icon[\-_]tooltip[\-_]markup\" {ECHO_L (T_PROPERTY_ICON2_TOOLTIPMARKUP);
                                                                          Enter (S_TR_PROP);
                                                                          ECHO_P;
                                                                          return T_PROPERTY_ICON2_TOOLTIPMARKUP;}

<S_TR_PROP>[ \t\r\n]+                                   {null;} -- consume spaces

<S_TR_PROP>translatable[ \t]*\=                         {ECHO_L (T_PROPERTY_TRANSLATABLE);
                                                        Enter (S_TR_PROP_TRANSL);
                                                        ECHO_P;
                                                        return T_PROPERTY_TRANSLATABLE;}

<S_TR_PROP_TRANSL>{QUOTED_BOOLEAN}                      {ECHO_L (T_QUOTED_BOOLEAN);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_QUOTED_BOOLEAN;}

<S_TR_PROP>context[ \t]*\=                              {ECHO_L (T_CONTEXT);
                                                        Enter (S_TR_PROP_CTXT);
                                                        ECHO_P;
                                                        return T_CONTEXT;}

<S_TR_PROP_CTXT>{QUOTED_TEXT}                           {ECHO_L (T_QUOTED_TEXT);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_QUOTED_TEXT;}

<S_TR_PROP>comments[ \t]*\=                             {ECHO_L (T_COMMENTS);
                                                        Enter (S_TR_PROP_COMM);
                                                        ECHO_P;
                                                        return T_COMMENTS;}

<S_TR_PROP_COMM>{QUOTED_TEXT}                           {ECHO_L (T_QUOTED_TEXT);
                                                        Enter (S_TR_PROP);
                                                        ECHO_P;
                                                        return T_QUOTED_TEXT;}

<S_TR_PROP>[ \t]*\>                                     {ECHO_L (T_END);
                                                        Enter (S_TR_PROP_TEXT);
                                                        ECHO_P;
                                                        return T_END;}

<S_TR_PROP_TEXT>{TEXT}                                  {ECHO_L (T_TEXT);
                                                        ECHO_P;
                                                        return T_TEXT;}

<S_TR_PROP_TEXT>\<\/property[ \t]*\>                    {ECHO_L (T_PROPERTY_END);
                                                        Enter (INITIAL);
                                                        ECHO_P;
                                                        return T_PROPERTY_END;}

-----------------------------------------------------------------------------------------------
\<items[ \t]*\>                                       {ECHO_L (T_ITEMS);
                                                       Enter (S_ITEMS);
                                                       ECHO_P;
                                                       return T_ITEMS;}

<S_ITEMS>[ \t\r\n]+                                   {null;} -- consume espacios

<S_ITEMS>\<item                                       {ECHO_L (T_ITEM);
                                                       Enter (S_TR_PROP);
                                                       ECHO_P;
                                                       return T_ITEM;}

\<\/item[ \t]*\>                                      {ECHO_L (T_ITEM_END);
                                                       Enter (S_ITEMS);
                                                       ECHO_P;
                                                       return T_ITEM_END;}

<S_ITEMS>\<\/items[ \t]*\>                            {ECHO_L (T_ITEMS_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_ITEMS_END;}

-----------------------------------------------------------------------------------------------
\<attributes[ \t]*\>                                  {ECHO_L (T_ATTRIBUTES);
                                                       ECHO_P;
                                                       return T_ATTRIBUTES;}
\<attribute[ \t]+name[ \t]*\=                         {ECHO_L (T_ATTRIBUTE_NAME);
                                                       Enter (S_ATTRIBUTE);
                                                       ECHO_P;
                                                       return T_ATTRIBUTE_NAME;}
<S_ATTRIBUTE>{QUOTED_STRING}                          {ECHO_L (T_QUOTED_STRING);
                                                       ECHO_P;
                                                       return T_QUOTED_STRING;}
<S_ATTRIBUTE>value[ \t]*\=                            {ECHO_L (T_ATTRIBUTE_VAL);
                                                       Enter (S_ATTRIBUTE_VAL);
                                                       ECHO_P;
                                                       return T_ATTRIBUTE_VAL;}
<S_ATTRIBUTE_VAL>{QUOTED_STRING}                      {ECHO_L (T_QUOTED_STRING);
                                                       ECHO_P;
                                                       return T_QUOTED_STRING;}
<S_ATTRIBUTE_VAL>\/[ \t]*\>                           {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END;}

<S_ATTRIBUTE>[ \t]*\>                                 {ECHO_L (T_END);
                                                       Enter (S_ATTRIBUTE_INTEGER);
                                                       ECHO_P;
                                                       return T_END;}
<S_ATTRIBUTE_INTEGER>{TEXT}                           {ECHO_L (T_TEXT);
                                                       ECHO_P;
                                                       return T_TEXT;}
<S_ATTRIBUTE_INTEGER>\<\/attribute[ \t]*\>            {ECHO_L (T_ATTRIBUTE_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_ATTRIBUTE_END;}

\<\/attributes[ \t]*\>                                {ECHO_L (T_ATTRIBUTE_END);
                                                       ECHO_P;
                                                       return T_ATTRIBUTES_END;}

-----------------------------------------------------------------------------------------------
\<columns[ \t]*\>                                     {ECHO_L (T_COLUMNS);
                                                       Enter (S_COLUMNS);
                                                       ECHO_P;
                                                       return T_COLUMNS;}
<S_COLUMNS>{COMMENT_START}column\-name                {ECHO_L (T_COLUMN_NAME);
                                                       Enter (S_COLUMNS);
                                                       ECHO_P;
                                                       return T_COLUMN_NAME;}
<S_COLUMNS>{IDENTIFIER}                               {ECHO_L (T_IDENTIFIER);
                                                       ECHO_P;
                                                       return T_IDENTIFIER;}
<S_COLUMNS>{COMMENT_END}                              {ECHO_L (T_COMMENT_END);
                                                       Enter (S_COLUMN);
                                                       ECHO_P;
                                                       return T_COMMENT_END;}
<S_COLUMN>\<column[ \t]+type\=\"gfloat\"[ \t]*\/\>    {ECHO_L (T_GFLOAT);
                                                       Enter (S_COLUMNS);
                                                       ECHO_P;
                                                       return T_GFLOAT;}
<S_COLUMN>\<column[ \t]+type\=\"gint\"[ \t]*\/\>      {ECHO_L (T_GINT);
                                                       Enter (S_COLUMNS);
                                                       ECHO_P;
                                                       return T_GINT;}
<S_COLUMN>\<column[ \t]+type\=\"gboolean\"[ \t]*\/\>  {ECHO_L (T_GBOOLEAN);
                                                       Enter (S_COLUMNS);
                                                       ECHO_P;
                                                       return T_GBOOLEAN;}
<S_COLUMN>\<column[ \t]+type\=\"gchararray\"[ \t]*\/\> {ECHO_L (T_GCHARARRAY);
                                                       Enter (S_COLUMNS);
                                                       ECHO_P;
                                                       return T_GCHARARRAY;}
<S_COLUMN>\<column[ \t]+type\=\"GtkButtonBoxStyle\"[ \t]*\/\> {ECHO_L (T_GTKBUTTONBOXSTYLE);
                                                               Enter (S_COLUMNS);
                                                               ECHO_P;
                                                               return T_GTKBUTTONBOXSTYLE;}
<S_COLUMNS>\<\/columns[ \t]*\>                        {ECHO_L (T_COLUMNS_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_COLUMNS_END;}

-----------------------------------------------------------------------------------------------
\<data[ \t]*\>                                        {ECHO_L (T_DATA);
                                                       Enter (S_DATA);
                                                       ECHO_P;
                                                       return T_DATA;}
<S_DATA>\<row[ \t]*\>                                 {ECHO_L (T_ROW);
                                                       Enter (S_ROW);
                                                       ECHO_P;
                                                       return T_ROW;}
<S_ROW>\<col[ \t]+id\=\"0\"[ \t]*\>                   {ECHO_L (T_COL0);
                                                       Enter (S_COL0);
                                                       ECHO_P;
                                                       return T_COL0;}
<S_COL0>{IDENTIFIER}                                  {ECHO_L (T_IDENTIFIER);
                                                       ECHO_P;
                                                       return T_IDENTIFIER;}
<S_COL0>\<\/col[ \t]*\>                               {ECHO_L (T_COL0_END);
                                                       Enter (S_COLN);
                                                       ECHO_P;
                                                       return T_COL0_END;}

<S_DATA,S_ROW,S_COLN>[ \t\r\n]+                       {null;}

<S_COLN>\<\/row[ \t]*\>                               {ECHO_L (T_ROW_END);
                                                       Enter (S_DATA);
                                                       ECHO_P;
                                                       return T_ROW_END;}

<S_COLN>\<col                                         {ECHO_L (T_COLN);
                                                       Enter (S_COLN_0);
                                                       ECHO_P;
                                                       return T_COLN;}
<S_COLN_0>[ \t]+id\=\"                                {ECHO_L (T_COLN_ID);
                                                       Enter (S_COLN_1);
                                                       ECHO_P;
                                                       return T_COLN_ID;}
<S_COLN_1>{NATURAL}                                   {ECHO_L (T_NATURAL);
                                                       Enter (S_COLN_2);
                                                       ECHO_P;
                                                       return T_NATURAL;}

<S_COLN_2>\"[ \t]*\>                                  {ECHO_L (T_COLN_END);
                                                       Enter (S_COLN_5);
                                                       ECHO_P;
                                                       return T_COLN_END;}

<S_COLN_2>\"[ \t]+translatable[ \t]*\=                {ECHO_L (T_COLN_TRANSL);
                                                       Enter (S_COLN_3);
                                                       ECHO_P;
                                                       return T_COLN_TRANSL;}
<S_COLN_3>{QUOTED_BOOLEAN}                            {ECHO_L (T_QUOTED_BOOLEAN);
                                                       Enter (S_COLN_4);
                                                       ECHO_P;
                                                       return T_QUOTED_BOOLEAN;}

<S_COLN_4>[ \t]*\>                                    {ECHO_L (T_COLN_END);
                                                       Enter (S_COLN_5);
                                                       ECHO_P;
                                                       return T_COLN_END;}

<S_COLN_4>[ \t]*\/\>                                  {ECHO_L (T_COLN_END);
                                                       Enter (S_COLN);
                                                       ECHO_P;
                                                       return T_COLN_END;}
<S_COLN_5>{TEXT}                                      {ECHO_L (T_TEXT);
                                                       Enter (S_COLN_6);
                                                       ECHO_P;
                                                       return T_TEXT;}

<S_COLN_6>\<\/col[ \t]*\>                             {ECHO_L (T_COLN_END);
                                                       Enter (S_COLN);
                                                       ECHO_P;
                                                       return T_COLN_END;}

<S_COLN_5>\<\/col[ \t]*\>                             {ECHO_L (T_COLN_END);
                                                       Enter (S_COLN);
                                                       ECHO_P;
                                                       return T_COLN_END;}

<S_DATA>\<\/data[ \t]*\>                              {ECHO_L (T_DATA_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_DATA_END;}

-----------------------------------------------------------------------------------------------
\<signal[ \t]+name[ \t]*\=                            {ECHO_L (T_SIGNAL); 
                                                       Enter (S_SIGNAL);
                                                       ECHO_P;
                                                       return T_SIGNAL;}

<S_SIGNAL>[ \t\r\n]+                                  { null; }

<S_SIGNAL>{QUOTED_STRING}                             {ECHO_L (T_QUOTED_STRING);
                                                       ECHO_P;
                                                       return T_QUOTED_STRING;}
<S_SIGNAL>handler[ \t]*\=                             {ECHO_L (T_HANDLER);
                                                       Enter (S_SIGNAL_HANDLER);
                                                       ECHO_P;
                                                       return T_HANDLER;}
<S_SIGNAL_HANDLER>{QUOTED_IDENTIFIER}                 {ECHO_L (T_QUOTED_IDENTIFIER);
                                                       Enter (S_SIGNAL);
                                                       ECHO_P;
                                                       return T_QUOTED_IDENTIFIER;}
<S_SIGNAL>object[ \t]*\=                              {ECHO_L (T_SIGNAL_OBJECT);
                                                       Enter (S_SIGNAL_OBJECT);
                                                       ECHO_P;
                                                       return T_SIGNAL_OBJECT;}
<S_SIGNAL_OBJECT>{QUOTED_IDENTIFIER}                  {ECHO_L (T_QUOTED_IDENTIFIER);
                                                       Enter (S_SIGNAL);
                                                       ECHO_P;
                                                       return T_QUOTED_IDENTIFIER;}
<S_SIGNAL>swapped[ \t]*\=                             {ECHO_L (T_SIGNAL_SWAP);
                                                       Enter (S_SIGNAL_SWAP);
                                                       ECHO_P;
                                                       return T_SIGNAL_SWAP;}
<S_SIGNAL_SWAP>{QUOTED_BOOLEAN}                       {ECHO_L (T_QUOTED_BOOLEAN);
                                                       Enter (S_SIGNAL);
                                                       ECHO_P;
                                                       return T_QUOTED_BOOLEAN;}
<S_SIGNAL>after[ \t]*\=                               {ECHO_L (T_SIGNAL_AFTER);
                                                       Enter (S_SIGNAL_AFTER);
                                                       ECHO_P;
                                                       return T_SIGNAL_AFTER;}
<S_SIGNAL_AFTER>{QUOTED_BOOLEAN}                      {ECHO_L (T_QUOTED_BOOLEAN);
                                                       Enter (S_SIGNAL);
                                                       ECHO_P;
                                                       return T_QUOTED_BOOLEAN;}
<S_SIGNAL>\/[ \t]*\>                                  {ECHO_L (T_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_END;}


-----------------------------------------------------------------------------------------------
<INITIAL>\<child[ \t]+internal\-child\=\"action_area\"[ \t]*\> {ECHO_L (T_CHILD_INTERNAL_CHILD_ACTION_AREA);
                                                                 Enter (INITIAL);
                                                                 ECHO_P;
                                                                 return T_CHILD_INTERNAL_CHILD_ACTION_AREA;}

<INITIAL>\<child[ \t]+internal\-child\=\"vbox\"[ \t]*\>        {ECHO_L (T_CHILD_INTERNAL_CHILD_VBOX);
                                                                 Enter (INITIAL);
                                                                 ECHO_P;
                                                                 return T_CHILD_INTERNAL_CHILD_VBOX;}

<INITIAL>\<child[ \t]+internal\-child\=\"selection\"[ \t]*\>   {ECHO_L (T_CHILD_INTERNAL_CHILD_SELECTION);
                                                                Enter (INITIAL);
                                                                ECHO_P;
                                                                return T_CHILD_INTERNAL_CHILD_SELECTION;}

<INITIAL>\<child[ \t]+internal\-child\=\"entry\"[ \t]*\>       {ECHO_L (T_INTERNAL_CHILD_ENTRY);
                                                                Enter (INITIAL);
                                                                ECHO_P;
                                                                return T_INTERNAL_CHILD_ENTRY;}

<INITIAL>\<child[ \t]*\>                                       {ECHO_L (T_CHILD);
                                                                ECHO_P;
                                                                return T_CHILD;}

\<\/child[ \t]*\>                                              {ECHO_L (T_CHILD_END);
                                                                Enter (INITIAL);
                                                                ECHO_P;
                                                                return T_CHILD_END;}

-----------------------------------------------------------------------------------------------
<INITIAL>\<placeholder[ \t]*\/\>                               {ECHO_L (T_PLACEHOLDER);
                                                                ECHO_P;
                                                                return T_PLACEHOLDER;}

<INITIAL>\<child[ \t]+type\=\"[^\"]*\"[ \t]*\>                 {ECHO_L (T_CHILD_TYPE);
                                                                Enter (INITIAL);
                                                                ECHO_P;
                                                                return T_CHILD_TYPE;}

-----------------------------------------------------------------------------------------------
\<packing[ \t]*\>                                     {ECHO_L (T_PACKING);
                                                       ECHO_P;
                                                       return T_PACKING;}
\<\/packing[ \t]*\>                                   {ECHO_L (T_PACKING_END);
                                                       ECHO_P;
                                                       return T_PACKING_END;}

-----------------------------------------------------------------------------------------------
\<action\-widgets[ \t]*\>                             {ECHO_L (T_ACTION_WIDGETS);
                                                       ECHO_P;
                                                       return T_ACTION_WIDGETS;}
\<\/action\-widgets[ \t]*\>                           {ECHO_L (T_ACTION_WIDGETS_END);
                                                       ECHO_P;
                                                       return T_ACTION_WIDGETS_END; }

\<action\-widget[ \t]+response[ \t]*\=                {ECHO_L (T_ACTION_WIDGET_RESPONSE);
                                                       Enter (S_ACTION_RESPONSE);
                                                       ECHO_P;
                                                       return T_ACTION_WIDGET_RESPONSE;}
<S_ACTION_RESPONSE>{QUOTED_INTEGER}                   {ECHO_L (T_QUOTED_INTEGER);
                                                       ECHO_P;
                                                       return T_QUOTED_INTEGER;}
<S_ACTION_RESPONSE>[ \t]*\>                           {ECHO_L (T_END);
                                                       Enter (S_ACTION_RESPONSE_1);
                                                       ECHO_P;
                                                       return T_END;}
<S_ACTION_RESPONSE_1>{IDENTIFIER}                     {ECHO_L (T_IDENTIFIER);
                                                       ECHO_P;
                                                       return T_IDENTIFIER;}
<S_ACTION_RESPONSE_1>\<\/action\-widget[ \t]*\>       {ECHO_L (T_ACTION_WIDGET_RESPONSE_END);
                                                       Enter (INITIAL);
                                                       ECHO_P;
                                                       return T_ACTION_WIDGET_RESPONSE_END;}

-----------------------------------------------------------------------------------------------
%%
with Glade_Parser_Tokens; use Glade_Parser_Tokens;

package Glade_Scanner is

   Scan_Debug : Boolean := False;

   function Yylex return Token;

end Glade_Scanner;


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

package Convert_States_To_Names is

   procedure Initialize (Scanner_Filename : String);

   function State_Name (I : Integer) return String;

end Convert_States_To_Names;


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
with Ada.Text_IO;
with Ada.Strings;           use Ada.Strings;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with GNAT.Strings;          use GNAT.Strings;
with GNATCOLL.Utils;        use GNATCOLL.Utils;
with Ada.Containers.Vectors;

package body Convert_States_To_Names is

   package TIO renames Ada.Text_IO;

   package Vector_Pkg is new Ada.Containers.Vectors
     (Element_Type => String_Access,
      Index_Type   => Natural,
      "="          => "=");
   Name : Vector_Pkg.Vector := Vector_Pkg.Empty_Vector;

   Index : Natural;

   --------------------------------------------------------------------------
   function Process (S : String) return Boolean;
   function Process (S : String) return Boolean is
   begin
      if Trim (S, Both) /= "" then
         Name.Append (new String'(Trim (S, Both)));
      end if;
      return True;
   end Process;

   --------------------------------------------------------------------------
   procedure Initialize (Scanner_Filename : String) is
      SF   : TIO.File_Type;
      Line : String (1 .. 1024);
      Last : Natural;
   begin
      TIO.Open (SF, TIO.In_File, Scanner_Filename);

      Name.Append (new String'("INITIAL"));

      while not TIO.End_Of_File (SF) loop
         TIO.Get_Line (SF, Line, Last);
         Index := 1;
         Skip_Blanks (Line (1 .. Last), Index);
         if Index < Last then
            if Starts_With (Line (Index .. Last), "%s ") then
               Split (Line (Index + 2 .. Last), " ", Process'Access);
            elsif Starts_With (Line (Index .. Last), "%start ") then
               Split (Line (Index + 6 .. Last), " ", Process'Access);
            elsif Starts_With (Line (Index .. Last), "%x ") then
               Split (Line (Index + 6 .. Last), " ", Process'Access);
            end if;
         end if;
      end loop;

      TIO.Close (SF);
   end Initialize;

   --------------------------------------------------------------------------
   function  State_Name (I : Integer) return String is
   begin
      if I > Integer (Name.Length) then
         return "Invalid";
      end if;
      return Name.Element (I).all;
   end State_Name;

end Convert_States_To_Names;

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
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Convert_States_To_Names;  use Convert_States_To_Names;

package body Glade_Scanner is

   Need_Echo_P             : Boolean := False;
   Missing_Previous_ECHO_P : exception;
   Missing_Previous_ECHO_L : exception;

   function Linenum return String;
   function Linenum return String is
      Line_Number_String : constant String := Integer'Image (Yy_Line_Number);
      Blanks : constant String
        (1 .. 7 - Integer (Line_Number_String'Length)) :=
        (others => ' ');
   begin
      return Line_Number_String & Blanks;
   end Linenum;

   procedure Echo_L (Tk : Token);
   procedure Echo_L (Tk : Token) is
      State : constant Natural := (Yy_Start - 1) / 2;
   begin
     YYLVal := To_Unbounded_String (YYText);
     if Scan_Debug then
         if Need_Echo_P then
            raise Missing_Previous_ECHO_P;
         end if;
         Ada.Text_IO.Put
           (Linenum & "State [" & State_Name (State) & "]"
            & ", Received Token :" & Yytext & ":"
            & " => " & Tk'Image);
         Need_Echo_P := True;
      end if;
   end Echo_L;

   procedure Echo_P;
   procedure Echo_P is
      State : constant Natural := (Yy_Start - 1) / 2;
   begin
      if Scan_Debug then
         if not Need_Echo_P then
            raise Missing_Previous_ECHO_L;
         end if;
         Ada.Text_IO.Put_Line (", New State [" & State_Name (State) & "]");
         Need_Echo_P := False;
      end if;
   end ECHO_P;
##
end Glade_Scanner;