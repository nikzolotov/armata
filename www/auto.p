@USE
kernel.p

@auto[]
#	Определяем язык сайта
	$LANGUAGES[^xdoc::load[$RESOURCES_DIR/languages.xml]]
	$XSL-Params.default-lang[^LANGUAGES.documentElement.selectString[string(lang[1]/@id)]]
	$XSL-Params.lang[^if(def $form:lang && def ^LANGUAGES.documentElement.selectSingle[lang[@id='$form:lang']]){$form:lang}{$XSL-Params.default-lang}]
	^if($[XSL-Params].[default-lang] ne $[XSL-Params].lang){
		^Navigation.documentElement.setAttribute[base;/$XSL-Params.lang]
	}

#	Id страницы
	$PAGE_ID[^page-id[]]
	
	^Templates.add[page.xsl]

@preprocess[body][phones;phonesXML;context]
#	Контактные телефоны
	^use_module[phone]

	$phonesXML[
		^cache[$CACHE_DIR/phones]($CACHE_TTL*$USE_CACHE){
			$phones[^phone::list[]]
			^phones.xml-string[phones]
		}
	]
	
#	Содержимое левой колонки
	^use_module[context]
	$context[^context::context[$PAGE_ID]]
	
	^if(def $context.table.copy){
		$context[^context::context[$context.table.copy]]
	}
	
	$result[${body}${phonesXML}^context.xmlString[]]

@site_postprocess[result]
	^if($DEBUG && def $form:xml){ ^Templates.clear[] }
	
@page-id[]
	$result[$request:uri]
	^if(^result.pos[?] > 0){ $result[^result.left(^result.pos[?])] }
	^if(^result.match[/index\.html^$]){ $result[^result.match[^^(.*/)index\.html^$][]{$match.1}] }
	^if(^result.match[^^/(admin|print)/]){ $result[^result.match[/(admin|print)(.+)][]{$match.2}] }
	$result[^result.match[^^/(admin/|print/)?(.*)(/|\.html)^$][]{$match.2}]
	$result[^result.replace[^table::create{from	to
/	.}]]
	^if($result eq "."){ $result[index] }
	^if($[XSL-Params].lang eq $[XSL-Params].[default-lang]){
		$result[${XSL-Params.lang}.$result]
	}

@static-text[Page-Id]
	^use_module[text]
	^try{
		$Text[^text::create[$Page-Id]]
		^Text.xml-string[static-text]
	}{
		^if($exception.type eq "text.not_found"){
			<static-text>
				<title>404</title>
				<text>
					<p>Запрашиваемая страница не найдена.</p>
#					<p>$Page-Id</p>
				</text>
			</static-text>
			$exception.handled(true)
			$response:status[404 Not found]
		}
	}
	^use_module[gallery]
	$g[^gallery::load[
		$.group[$Page-Id]
		$.lang[$XSL-Params.lang]
		$.order[desc]
	]]
	^g.xml-string[gallery]


# выставляет переменные для страничного скроллера, возвращает offset
@set_pages[perpage;total;page]
# $perpage - количество элементов на странице
# $total - количество элементов всего
# $page - текущая страница
	^if(0 >= ^perpage.int(0)){ $perpage(5) }
	$page(^page.int(-1))
	$last(^math:ceiling($total / $perpage))
	^if($page > $last || $page == -1){ $page($last) }
	^if(1 > $page){ $page(1) }
	^if(($page < $last) && ($total % $perpage)){
		$result(($last - $page - 1) * $perpage + $total % $perpage)
	}{
		$result(($last - $page) * $perpage)
	}
	$result[
		$.xml[<pages page="$page" last="$last" total="$total" ^if(def $form:query){
		query="$form:query" q-query="^taint[uri][$form:query]"} />]
		$.offset(^if($result > 0){$result}{0})
	]