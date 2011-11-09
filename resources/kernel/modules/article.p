#utf8###########################################################################
#	Ленты публикаций / article v3.3.1 01/12/2006
#	Автор: Шургалин Евгений | shurgalin@infolio.ru
#	Доработка: Солнцев Иван | prog@infolio2.ru
################################################################################

@CLASS
article
#/CLASS

@USE
modules/share.p
#/USE

@auto[]
	$server[$MAIN:connect_db]
	$tables[
		$.article[${MAIN:TABLES_PREFIX}article]
	]
	$__share_pid[]
	$__perpage[10]
# escape-xml - false - значит ^to_xml[] выполнит ^taint[as-is]
# escape-xml - true - значит ^to_xml[] выполнит ^taint[xml]
#/auto

@GET_share_pid[]
	^if(!def $__share_pid){
		^server{
			$__share_pid(^int:sql{ SELECT `share_id` FROM `${share:tables.share}` WHERE `pid` IS NULL AND `name` = '.article' AND `type` = 'dir' }[ $.limit(1) $.default{-1} ])
			^if(0 > $__share_pid){ $__share_pid(^share:create-dir[.article]) }
		}
	}
	$result($__share_pid)
#/GET_share_pid

#Constrictor
@list[params][prms;loc]
#$params[
#	$.type[NULL|int|int,int,...)	$.limit(0)	$.offset(0)
#	$.order[desc|asc]	$.with-body(0|1)
#	$.published(0|1)							- optional
#	$.date-from(date)	$.date-before(date)		- optional
#]
	$escape-xml(false)
	^if(def $params && $params is hash){
		$prms(true)
		$loc[^hash::create[]]
		^if(^params.limit.int(0)){ $loc.limit(^params.limit.int(0)) }
		^if(^params.offset.int(0)){ $loc.offset(^params.offset.int(0)) }
	}{
		$prms(false)
	}
	$_total(^count[$params])
	^server{
		$_list[^table::sql{
			SELECT
				`article_id` AS `id`,
				`type`,
				`title`,
				`lead`,
				^if($prms && $params.[with-body]){ `body`, }
#{ left(`body`,500) AS `lbody`,}
				`published`,
				`date`,
				`share_id`
			FROM `${tables.article}`
			WHERE
				1 = 1
				^if($prms && def $params.type){
					AND `type` in ($params.type)
				}
				^if($prms && def $params.published){
					AND `published` = ^params.published.int(0)
				}
				^if($prms && def $params.[date-before] && $params.[date-before] is date){
					AND `date` < '^params.date-before.sql-string[]'
				}
				^if($prms && def $params.[date-from] && $params.[date-from] is date){
					AND `date` >= '^params.date-from.sql-string[]'
				}
				^if($prms && ^params.next_id.int(0)){
					AND `date` < (SELECT `date` FROM `${tables.article}` WHERE `article_id` = $params.next_id)
				}
				^if($prms && ^params.prev_id.int(0)){
					AND `date` > (SELECT `date` FROM `${tables.article}` WHERE `article_id` = $params.prev_id)
				}
			ORDER BY
				`date` ^if($prms && def $params.order && ^params.order.upper[] eq "ASC"){ ASC }{ DESC }
			^if($params.page){
				LIMIT ^eval($params.page*$__perpage-$__perpage),$__perpage
			}
		}[$loc]]
	}
#/list

@generate_rss[params][i]
^if(!def $params){$params[^hash::create[]]}
$new[^list[
		$.type[$params.type]
		$.published(1)
		$.limit[^if(def $params.limit){$params.limit}{10}]
]]
$rdf[<?xml version="1.0" encoding="utf-8" ?>
<rss version="2.0">
<channel>
	<title>$params.title</title>
	<link>http://${env:HTTP_HOST}$params.link</link>
	<description>^if(def $params.description){$params.description}{$params.title}</description>
	^if(def $params.img){
		<image>
			<url>http://${env:HTTP_HOST}$params.img</url>
			<link>http://${env:HTTP_HOST}$params.link</link>
			<title>$param.title</title>
			^try{
				$i[^image::measure[$params.img]]
				<width>$i.width</width>
				<height>$i.height</height>
			}{
				$exception.handled(true)
			}
		</image>
	}
^_list.menu{
	<item>
		<title>$_list.title</title>
		<description>$_list.lead</description>
		<link>http://${env:HTTP_HOST}${params.link}${_list.id}.html</link>
		<guid>http://${env:HTTP_HOST}${params.link}${_list.id}.html</guid>
		^try{
			$dt[^date::create[$_list.date]]
			<pubDate>${dt.year}-${dt.month}-${dt.day}T00:00:00+03:00</pubDate>
		}{ $exception.handled(true) }
	</item>
}
</channel>
</rss>]
^rdf.save[/news.rss]
#/generate_rss[params]


@count[params]
	^if(def $params && $params is hash){
	}{
		$params[^hash::create[]]
	}
	^server{
		$result(^int:sql{
			SELECT
				COUNT(*)
			FROM `${tables.article}`
			WHERE 1=1
			^if(def $params.type){ AND `type` in ($params.type) }
			^if($params.published){ AND `published` = ^params.published.int(0) }
			^if(def $params.[date-before] && $params.[date-before] is date){ AND `date` < '^params.date-before.sql-string[]' }
			^if(def $params.[date-from] && $params.[date-from] is date){ AND `date` >= '^params.date-from.sql-string[]' }
			ORDER BY `date` ^if(def $params.order && ^params.order.upper[] eq "ASC"){ ASC }{ DESC }
		})
	}
#/count

#Constrictor
@calendar[params][prms;tmp]
#$params[
#	$.with-body(0|1)
#	$.type(0)	$.published(0|1)				- optional
#	$.date-from(date)	$.date-before(date)		- optional
#]
	$escape-xml(false)
	^if(def $params && $params is hash){ $prms(true) }{ $prms(false) }
#		short version of calendar - only year and month
	^server{
		$_calendar[^table::sql{
			SELECT
				YEAR(`date`) AS `y`,
				MONTH(`date`) AS `m`,
				count(*) AS `c`
			FROM `${tables.article}`
			WHERE `type` = ^if($prms){ ^params.type.int(0) }{ 0 }
			^if($prms && def $params.published){ AND `published` = ^params.published.int(0) }
			^if($prms && def $params.[date-before] && $params.[date-before] is date){ AND `date` < '^params.date-before.sql-string[]' }
			^if($prms && def $params.[date-from] && $params.[date-from] is date){ AND `date` >= '^params.date-from.sql-string[]' }
			GROUP BY `y`,`m`
			ORDER BY `y`,`m`
		}]
	}
#/calendar

#Constrictor
@article[id;published]
#$id(0)
#$published(0|1)								- optional
	$escape-xml(false)
	^if(^id.int(0) > 0){
		^server{
			$_article[^table::sql{
				SELECT
					`article_id` AS `id`,
					`type`,
					`title`,
					`lead`,
					`body`,
					`published`,
					`date`,
					`meta-description`,
					`meta-keywords`,
					`share_id`
				FROM `${tables.article}`
				WHERE `article_id` = ^id.int(0)
				^if(def $published){ AND `published` = ^published.int(0) }
			}]
		}
#		Время последнего редактирования, нужно еще одно поле под него
#		^use_module[dtf]
#		$response:Last-Modified[^dtf:to822[^date::create[$_article.date]]]
	}
#/article

@GET_table[]
	^if($_list is table){
		$result[$_list]
	}{
		^if($_article is table){
			$result[$_article]
		}{
			^throw[article.runtime;table;Can't convert object to table.]
		}
	}
#/GET_table

@GET_hash[]
	^if(def $_calendar && $_calendar is hash){
		$result[$_calendar]
	}{
		^throw[article.runtime;hash;Can't convert object to hash.]
	}
#/GET_hash


@xml[node;attr]
#$node[string]
#$attr[hash-of-strings]							- optional
	$result[^xdoc::create{<?xml version="1.0" encoding="$MAIN:CHARSET"?>^xml-string[$node;$attr]}]
#/xml

@xml-string[node;attr][k;v]
#$node[string]									- optional
#$attr[hash-of-strings]							- optional
	$result[]
	^if(def $_list){
		$result[^_list.menu{
			<article id="$_list.id" type="$_list.type" ^if($_list.published){ published="true" }>
				<date>$_list.date</date>
				<title>^taint[xml][$_list.title]</title>
				^try{<lead>^to_xml[$_list.lead]</lead>}{^if($exception.type eq "parser.runtime"){$exception.handled(1)}}
				^try{
					^if(def $_list.share_id){
						$k[^share::stat($_list.share_id)]
						^if(def $k.table.path){
							$v[^image::measure[$k.table.path]]
						}
						^if(def $v){
							<preview ^if(def $k.table.path){src="/share/^file:justname[$v.src].jpg"} width="$v.width" height="$v.height" />
						}
					}
				}{
					$exception.handled(1)
				}
				^try{
					<body>^taint[xml][$_list.body]</body>
				}{^if($exception.type eq "parser.runtime"){$exception.handled(1)}}
				^try{
					$body[$_list.lbody]
					$body[^body.match[(<[^^>]*>|<.*^$)][g]{}]
					<body>^to_xml[$body]</body>
				}{^if($exception.type eq "parser.runtime"){$exception.handled(1)}}
			</article>
		}]
	}
	^if(def $_calendar && $_calendar is table){
		$result[<calendar>
		^if(def $_calendar){
			$year[$_calendar.y]
			<year number="$_calendar.y">
		}
		^_calendar.menu{
			^if($_calendar.y eq $year){
				<month count="$_calendar.c" number="^if($_calendar.m < 10){0}$_calendar.m"/>
			}{
				$year[$_calendar.y]
				</year>
				<year number="$_calendar.y">
				<month count="$_calendar.c" number="^if($_calendar.m < 10){0}$_calendar.m"/>
			}
		}
		^if(def $_calendar){
			</year>
		}
		</calendar>]
	}
	^if(def $_article){
		$result[
			<article id="$_article.id" type="$_article.type" ^if($_article.published){ published="true" }>
				<date>$_article.date</date>
				<title>^taint[xml][$_article.title]</title>
				^try{<lead>^to_xml[$_article.lead]</lead>}{^if($exception.type eq "parser.runtime"){$exception.handled(1)}}
				^try{<body>^to_xml[$_article.body]</body>}{^if($exception.type eq "parser.runtime"){$exception.handled(1)}}
				^if(def $_article.[meta-description]){<meta-description>^taint[xml][$_article.meta-description]</meta-description>}
				^if(def $_article.[meta-keywords]){<meta-keywords>^taint[xml][$_article.meta-keywords]</meta-keywords>}
				^try{
					^if(def $_article.share_id){
						$k[^share::stat($_article.share_id)]
						^if(def $k.table.path){
							$v[^image::measure[$k.table.path]]
						}
						^if(def $v){
							<preview ^if(def $k.table.path){src="^if(^v.src.left(4) eq "/../"){^v.src.mid(3)}{$v.src}"} width="$v.width" height="$v.height" share_id="$_article.share_id" />
						}
					}
				}{
					$exception.handled(1)
				}
			</article>
		]
	}
	^if(def $node){$result[<${node} ^if(def $attr && $attr is hash){^attr.foreach[k;v]{ $k="^taint[xml][$v]"}}>$result</${node}>]}
#/xml-string

#Static method. Add or update article.
@update[params][share_id]
#$params[
#	$.type(0)	$.id()	$.date[]
#	$.title[]	$.lead[]	$.body[]			- optional
#	$.preview[file]		$.del-preview[DEF]		- optional
#	$.published(0|1)
#]
	^if(def $params && $params is hash){
		$result(^params.id.int(0))
		^if(def $params && ^params.id.int(0) && ($params.preview is file || def $params.[del-preview])){
			^server{
				$share_id(^int:sql{ SELECT `share_id` FROM `${tables.article}` WHERE `article_id` = ^params.id.int(0) }[ $.limit(1) $.default{0} ])
				^if($share_id){ ^share:delete($share_id) }
			}
		}
		^if(def $params.preview && $params.preview is file){
			^use_module[picture]
			$share_full_id(^share:add[^picture:resize[$params.preview](500)]($share_pid))
			$share_id(^share:add[^picture:resize[$params.preview](85)]($share_pid))
			
			^if(!^params.id.int(0)){
				$params.body[<img src="/share/${share_full_id}.jpg" alt="^taint[xml][$params.title]" title="^taint[xml][$params.title]"/><br/>$params.body]
			}
		}{
			^if(!^params.id.int(0) || def $params.[del-preview]){
				$share_id[NULL]
			}
		}
		^server{
			^if($MAIN:SQL_SETTINGS.USE_INSERT_UPDATE){
				^void:sql{
					INSERT INTO `${tables.article}` SET
						^if(^params.id.int(0)){ `article_id` = ^params.id.int(0), }
						`type` = ^params.type.int(0),
						`date` = ^if(def $params.date){'$params.date'}{NOW()},
						`title` = ^if(def $params.title){'$params.title'}{NULL},
						`lead` = ^if(def $params.lead){'$params.lead'}{NULL},
						`body` = ^if(def $params.body){'$params.body'}{NULL},
						`published` = ^params.published.int(0),
						^if(def $share_id){ `share_id` = $share_id, }
						`meta-description` = ^if(def $params.[meta-description]){ '$params.meta-description' }{ NULL },
						`meta-keywords` = ^if(def $params.[meta-keywords]){ '$params.meta-keywords' }{ NULL }
					ON DUPLICATE KEY UPDATE
						`type` = ^params.type.int(0),
						`date` = ^if(def $params.date){'$params.date'}{NOW()},
						`title` = ^if(def $params.title){'$params.title'}{NULL},
						`lead` = ^if(def $params.lead){'$params.lead'}{NULL},
						`body` = ^if(def $params.body){'$params.body'}{NULL},
						^if(def $share_id){ `share_id` = $share_id, }
						`published` = ^params.published.int(0),
						`meta-description` = ^if(def $params.[meta-description]){ '$params.meta-description' }{ NULL },
						`meta-keywords` = ^if(def $params.[meta-keywords]){ '$params.meta-keywords' }{ NULL }
				}
				^if(!$result){
					$result(^int:sql{ SELECT LAST_INSERT_ID() FROM `${tables.article}` }[ $.limit(1) $.default{0} ])
				}
			}{
				^if(!^params.id.int(0)){
					^void:sql{
						INSERT INTO `${tables.article}` SET
							`type` = ^params.type.int(0),
							`date` = ^if(def $params.date){'$params.date'}{NOW()},
							`title` = ^if(def $params.title){'$params.title'}{NULL},
							`lead` = ^if(def $params.lead){'$params.lead'}{NULL},
							`body` = ^if(def $params.body){'$params.body'}{NULL},
							`published` = ^params.published(0),
							^if(def $share_id){ `share_id` = $share_id, }
							`meta-description` = ^if(def $params.[meta-description]){ '$params.meta-description' }{ NULL },
							`meta-keywords` = ^if(def $params.[meta-keywords]){ '$params.meta-keywords' }{ NULL }
					}
				}{
					^void:sql{
						UPDATE `${tables.article}` SET
							`type` = ^params.type.int(0),
							`date` = ^if(def $params.date){'$params.date'}{NOW()},
							`title` = ^if(def $params.title){'$params.title'}{NULL},
							`lead` = ^if(def $params.lead){'$params.lead'}{NULL},
							`body` = ^if(def $params.body){'$params.body'}{NULL},
							`published` = ^params.published(0),
							^if(def $share_id){ `share_id` = $share_id, }
							`meta-description` = ^if(def $params.[meta-description]){ '$params.meta-description' }{ NULL },
							`meta-keywords` = ^if(def $params.[meta-keywords]){ '$params.meta-keywords' }{ NULL }
						WHERE `article_id` = ^params.id.int(0)
					}
				}
			}
		}
	}{
		$result(0)
	}
#/update

#Static method
@delete[id][share_id]
#$id[int|table[field]]
	^if(def $id && ($id is int || $id is double || $id is table)){
		^server{
			$share_id[^table::sql{
				SELECT `share_id`
				FROM `${tables.article}`
				WHERE `article_id` ^if($id is table){ IN (^id.menu{$id.field}[,])}{ = ^id.int(0) } AND `share_id` IS NOT NULL
			}]
			^if($share_id){ ^share_id.menu{ ^share:delete($share_id.share_id) } }
			^void:sql{
				DELETE FROM `${tables.article}`
				WHERE `article_id` ^if($id is table){ IN (^id.menu{$id.field}[,])}{ = ^id.int(0) }
			}
		}
	}
	$result[]
#/delete

@to_xml[text]
	^if(${escape-xml}){
		$result[^taint[xml][$text]]
	}{
		$result[^taint[as-is][$text]]
	}
#/to_xml
