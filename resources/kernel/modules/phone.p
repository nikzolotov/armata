################################################################################
#	Проекты
#	Автор: Золотов Никита (nikita@infolio.ru)
#	Дата создания: 9.11.2011
#	© Infolio / 2° | http://www.infolio.ru/
################################################################################

@CLASS
phone

@auto[]
	$db[$MAIN:connect_db]
	$TABLES[
		$.PHONE[${MAIN:TABLES_PREFIX}phone]
	]
	$SETTINGS[
		$.TAG[
			$.ITEM[phone]
		]
	]
	$escape-xml(false)


@list[_params]
	^db{
		$__list[^table::sql{
			SELECT
				`phone_id` AS `id`,
				`title`,
				`number`,
				`published`
			FROM
				`${TABLES.PHONE}`
			WHERE
				1 = 1
				^if(!def $_params.admin){
					AND `published` = 1
				}
		}]
	}

@phone[_params]
	^if(^_params.id.int(0)){
		^db{
			$__phone[^table::sql{
				SELECT
					`phone_id` AS `id`,
					`title`,
					`number`,
					`desc`,
					`published`
				FROM
					`${TABLES.PHONE}`
				WHERE
					`phone_id` = $_params.id
					
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
		^if($__phone is table){
			$result[$__phone]
		}{
			^throw[phone.runtime;table;Can't convert object to table.]
		}
	}


@update[_params][share_id]
	^if(def $_params && $_params is hash){
		$result(^_params.id.int(0))
		$sql[
			`title` = ^if(def $_params.title){'$_params.title'}{NULL},
			`number` = ^if(def $_params.number){'$_params.number'}{NULL},
			`desc` = ^if(def $_params.desc){'$_params.desc'}{NULL},
			`published` = ^_params.published.int(0)
		]
		^db{
			^void:sql{
				INSERT INTO `${TABLES.PHONE}` SET
					^if(^_params.id.int(0)){`phone_id` = ^_params.id.int(0),}
					$sql
				ON DUPLICATE KEY UPDATE
					$sql
			}
			^if(!$result){
				$result(^int:sql{ SELECT LAST_INSERT_ID() FROM `${TABLES.PHONE}` }[ $.limit(1) $.default{0} ])
			}
		}
	}{
		$result(0)
	}

@delete[_id]
	^if(^_id.int(0)){
		^db{
			^void:sql{DELETE FROM `${TABLES.PHONE}` WHERE `phone_id` = '$_id'}
		}
	}


@xml-string[node;attr][k;v]
	$result[]
	^if(def $__list){
		$result[
			^__list.menu{
				<$SETTINGS.TAG.ITEM id="$__list.id"^if($__list.published){ published="true"}>
					^if(def $__list.title){<title>^to_xml[$__list.title]</title>}
					^if(def $__list.number){<number>^to_xml[$__list.number]</number>}
				</$SETTINGS.TAG.ITEM>
			}
		]
	}
	^if(def $__phone){
		$result[
			<$SETTINGS.TAG.ITEM id="$__phone.id"^if($__phone.published){ published="true"}>
				^if(def $__phone.title){<title>^to_xml[$__phone.title]</title>}
				^if(def $__phone.number){<number>^to_xml[$__phone.number]</number>}
				^if(def $__phone.desc){<desc>^to_xml[$__phone.desc]</desc>}
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
