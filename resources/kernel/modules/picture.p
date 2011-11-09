# Методы ресайзига картинок
# Используя утилиту nconvert (http://www.xnview.com/)

@CLASS
picture


@auto[]
# В Windows системах определяется эта переменная среды
	^if(def $env:WINDIR){
		$PATH_TO_NCONVERT[${MAIN:NCONVERT_DIR}/nconvert.exe]
	}{
		$PATH_TO_NCONVERT[${MAIN:NCONVERT_DIR}/nconvert.sh]
	}
	$PATH_TO_WATERMARK[${request:document-root}/img/watermark.png]

@nconvert[call][f]
	$f[^file::exec[$PATH_TO_NCONVERT;;^call.menu{$call.param}[ ]]]
	^if($f.status){
		^throw[nconvert error;;$f.status
----
$f.text
----
$f.stderr
]
	}
#	strip	copyright notice, we don`t need them in image processing
	$result[^f.text.match[\*\* .* \*\*\n.*\n.*\n\n;]{}
$f.stderr]
	$result[^result.trim[]]
	
@info[path][call;t;i]
	$call[^table::create{param}]
	^call.append{-info}
	^call.append{${env:DOCUMENT_ROOT}$path}
	$t[^nconvert[$call]]
	^if(^t.pos[: Success] == -1){
		^throw[nconvert error;unknown format]
	}
	$i[^hash::create[]]
	$t[^t.match[\n    (^[^^\n^]*^[^^ ^]) +: (^[^^\n^]*)][g]{$i.[$match.1][$match.2]}]
	$result[$i]

@resize[img;width;height;params][r;w;h;x;y;c;fn;ext;call]
#$img[file]
#$width(0)
#$height(0)
#$params[ - optional
#	$.colors[-truecolors|-colors (256, 216, 128, 64, 32, 16 or 8)]
#	$.format[jpeg|gif|png]
#	$.quality[80]
#	$.crop[true]
#]
	^if(!($img is file)){
		^throw[nconvert.bad_param;input file not specified]
	}
	$params[^hash::create[$params]]

	$call[^table::create{param}]
	$f[^if(def $params.format){$params.format}{jpeg}]
	^call.append{-out $f}
	^call.append{-q ^params.quality.int(80)}
	^call.append{^if(def $params.colors){$params.colors}{-truecolors}}
	^call.append{-rflag decr}
	^call.append{-rmeta}
	^call.append{-rtype lanczos}
	
	$fn[${MAIN:VAR_DIR}/^math:uuid[]]
	^img.save[binary;$fn]

	^if(def $params.crop){
		^if(!def $params.crop_ratio_w && !$params.crop_ratio_h){
			$i[^info[$fn]]
			$r($i.Width/$i.Height)
			^if($r > 1){
				$w($i.Height)
			}{
				$w($i.Width)
			}
			$h($w)
			$x(($i.Width - $w) / 2)
			$y(($i.Height - $h) / 2)
			^call.append{-crop $x $y $w $h}
		}{
			$i[^info[$fn]]
			$w($i.Width)
			$h($i.Height)
			$r($i.Width/$i.Height)
			^if($r > 1){
				$w($i.Height*$params.crop_ratio_w/$params.crop_ratio_h)
			}{
				$h($i.Width*$params.crop_ratio_h/$params.crop_ratio_w)
			}
			$x(($i.Width - $w) / 2)
			$y(($i.Height - $h) / 2)
			^call.append{-crop $x $y $w $h}
		}
	}{
		^call.append{-ratio}
	}
	^if(!def $params.watermark){
		^call.append{-resize ^width.int(0) ^height.int(0)}
	}
	
	^if(def $params.watermark){
		^call.append{-wmfile $PATH_TO_WATERMARK}
		^call.append{-wmflag ^if(def $params.watermark_flag){$params.watermark_flag}{center}}
	}

	$ext[^if($f eq "jpeg"){jpg}{$f}]
	^call.append{-o ${env:DOCUMENT_ROOT}${fn}.$ext}
	^call.append{${env:DOCUMENT_ROOT}$fn}
	$i[^nconvert[$call]]

	$f[^file::load[binary;${fn}.$ext]]

	^file:delete[$fn]
	^file:delete[${fn}.$ext]

	$result[$f]