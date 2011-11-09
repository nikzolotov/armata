@auto[]
#	^Templates.clear[]
	^Templates.add[admin/common.xsl]
#	 Страницы админки не кешируются
	$response:Expires[Mon, 26 Jul 1997 05:00:00 GMT]
	$response:Cache-Control[no-cache, must-revalidate]
	$response:Pragma[no-cache]
#	$response:Last-modified[]

@preprocess[body]
	$result[$body]

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
#/set_pages