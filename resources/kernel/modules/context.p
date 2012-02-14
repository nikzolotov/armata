@CLASS
context

@auto[]
	$db[$MAIN:connect_db]
	$TABLES[
		$.CONTEXT[${MAIN:TABLES_PREFIX}context]
	]
	$escapeXml(false)


@create[_id]
	^if(def $_id){
		^db{
			$__data[^table::sql{
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
			
			^if(def $__data.copy){
				^create[$__data.copy]
			}
		}
	}


@update[_params][sql]
	^if(def $_params && def $_params.id){
		^db{
			$sql[
				`text` = ^if(def $_params.text){ '$_params.text' }{ NULL },
				`published` = ^if(def $_params.published){ ^_params.published.int(0) }{ 1 }
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
	
	^if(def $__data){
		$result[
			<id>$__data.id</id>
			^if(def $__data.text){<text>^toXml[$__data.text]</text>}
			<published>^__data.published.int(0)</published>
		]
	}
	^if(def $_node){$result[<${_node} ^if(def $_attr && $_attr is hash){^_attr.foreach[k;v]{ $k="^taint[xml][$v]"}}>$result</${_node}>]}

@toXml[text]
	^if($escapeXml){
		$result[^taint[xml][$text]]
	}{
		$result[^taint[as-is][$text]]
	}