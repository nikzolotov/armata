# ������ ��������� �������� ��� �������� EKT
# ��������� ������� nconvert (http://www.xnview.com/)


@CLASS
nconvert




@auto[]
# � Windows �������� ������������ ��� ���������� �����
	^if(def $env:WINDIR){
		$PATH_TO_NCONVERT[${MAIN:NCONVERT_DIR}/nconvert.exe]
	}{
		$PATH_TO_NCONVERT[${MAIN:NCONVERT_DIR}/nconvert.sh]
	}
#/auto




@doc[]
$f[^file::exec[$PATH_TO_NCONVERT;;-help]]
$result[$f.text]
#/doc


#$params[
#	$.img_in[���� �� ��������� �����-��������]
#	$.img_out[��� ��������������� �����, ���� ����� - ����� ����������� $.img_in]
#
#	$.quality[�������� jpeg]
#	$.width[������, �� ��������� 100%]
#	$.height[������, �� ��������� 100%]
#	
#	$.res[
#		full - ������ ����� ���� file
#		�����,status - ������ ������ ������
#	]
#]

# ���������� 1: � ������� -ratio (��. � ��������� ������)
# �������� ����������� � ������������� $w x $h
# ���� �����-�� �� ���� �������� ����� ����, ��� �������� ������������
#
@resize[params][quality;w;h;f]

$quality(^params.quality.int(80))

^if(def $params.width){$w[$params.width]}{$w(0)}
^if(def $params.height){$h[$params.height]}{$h(0)}

^if(def $params.img_out){$out[$params.img_out]}{$out[$params.img_in]}

$f[^file::exec[$PATH_TO_NCONVERT;;-ratio;-rflag decr;-q $quality $params.colors;-rmeta;-rtype lanczos;-resize $w $h;-o ${env:DOCUMENT_ROOT}$out;${env:DOCUMENT_ROOT}$params.img_in]]
^if((!def $params.res) || ($params.res eq status)){
	$result($f.status)
}{
	$result[$f]
}
#/resize


#$params[
#	$.img_in[���� �� ��������� �����-��������]
#	$.img_out[��� ��������������� �����, ���� ����� - ����� ����������� $.img_in]
#	
#	$.format[gif|jpg|jpeg|png]
#	$.quality[]
#	$.delete[yes � ������� ��������]
#
#	$.colors[-truecolors | -dither -colors 256]
#		-truecolors <=> jpeg
#		-dither -colors 256 <=> gif
#
#	$.res[
#		full - ������ ����� ���� file
#		�����,status - ������ ������ ������
#	]
#]
@format[params][d;f;quality;c]
^if((def $params.delete) && ($params.delete eq yes)){$d[-D]}{$d[]}
$quality(^params.quality.int(80))

^if(def $params.img_out){$out[$params.img_out]}{$out[$params.img_in]}

^if(def $params.width){$w[$params.width]}{$w(0)}
^if(def $params.height){$h[$params.height]}{$h(0)}

^if(def $params.colors){$c[$params.colors]}

$f[^file::exec[$PATH_TO_NCONVERT;;-q $quality;-ratio;-rflag decr;-rtype lanczos;-resize $w $h;-rmeta $d -out $params.format $c;-o ${env:DOCUMENT_ROOT}$out;${env:DOCUMENT_ROOT}$params.img_in]]
^if((!def $params.res) || ($params.res eq status)){
	$result($f.status)
}{
	$result[$f]
}
#/format