#cp1251#########################################################################
#	Тексты / text v2.0 26/11/2006
#	Автор: Шургалин Евгений | shurgalin@infolio.ru
################################################################################

@CLASS
text
#/CLASS

@auto[]
	$server[$MAIN:connect_db]
	$tables[
		$.text[${MAIN:TABLES_PREFIX}text]
	]
#/auto

@create[id]
	$process-text(false)
	^if(def $id){
		^server{
			$__data[^table::sql{
				SELECT
					`text_id` AS `id`,
					`title`,
					`text`,
					`published`,
					`date`,
					`meta-description`,
					`meta-keywords`
				FROM `${tables.text}`
				WHERE `text_id` = '$id'
			}]
		}
		^if(!$__data){
			^throw[text.not_found;text.create]
		}
	}
#/create

@GET_id[]
	^if($__data){
		$result[$__data.id]
	}
#/GET_id

@GET_title[]
	^if($__data){
		$result[$__data.title]
	}
#/GET_title

@GET_text[]
	^if($__data){
		$result[$__data.text]
	}
#/GET_text

@GET_published[]
	^if($__data){
		$result[$__data.published]
	}
#/GET_published

@GET_date[]
	^if($__data){
		$result[^date::create[$__data.date]]
	}
#/GET_date

@GET_meta-description[]
	^if($__data){
		$result[^date::create[$__data.meta-description]]
	}
#/GET_meta-description

@GET_meta-keywords[]
	^if($__data){
		$result[^date::create[$__data.meta-keywords]]
	}
#/GET_meta-keywords

@xml[node;attr]
#$node[string]
#$attr[hash-of-strings]							- optional
	$result[^xdoc::create{<?xml version="1.0" encoding="$MAIN:CHARSET"?>^xml-string[$node;$attr]}]
#/xml

@xml-string[node;attr][k;v]
#$node[string]									- optional
#$attr[hash-of-strings]							- optional
	$result[]
	^if(def $__data){
		$result[
			<id>^taint[xml][$__data.id]</id>
			^if(def $__data.title){<title>^taint[xml][$__data.title]</title>}
			^if(def $__data.text){<text>^to_xml[$__data.text]</text>}
			<published>^__data.published.int(0)</published>
			<date>$__data.date</date>
			^if(def $__data.[meta-description]){<meta-description>^taint[xml][$__data.meta-description]</meta-description>}
			^if(def $__data.[meta-keywords]){<meta-keywords>^taint[xml][$__data.meta-keywords]</meta-keywords>}
		]
	}
	^if(def $node){$result[<${node} ^if(def $attr && $attr is hash){^attr.foreach[k;v]{ $k="^taint[xml][$v]"}}>$result</${node}>]}
#/xml-string

@update[params]
#$params[
#	$.id[string]
#	$.title[string] $.text[string]				- optional
#	$.published(int) $.date[date]				- optional
#]
	^if(def $params && def $params.id){
		^server{
			$update-cmd[
				`title` = ^if(def $params.title){ '$params.title' }{ NULL },
				`text` = ^if(def $params.text){ '$params.text' }{ NULL },
				`published` = ^if(def $params.published){ ^params.published.int(0) }{ 1 },
				`date` = ^if(def $params.date){ '^params.date.sql-string[]' }{ NOW() },
				`meta-description` = ^if(def $params.[meta-description]){ '$params.meta-description' }{ NULL },
				`meta-keywords` = ^if(def $params.[meta-keywords]){ '$params.meta-keywords' }{ NULL }
			]
			^if($MAIN:SQL_SETTINGS.USE_INSERT_UPDATE){
				^void:sql{
					INSERT INTO `${tables.text}` SET
						`text_id` = '$params.id',
						$update-cmd
					ON DUPLICATE KEY UPDATE
						$update-cmd
				}
			}{
				^if(^int:sql{ SELECT COUNT(*) FROM `${tables.text}` WHERE `text_id` = '$params.id' }[ $.limit(1) $.default{0} ]){
					^void:sql{
						UPDATE `${tables.text}` SET
							$update-cmd
						WHERE `text_id` = '$params.id'
					}
				}{
					^void:sql{
						INSERT INTO `${tables.text}` SET
							`text_id` = '$params.id',
							$update-cmd
					}
				}
			}
		}
	}
#/update

@delete[id]
	^if(def $id){
		^server{
			^void:sql{ DELETE FROM `${tables.text}` WHERE `text_id` = '$id' }
		}
	}
#/delete

@to_xml[text;para]
	^if(${process-text}){
		$result[^taint[xml][$text]]
	}{
		$result[^taint[as-is][$text]]
	}
#/to_xml