#! /usr/bin/bash

prettyprint="gnatpp --keyword-lower-case --attribute-mixed-case --name-mixed-case --pragma-mixed-case \
            --enum-case-as-declared --type-mixed-case --number-mixed-case \
            --comments-gnat-indentation"
           
function pp {
	echo gnatpp ${1}
	${prettyprint} ${1}
}

# -E generate token information for ayacc
# -s suppress default rule to echo unmached text
# -d generate the scanner with debug mode
# -T run in trace mode

echo /usr/local/bin/aflex -s -E glade_scanner.l
/usr/local/bin/aflex -s -E glade_scanner.l
if [ $? -ne 0 ]; then
    exit
fi


/opt/GNAT/15.1.0-2/bin/gnatchop -vw glade_scanner.ada
rm -v glade_scanner.ada
pp glade_scanner.ads
pp glade_scanner.adb
pp glade_scanner_dfa.ads
pp glade_scanner_dfa.adb
pp glade_scanner_io.ads
pp glade_scanner_io.adb


# -v produce a verbose aux file
# -l loud option
# -d generate the parser with debugging support
# -r generate the parser with error recovery
# -k keep case of tokens
# -e filename.y

echo ""
echo /usr/local/bin/ayacc -k -e .ada glade_parser.y
/usr/local/bin/ayacc -k -e .ada glade_parser.y
if [ $? -ne 0 ]; then
    exit
fi

/opt/GNAT/15.1.0-2/bin/gnatchop -vw glade_parser.ada
rm -v glade_parser.ada
pp glade_parser.adb
pp glade_parser.ads
pp glade_parser_goto.ads
pp glade_parser_shift_reduce.ads
pp glade_parser_tokens.ads

echo ""
echo gprbuild -P ../g2a.gpr
/opt/GNAT/15.1.0-2/bin/gprbuild -P ../g2a.gpr
