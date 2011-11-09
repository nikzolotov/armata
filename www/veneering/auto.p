@auto[]
	$files[^table::create{name	title	ext	size
#veenering_price_april_2008	Прайс на фанерование, Апрель 2008	xls	70
veenering_order_blank	Бланк заявки на&#160^;фанерование	xls	60
}]

@context[]
	<context>
		<ul class="files">
			^files.menu{
				<li class="$files.ext">
					<a href="/docs/${files.name}.${files.ext}">$files.title</a><br/>
					($files.ext, $files.size кб)
				</li>
			}
		</ul>
	</context>