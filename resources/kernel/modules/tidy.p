@tidy[s]
$s[^s.match[<dr>][gi]{<br>}]
^if(def $env:WINDIR){
#	windows platform
	$ext[.exe]
}
$f[^file::exec[${MAIN:TIDY_DIR}/tidy$ext;$.stdin[$s];-config;${request:document-root}${MAIN:TIDY_DIR}/tidy.cfg]]
$result[^taint[$f.text]]
^if(!def $result){
	^throw[tidy.error;$f.stderr (status=$f.status)
----------------
$s]
}
#/parse