#cp1251#########################################################################
#	Фотогалерея / gallery v0.2  29.05.2008
#	Автор: Солнцев Иван | prog@infolio2.ru
################################################################################

@CLASS
gallery
#/CLASS

@auto[]
	$server[$MAIN:connect_db]
	$tables[
		$.gallery[`${MAIN:TABLES_PREFIX}gallery`]
		$.gallery_text[`${MAIN:TABLES_PREFIX}gallery_text`]
	]
#/auto



@load[params]
	^server{
		$__data[^table::sql{
			SELECT
				g.`photo_id` as `id`,
				t.`lang`,
				t.`title`,
				t.`desc`,
				g.`group`,
				g.`published`,
				g.`share_photo`,
				g.`share_preview`
			FROM $tables.gallery g INNER JOIN $tables.gallery_text t using(`photo_id`)
			WHERE
				^if(def $params.lang){
					t.`lang` = '$params.lang' and
				}
				^if(def $params.id){
					g.`photo_id` = '$params.id'
				}{
					g.`group` = '$params.group'
					^if(!def $params.admin){and g.`published`='1'}
				}
			ORDER BY g.`ord` ^if($params.order eq "desc"){DESC}
		}]
		^if(def $params.id){
			$__langs[^table::sql{
				SELECT
					t.`photo_id` as `id`,
					t.`lang`,
					t.`title`,
					t.`desc`
				FROM $tables.gallery_text t
				WHERE
					t.`photo_id` = '$params.id'
			}]
		}
	}
#/load


@GET_preview[]
	^if(def $__data){
		$result[$__data.share_preview]
	}
#/GET_preview

@GET_photo[]
	^if(def $__data){
		$result[$__data.share_photo]
	}
#/GET_photo

@GET_title[]
	^if(def $__data){
		$result[$__data.title]
	}
#/GET_title

@GET_desc[]
	^if(def $__data){
		$result[$__data.desc]
	}
#/GET_title

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
			^__data.menu{
				<photo published="$__data.published" lang="$__data.lang" group="$__data.group">
					<id>$__data.id</id>
					^if(def $__langs){
						^__langs.menu{
							<title lang="$__langs.lang">$__langs.title</title>
							<desc lang="$__langs.lang">^to_xml[$__langs.desc]</desc>
						}
					}{
						<title>$__data.title</title>
						<desc>^to_xml[$__data.desc]</desc>
					}
					<preview>$__data.share_preview</preview>
					<photo>$__data.share_photo</photo>
				</photo>
			}
		]
	}
	^if(def $node){$result[<${node} ^if(def $attr && $attr is hash){^attr.foreach[k;v]{ $k="^taint[xml][$v]"}}>$result</${node}>]}
#/xml-string


@upload_pic[f;group][pid;ph;pv;s]
# сделать превью, сохранить в share
	$s[^share::list[]]
	^if($s.table is table && ^s.table.locate($s.table.name eq $group)){$pid[$s.table.share_id]}
	^if(!def $pid){ $pid[^share:create-dir[$group]] }
	
	^use_module[picture]
	$r[^picture:resize[$f](800;600)]
	$r[^picture:resize[$r](800;600)[
		$.watermark(true)
	]]
	$p[^picture:resize[$f](156;117)[
		$.crop(true)
		$.crop_ratio_w(4)
		$.crop_ratio_h(3)
	]]
	
	$ph[^share:add[$r;$pid;^file:justname[$r.name].jpg]]
	$pr[^share:add[$p;$pid;^file:justname[$r.name]_prv.jpg]]
	
	$result[$.preview[$pr] $.photo[$ph]]
#/upload_pic

@update[params][p;id]
#$params[
#	$.id[string]
#	$.title[string] $.text[string]				- optional
#	$.published(int) $.date[date]				- optional
#]
	^if(def $params && $params is hash){
		^server{
			$params.id(^params.id.int(0))
#			^dump[$params]
			^if(def $params.photo){
				^use_module[share]
				^if(def $params.id){
					$p[^table::sql{SELECT share_photo,share_preview FROM $tables.gallery WHERE photo_id='$params.id'}]
#					^dump[$p]
					^share:delete[$p.share_preview]
					^share:delete[$p.share_photo]
				}
				$p[^upload_pic[$params.photo;$params.group]]
			}
			^if($MAIN:SQL_SETTINGS.USE_INSERT_UPDATE){
				^void:sql{
					INSERT INTO $tables.gallery SET
						`photo_id` = '$params.id',
#						`title` = ^if(def $params.title){ '$params.title' }{ NULL },
#						`desc` = ^if(def $params.desc){ '$params.desc' }{ NULL },
						^if(def $p){
							`share_photo`='$p.photo',
							`share_preview`='$p.preview',
						}
						`group` = '$params.group',
						`published` = ^if(def $params.published){ ^params.published.int(0) }{ 1 }
					ON DUPLICATE KEY UPDATE
#						`title` = ^if(def $params.title){ '$params.title' }{ NULL },
#						`desc` = ^if(def $params.desc){ '$params.desc' }{ NULL },
						^if(def $p){
							`share_photo`='$p.photo',
							`share_preview`='$p.preview',
						}
						`group` = '$params.group',
						`published` = ^if(def $params.published){ ^params.published.int(0) }{ 1 }
				}
				^if(!$params.id){
					$id[^int:sql{SELECT LAST_INSERT_ID()}]
					^void:sql{UPDATE $tables.gallery SET `ord`=`photo_id` WHERE `photo_id`='$id'}
				}{
					$id[$params.id]
				}
				^params.foreach[k;v]{
					^if(^k.left(5) eq "desc_"){
						^void:sql{
							INSERT INTO $tables.gallery_text SET
								`photo_id` = '$id',
								`lang`='^k.right(2)',
								`title`='$v',
								`desc`='$params.[desc_^k.right(2)]'
							ON DUPLICATE KEY UPDATE
								`title`='$v',
								`desc`='$params.[desc_^k.right(2)]'
						}
					}
				}
			}{
				^if(^int:sql{ SELECT COUNT(*) FROM $tables.gallery_text WHERE `text_id` = '$params.id' }[ $.limit(1) $.default{0} ]){
					^void:sql{
							UPDATE $tables.gallery_text SET
							`title` = ^if(def $params.title){ '$params.title' }{ NULL },
							`desc` = ^if(def $params.desc){ '$params.desc' }{ NULL },
							^if(def $p){
								`share_photo`='$p.photo',
								`share_preview`='$p.preview',
							}
							`group` = '$params.group',
							`published` = ^if(def $params.published){ ^params.published.int(0) }{ 1 }
						WHERE `photo_id` = '$params.id'
					}
				}{
					^void:sql{
						INSERT INTO $tables.gallery_text SET
						`title` = ^if(def $params.title){ '$params.title' }{ NULL },
						`desc` = ^if(def $params.desc){ '$params.desc' }{ NULL },
						^if(def $p){
							`share_photo`='$p.photo',
							`share_preview`='$p.preview',
						}
						`group` = '$params.group',
						`published` = ^if(def $params.published){ ^params.published.int(0) }{ 1 }
					}
				}
			}
		}
	}
#/update

@delete[id][t]
	^if(def $id){
		^server{
			$t[^table::sql{SELECT `share_preview`,`share_photo` FROM $tables.gallery WHERE `photo_id`='$id'}]
			^use_module[share]
			^share:delete[^file:justname[$t.share_preview]]
			^share:delete[^file:justname[$t.share_photo]]
			^void:sql{ DELETE FROM $tables.gallery WHERE `photo_id` = '$id' }
		}
	}
#/delete

@to_xml[text;para]
	^if(${escape-xml}){
		$result[^taint[xml][$text]]
	}{
		$result[^taint[as-is][$text]]
	}
#/to_xml

@swap[_ids]
	^server{
		$ids[^_ids.split[^;;h]]
		^if($ids && ^ids.0.int(0) && ^ids.1.int(0)){
			$order[^hash::sql{SELECT `photo_id`, `ord` FROM $tables.gallery WHERE `photo_id`=^ids.0.int(0) OR `photo_id`=^ids.1.int(0)}]
		}
		^if(def $order && ^order._count[] == 2){
			^void:sql{ UPDATE $tables.gallery SET `ord` = $order.[$ids.0].ord WHERE `photo_id`=^ids.1.int(0) }
			^void:sql{ UPDATE $tables.gallery SET `ord` = $order.[$ids.1].ord WHERE `photo_id`=^ids.0.int(0) }
		}
	}
#/swap