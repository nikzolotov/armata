#cp1251#########################################################################
#	Управление файлами / share v1.4.1 29.05.2008
#	Автор: Шургалин Евгений | shurgalin@infolio.ru
#	Доработка: Солнцев Иван | prog@infolio.ru
################################################################################
# Если определена переменная $SHARE_DIR, то файлы сохраняются на диск, а в поле
# `data` таблицы `share_data` записывается путь к каталогу в котором файл был
# сохранён. В противном случае файл сохраняется в БД.

# Замечание к использованию UTF-8
# кодировка текста для имени файла и метода ^file.sql-string[] зависит от настройки $response:charset
# если используется кодировка отличающая от UTF-8, нужно указать в запросе что сервер должен перекодировать строки
# например: CONVERT(_cp1251'$str' USING utf8)


@CLASS
share
#/CLASS

@auto[]
	$server[$MAIN:connect_db]
	$tables[
		$.share[${MAIN:TABLES_PREFIX}share]
		$.share_data[${MAIN:TABLES_PREFIX}share_data]
	]
#/auto

#Конструктор. Создаёт объект с деревом файлов и каталогов
@tree[]
	$__obj[tree]
^server{
	$__data[^table::sql{
		SELECT
			share_id,
			pid,
			name,
			ext,
			size,
			type,
			date
		FROM `${tables.share}`
#		WHERE NOT(ISNULL(pid))
	}]
}
#/tree

#Конструктор. Создаёт объект со списком файлов и подкаталогов
@list[_pid]
	$__obj[list]
^server{
	$__data[^table::sql{
		SELECT `share_id`,`name`,`ext`,`preview`,`size`,`type`,`date` FROM `${tables.share}`
		WHERE ^if(def $_pid){`pid`='^_pid.int(0)'}{ISNULL(`pid`)}
	}]
}
#/list

#Конструктор. Создаёт объект с информацией о файле или каталоге
@stat[_id]
	$__obj[stat]
^server{
	$__data[^table::sql{
		SELECT
			`share_id`,
			`pid`,
			`name`,
			`ext`,
			`size`,
			`type`,
			`date`,
			IF(`type` = 'disk_file',(
				SELECT `data` 
				FROM `${tables.share_data}`
				WHERE `share_id`=^_id.int(0)
			), NULL) AS `path`
		FROM `${tables.share}`
		WHERE `share_id`=^_id.int(0)
	}]
}
#/stat

#Метод. Преобразует объект в таблицу
@GET_table[]
	^if($__data is table){
		$result[$__data]
	}{
		$result[]
	}
#/GET_table

#Метод. Возвращает имя конструктора которым ьыл создан объект
@GET_type[]
	^if(def $__obj){
		$result[$__obj]
	}
#/GET_type


#Статический метод. Возвращает файл в виде объекта file
@file[_id][f]
^server{
	$f[^table::sql{SELECT `name`, `type`, `date` FROM `${tables.share}` WHERE `share_id` = ^_id.int(0)}]
	^if(!def $f){
		^throw[share.not_found;share with id $_id not found]
	}
	^switch[$f.type]{
		^case[db_file]{
			$result[^file::sql{
				SELECT d.`data`, s.`name`, d.`mime` 
				FROM `${tables.share}` s JOIN `${tables.share_data}` d USING(share_id) 
				WHERE d.share_id='$_id'
			}]
		}
		^case[disk_file]{
			$result[^file::load[binary;^string:sql{SELECT `data` FROM `${tables.share_data}` WHERE `share_id`='$_id'}]]
		}
		^case[DEFAULT]{
			^throw[share.is_dir;share with id $_id is directory]
		}
	}
	
}
#/file

#Статический метод. Создаёт каталог и возвращает его идентификатор
@create-dir[_name;_pid]
^server{
	^try{
		^void:sql{
			INSERT INTO `${tables.share}`
			SET
				name=^utf8[$_name],
				pid=^if(def $_pid){'$_pid'}{NULL},
				type='dir'
			}
		$result(^int:sql{ SELECT LAST_INSERT_ID() FROM `${tables.share}` }[ $.limit(1) $.default{0} ])
	}{
		^if($exception.type eq sql.execute){
			^throw[share.exist;share with name "$_name" already exist]
		}
	}
}
#/create-dir

#Статический метод. Удаляет каталог и все его подкаталоги и файлы
@delete-dir[_id][d]
^server{
	$d[^string:sql{SELECT type FROM `${tables.share}` WHERE share_id='$_id'}]
	^if(!def $d){
		^throw[share.not_found;share with id $_id not found]
	}
	^if($d ne dir){
		^throw[share.not_found;share with id $_id is not directory]
	}
	^void:sql{DELETE FROM `${tables.share}` WHERE share_id='$_id' and share_id>0}
}
#/delete-dir

#Статический метод. Удаляет файлы (типа 'disk_file') с диска и из БД у которых нет пары в БД и на диске соответственно
@free[][l]
^if(def $MAIN:SHARE_DIR){
	^server{
		$l[^table::sql{
			SELECT d.share_id, d.data 
			FROM `${tables.share}` s JOIN `${tables.share_data}` d USING(share_id) 
			WHERE s.type='disk_file'
		}]
		^if(def $l){
			^l.menu{
				^if(!-f $l.data){
#					^throw[1;$l.data]
					^void:sql{DELETE FROM `{$tables.share}` WHERE share_id='$l.share_id'}
				}
			}
		}
		$f[^file:list[$MAIN:SHARE_DIR]]
		^if(def $f){
			^f.menu{
				^if(!^l.locate($l.data eq "$MAIN:SHARE_DIR/$f.name")){
					^file:delete[$MAIN:SHARE_DIR/$f.name]
				}
			}
		}
	}
}
#/free

#Статический метод. Довавляет файл и возвращает его идентификатор
@add[_file;_pid;_name;_type;_mime;_prv][name;d;share_id;ext]
#$_file[file]
#$_pid(int) $_name[string] $_type[disk|db] $_mime[string]				- optional
#$_prv(bool) - позволяет добавить дочерний файл к файлу
^if(!def $_file){
	^throw[share.not_file;file not specified]
}
^server{
	^if(def $_pid){
		$d[^string:sql{SELECT `type` FROM `${tables.share}` WHERE `share_id`='$_pid'}]
		^if(!def $d){
			^throw[share.not_found;share with id $_pid not found]
		}
		^if($d ne dir && !def $_prv && !$_prv){
			^throw[share.not_found;share with id $_pid is not directory]
		}
	}
	^if(def $_name){
		$name[$_name]
	}{
		$ext[^file:justext[$_file.name]]
		$ext[^ext.lower[]]
		
		$name[^file:justname[$_file.name].$ext]
	}
	^if(def ^file:justext[$name] && !def $ext){
		$ext[^file:justext[$name]]
		$ext[^ext.lower[]]
	}
	
	^try{
		^void:sql{
			INSERT INTO `${tables.share}` SET 
				pid='^if(def $_pid){$_pid}{0}',
				^if(def $ext){ext='$ext',}
				size='$_file.size',
				name=^utf8[$name],
				type='^if(!def $MAIN:SHARE_DIR || $_type eq db){db_file}{disk_file}',
				date=NOW()
		}
	}{
		^if($exception.type eq sql.execute){
			^throw[share.exist;share with name "$name" already exist]
		}
	}
	$share_id[^int:sql{SELECT LAST_INSERT_ID()}]
	^if(def $MAIN:SHARE_DIR && !($_type eq db)){
		^_file.save[binary;$MAIN:SHARE_DIR/${share_id}^if(def $ext){.${ext}}]
	}
	^void:sql{
		INSERT INTO `${tables.share_data}` SET
			share_id='$share_id',
#			ext='$ext',
			mime='$_file.content-type',
			data='^if(!def $MAIN:SHARE_DIR || $_type eq db){^_file.sql-string[]}{$MAIN:SHARE_DIR/${share_id}^if(def $ext){.${ext}}}'
	}
	$result($share_id)
}
#/add

@create_preview[_id][f;prv]
^try{
	^use_module[picture]
	$f[^file[$_id]]
	$f[^picture:resize[$f;150;150]]
	$prv[^add[$f;$_id;preview.jpg;;](true)]
	^server{
		^void:sql{
			UPDATE `${tables.share}` SET
				`preview`='$prv'
			WHERE `share_id` = '$_id'
		}
	}
}{
#	$exceprion.handled(true)
}
#/create_preview

#Статический метод. Обновляет файл или каталог
@update[_id;params][ext]
#$params[
#	$.pid(int)											- optional
#	$.name[string]										- optional
#	$.file[file]										- optional
#	$.ext[string]										- optional
#	$.mime[string]										- optional
#]
^if(def $params.file && !($params.file is file)){
	^throw[share.not_file;file not specified]
}
^server{
	^if(def $params.pid){
		$d[^string:sql{SELECT `type` FROM `${tables.share}` WHERE share_id='$params.pid'}]
		^if(!def $d){
			^throw[share.not_found;share with id $params.pid not found]
		}
		^if($d ne dir){
			^throw[share.not_found;share with id $params.pid is not directory]
		}
	}
	^if(def ^file:justext[$name]){
		$ext[^file:justext[$name]]
		$ext[^ext.lower[]]
	}
	^try{
		^void:sql{
			UPDATE `${tables.share}` SET 
				^if(def $params.pid){pid='$params.pid',}
				^if(def $params.name){
					name=^utf8[$params.name],
					^if(def $ext){ext='$ext',}
				}
				date=NOW()
			WHERE share_id='$_id'
		}
	}{
		^if($exception.type eq sql.execute){
			^throw[share.exist;share with name "$params.name" already exist]
		}
	}

	^if(def $params.file && def $MAIN:SHARE_DIR){
		^params.file.save[binary;$MAIN:SHARE_DIR/$share_id]
	}
	^if(def $params.file){
		^void:sql{
			UPDATE `${tables.share_data}` SET
#				^if(def $params.name){ext='$ext',}
				^if(def $params.file){
					mime='$params.file.content-type',
					data=^utf8[^if(def $MAIN:SHARE_DIR){$MAIN:SHARE_DIR/$_id}{^params.file.sql-string[]}]
				}
			WHERE
				share_id='$_id'
		}
	}
	$result($share_id)
}

#/update

#Статический метод. Удаляет файл
@delete[_id]
	^if(def $_id){
		^server{
			$d[^table::sql{SELECT ext,type FROM `${tables.share}` WHERE share_id='$_id'}]
			^if(!def $d.type){
				^throw[share.not_found;share with id $_id not found]
			}
			^if($d.type is dir){
				^throw[share.not_found;share with id $_id is directory]
			}
			^if($d.type eq disk_file){
				^file:delete[$MAIN:SHARE_DIR/${_id}^if(def $d.ext){.$d.ext}]
			}
			^void:sql{DELETE FROM `${tables.share}` WHERE share_id='$_id'}
		}
	}
#/delete

# преобразование текста при использовании различных кодировок
@utf8[_text]
^if($response:charset ne $request:charset){
	$result[CONVERT(_cp1251'$_text' USING utf8)]
}{
	$result['$_text']
}
#/utf8

