@CLASS
context

@auto[]
	$db[$MAIN:connect_db]
	$TABLES[
		$.CONTEXT[${MAIN:TABLES_PREFIX}context]
	]
	$escapeXml(false)


@context[_id]
	^if(def $_id){
		^db{
			$__context[^table::sql{
				SELECT
					`page_id` AS `id`,
					`copy_page_id` AS `copy`,
					`text`,
					`published`
				FROM
					`${TABLES.CONTEXT}`
				WHERE
					`page_id` = '$_id'
			}]
		}
	}

@list[]
		^db{
			$__list[^table::sql{
				SELECT
					`page_id` AS `id`,
					`copy_page_id` AS `copy`,
					`published`
				FROM
					`${TABLES.CONTEXT}`
			}]
		}

@GET_table[]
	^if($__context is table){
		$result[$__context]
	}


@update[_params][sql]
	^if(def $_params && def $_params.id){
		^db{
			$sql[
				`copy_page_id` = ^if(def $_params.copy_page_id){ '$_params.copy_page_id' }{ NULL },
				`text` = ^if(def $_params.text){ '$_params.text' }{ NULL },
				`published` = ^_params.published.int(0)
			]
			^void:sql{
				INSERT INTO `${TABLES.CONTEXT}` SET
					`page_id` = '$_params.id',
					$sql
				ON DUPLICATE KEY UPDATE
					$sql
			}
		}
	}

@delete[_id]
	^if(def $_id){
		^db{
			^void:sql{ DELETE FROM `${TABLES.CONTEXT}` WHERE `page_id` = '$_id' }
		}
	}


@xmlString[_node;_attr][k;v]
	$result[]
	
	^if(def $__context){
		$result[
			<context published="^__context.published.int(0)">
				<id>$__context.id</id>
				<copy>$__context.copy</copy>
				^if(def $__context.text){<text>^toXml[$__context.text]</text>}
			</context>
		]
	}
	
	^if(def $__list){
		$result[
			^__list.menu{
				<context published="^__list.published.int(0)">
					<id>$__list.id</id>
					<copy>$__list.copy</copy>
				</context>
			}
		]
	}
	
	^if(def $_node){$result[<${_node} ^if(def $_attr && $_attr is hash){^_attr.foreach[k;v]{ $k="^taint[xml][$v]"}}>$result</${_node}>]}

@toXml[text]
	^if($escapeXml){
		$result[^taint[xml][$text]]
	}{
		$result[^taint[as-is][$text]]
	}