################################################################################
#	Проекты
#	Автор: Золотов Никита (nikita@infolio.ru)
#	Дата создания: 4.12.2008
#	© Infolio / 2° | http://www.infolio.ru/
################################################################################

@CLASS
project

@auto[]
	$db[$MAIN:connect_db]
	$TABLES[
		$.PROJECT[${MAIN:TABLES_PREFIX}project]
	]
	$SETTINGS[
		$.TAG[
			$.ITEM[project]
		]
	]
	$escape-xml(false)


@list[_params]
	^db{
		$__list[^table::sql{
			SELECT
				`project_id` AS `id`,
				`type`,
				`title`,
				`address`,
				LENGTH(`body`) AS `body_length`,
				`published`,
				`date`
			FROM
				`${TABLES.PROJECT}`
			WHERE
				1 = 1
				^if(^_params.type.int(0)){
					AND `type` = $_params.type
				}
				^if(!def $_params.admin){
					AND `published` = 1
				}
		}]
	}

@project[_params]
	^if(^_params.id.int(0)){
		^db{
			$__project[^table::sql{
				SELECT
					`project_id` AS `id`,
					`type`,
					`title`,
					`address`,
					`end`,
					`body`,
					`see_also`,
					`seo_title`,
					`published`,
					`date`
				FROM
					`${TABLES.PROJECT}`
				WHERE
					`project_id` = $_params.id
					
					^if(!def $_params.admin){
						AND `published` = 1
					}
			}]
		}
	}

@GET_table[]
	^if($__list is table){
		$result[$__list]
	}{
		^if($__project is table){
			$result[$__project]
		}{
			^throw[project.runtime;table;Can't convert object to table.]
		}
	}


@update[_params][share_id]
	^if(def $_params && $_params is hash){
		$result(^_params.id.int(0))
		$sql[
			`type` = ^_params.type.int(0),
			`title` = ^if(def $_params.title){'$_params.title'}{NULL},
			`address` = ^if(def $_params.address){'$_params.address'}{NULL},
			`end` = ^if(def $_params.end){'$_params.end'}{NULL},
			`body` = ^if(def $_params.body){'$_params.body'}{NULL},
			`see_also` = ^if(def $_params.see_also){'$_params.see_also'}{NULL},
			`seo_title` = ^if(def $_params.seo_title){'$_params.seo_title'}{NULL},
			`published` = ^_params.published.int(0),
			`date` = ^if(def $_params.date){'$_params.date'}{NOW()}
		]
		^db{
			^void:sql{
				INSERT INTO `${TABLES.PROJECT}` SET
					^if(^_params.id.int(0)){`project_id` = ^_params.id.int(0),}
					$sql
				ON DUPLICATE KEY UPDATE
					$sql
			}
			^if(!$result){
				$result(^int:sql{ SELECT LAST_INSERT_ID() FROM `${TABLES.PROJECT}` }[ $.limit(1) $.default{0} ])
			}
		}
	}{
		$result(0)
	}

@delete[_id]
	^if(^_id.int(0)){
		^db{
			^void:sql{DELETE FROM `${TABLES.PROJECT}` WHERE `project_id` = '$_id'}
		}
	}


@xml-string[node;attr][k;v]
	$result[]
	^if(def $__list){
		$result[
			^__list.menu{
				<$SETTINGS.TAG.ITEM id="$__list.id" type="$__list.type" body_length="$__list.body_length" ^if($__list.published){ published="true"}>
					^if(def $__list.title){<title>^to_xml[$__list.title]</title>}
					^if(def $__list.address){<address>^to_xml[$__list.address]</address>}
					<date>$__list.date</date>
				</$SETTINGS.TAG.ITEM>
			}
		]
	}
	^if(def $__project){
		$result[
			<$SETTINGS.TAG.ITEM id="$__project.id" type="$__project.type"^if($__project.published){ published="true"}>
				^if(def $__project.title){<title>^to_xml[$__project.title]</title>}
				^if(def $__project.address){<address>^to_xml[$__project.address]</address>}
				^if(def $__project.end){<end>^to_xml[$__project.end]</end>}
				^if(def $__project.body){<body>^to_xml[$__project.body]</body>}
				^if(def $__project.see_also){<see-also>^to_xml[$__project.see_also]</see-also>}
				^if(def $__project.seo_title){<seo-title>^to_xml[$__project.seo_title]</seo-title>}
				<date>$__project.date</date>
			</$SETTINGS.TAG.ITEM>
		]
	}
	^if(def $node){$result[<${node} ^if(def $attr && $attr is hash){^attr.foreach[k;v]{ $k="^taint[xml][$v]"}}>$result</${node}>]}

@to_xml[text]
	^if(${escape-xml}){
		$result[^taint[xml][$text]]
	}{
		$result[^taint[as-is][$text]]
	}
