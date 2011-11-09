# Методы ресайзига картинок для каталога EKT
# Используя утилиту nconvert (http://www.xnview.com/)


@CLASS
nconvert




@auto[]
# В Windows системах определяется эта переменная среды
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
#	$.img_in[путь до исходного файла-картинки]
#	$.img_out[имя результирующего файла, если пусто - будет использован $.img_in]
#
#	$.quality[качество jpeg]
#	$.width[ширина, по умолчанию 100%]
#	$.height[высота, по умолчанию 100%]
#	
#	$.res[
#		full - отдает обект типа file
#		пусто,status - отдает только статус
#	]
#]

# Примечание 1: с флажком -ratio (см. в командной строке)
# картинка вписывается в прямоугольник $w x $h
# Если какое-то из этих значений равно нулю, его значение игнорируется
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
#	$.img_in[путь до исходного файла-картинки]
#	$.img_out[имя результирующего файла, если пусто - будет использован $.img_in]
#	
#	$.format[gif|jpg|jpeg|png]
#	$.quality[]
#	$.delete[yes — удалить оригинал]
#
#	$.colors[-truecolors | -dither -colors 256]
#		-truecolors <=> jpeg
#		-dither -colors 256 <=> gif
#
#	$.res[
#		full - отдает обект типа file
#		пусто,status - отдает только статус
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