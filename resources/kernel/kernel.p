#utf8###########################################################################
#	Ядро сайта v1.3.3 24/10/2006
#	Автор: Шургалин Евгений | shurgalin@infolio.ru
################################################################################

@USE
auto.p
templates.p
#/USE

@auto[]
	^if(def $TEMPLATES_DIR){
		$Templates[^templates::create[$TEMPLATES_DIR^if(^TEMPLATES_DIR.right(1) ne "/"){/}]]
	}

	^if(def $NAVIGATION_FILE && -f $NAVIGATION_FILE){
		$Navigation[^xdoc::load[$NAVIGATION_FILE]]
	}
	
#	Определяем хеш параметров XSLT-трансформации
	^if(${XSL-Params} is hash){
		$XSL-Params.DateNow[^date::now[]]
		$XSL-Params.DateNow[^XSL-Params.DateNow.sql-string[]]
		$XSL-Params.ServerName[$env:SERVER_NAME]
		$XSL-Params.RequestURI[$request:uri]
		$XSL-Params.Referer[$env:HTTP_REFERER]
	}
#/auto


@preprocess[body]
	$result[$body]

@postprocess[body][xml-body;node]
	^if($body is string){
#	Если параметр является строкой, то обрабатываем её...
		^try{
			$xml-body[^xdoc::create{<?xml version="1.0" encoding="$CHARSET"?><page>^preprocess[$body]</page>}]
		}{
			^body.save[/../logs/body.xml]
		}
		^if(def $Navigation && $Navigation is xdoc){
			$Navigation[^navigation_path[$Navigation;$request:uri]]
			$node[^xml-body.documentElement.appendChild[^xml-body.importNode[$Navigation.documentElement](1)]]
		}
		^if($site_postprocess is junction){$xml-body[^site_postprocess[$xml-body]]}
		^if(def $Templates && !^Templates.empty[]){
			$result[^xml-body.transform[^Templates.xdoc[];$XSL-Params]]
			$result[^result.string[ $XSL-Output ]]
		}{
			$response:content-type[text/xml]
			$result[^xml-body.string[]]
		}
	}{
#	...в противном случае возвращаем как есть.
		$result[$body]
	}
#/postprocess

#Метод для модключения модулей ядра.
@use_module[name]
	^try{
		^use[modules/${name}.p]
	}{
		^if($exception.type eq parser.runtime){
			^if(!$DEBUG){
				$exception.handled(1)
				^throw[kernel.runtime;$name;Module '$name' not found.]
			}
		}
	}
#/use_module

@navigation_path[_tree;_path][tree;path;path_parts;node;new_node;list;qs;i;flag;base]
	$tree[$_tree]
	$path[$_path]
	$base[^tree.documentElement.getAttribute[base]]
	^if(def $base && ^path.match[^^$base]){$path[^path.match[^^${base}(.+)^$][]{$match.1}]}
	$path[^path.split[?]]
	$path[$path.piece]
	^if(^path.match[index\.(s|x|p)?html?^$][]){
		$path[^path.match[^^(.+)index\.(s|x|p)?html?^$][]{$match.1}]
	}{
		$path[^path.match[^^(.+)(\.(s|x|p)?html?|\/)^$][]{$match.1}/]
	}
	$path[^path.match[^^\/(.+)^$][]{$match.1}]
	^if(^_path.pos[?]>0){
		$qs[^_path.match[^^([^^\?]+)\?(.+)?^$][]{$match.2}]
	}{
		$qs[]
	}

	$node[$tree.documentElement]
	^if(! ^path.match[^^\/+^$]){
		$path_parts[^path.split[/]]
		^if($path_parts){
			$flag(0)
			^while(!$flag){
				^if(def $node){
					$new_node[^node.selectSingle[item[@key='$path_parts.piece'] | group/item[@key='$path_parts.piece']]]
					^if(!def $new_node){
						$new_node[^node.selectSingle[item[not(@key)] | group/item[not(@key)]]]]
						^path_parts.offset(-1)
					}
					^if(!def $new_node){ $node[] $flag(1) }{
						^new_node.setAttribute[in;in]
						^if($new_node.parentNode.nodeName eq item){ ^new_node.parentNode.removeAttribute[hit] }
						^if(^path_parts.line[] == ^path_parts.count[] && !def $qs){
							^new_node.setAttribute[hit;hit]
						}
						$node[$new_node]
						$new_node[]
					}
				}
			^path_parts.offset(1)
			}
		}
	}{
		$path[]
		$node[^node.selectSingle[item[not(@key) or group/item[not(@key)]]]]
		^if($node){
			^node.setAttribute[in;in]
			^node.setAttribute[hit;hit]
		}
	}
	$result[$tree]
#/navigation_path

@unhandled_exception[exception;stack]
	^switch[$exception.type]{
		^case[file.missing]{
			^if(def $404_ERROR_DOCUMENT){
				$exception.handled(1)
				$response:location[$404_ERROR_DOCUMENT]
			}{
				^unhandled_exception_handler[$exception;$stack]
			}
		}
		^case[debug]{
			^taint[as-is][$exception.source]
			$exception.handled(1)
		}
		^case[kernel.location]{
			$exception.handled(1)
			^if(^exception.source.left(7) eq "http://"){
				$response:location[^taint[as-is][$exception.source]]
			}{
				^if(^exception.source.left(1) eq "?"){
					$url[^request:uri.left(^if(^request:uri.pos[?]>-1){^request:uri.pos[?]}{^request:uri.length[]})]
					$response:location[http://${env:HTTP_HOST}${url}^taint[as-is][$exception.source]]
				}{
					$response:location[http://${env:HTTP_HOST}^taint[as-is][$exception.source]]
				}
			}
		}
		^case[DEFAULT]{
			^unhandled_exception_handler[$exception;$stack]
		}
	}
#/unhandled_exception

@unhandled_exception_handler[exception;stack]
	^if($DEBUG){
		^unhandled_exception_debug[$exception;$stack]
	}{
		^unhandled_exception_release[$exception;$stack]
	}
#/unhandled_exception_handler