#utf8###########################################################################
#	Конфигурационный файл ядра сайта v1.3
#	Автор: Шургалин Евгений | shurgalin@infolio.ru
################################################################################

@auto[]
	$CHARSET[$request:charset]
	$DEBUG(true)									#use debug version to see problem details

#	$TABLES_PREFIX[]								#Префикс имён таблиц в БД
	$ADMIN_DIR[/admin]								#Каталог АРМ администратора
	$RESOURCES_DIR[/../resources]					#Каталог с ресурсами
	$TEMPLATES_DIR[/../templates]					#Каталог с шаблонами
	$VAR_DIR[/../var]								#Каталог с временными файлами
	$TIDY_DIR[${RESOURCES_DIR}/tidy]
	$NCONVERT_DIR[${RESOURCES_DIR}/xnview]
	$SHARE_DIR[/share]								#Каталог где размещаются файлы модуля share
	
#	Кэш
	$CACHE_DIR[/../cache]				# Каталог кэша
	$CACHE_TTL(86400)					# Время жизни кэша по умолчанию 1 день
	$USE_CACHE(1)						# Включение кэша
	
#	$404_ERROR_DOCUMENT[/404.html]

	$MOD_AUTH_USE_GROUPS(false)
	
#	Настройки MySQL.
	$SQL_SETTINGS[
		$.USE_INSERT_UPDATE(1)						#MySQL 4.1
		$.USE_FOREIGN_KEYS(1)						#MySQL 4.1
	]

#	Файл навигации
	^if(in "$ADMIN_DIR"){
		$NAVIGATION_FILE[$RESOURCES_DIR/admin-navigation.xml]	#АРМ администратора
	}{
		$NAVIGATION_FILE[$RESOURCES_DIR/navigation.xml]			#Сайта
	}

#	Хеш параметров XSLT-трансформации
	$XSL-Params[^hash::create[]]

#	Параметры вывода конечного документа после XSL-трансформации.
	$XSL-Output[
		$.method[xml]
		$.indent[yes]
		$.omit-xml-declaration[yes]
	]
#/auto

#Метод соединения с БД
@connect_db[code]
	^connect[$SQL.connect-string]{$code}
#/connect_db

@create_xnode[document;xml_string;encoding][tmp]
	$tmp[^xdoc::create{<?xml version="1.0" encoding="^if(def $encoding){$encoding}{$CHARSET}"?>$xml_string}]
	$result[^document.importNode[$tmp.documentElement](1)]
#/create_xnode

#Раскомментируйте этот метод, если нужно произвести обработку XML-дерева документа
#до выполнения трансформации и выдачи результата пользователю.
#@site_postprocess[result]
#	Код обработки XML-дерева.
#/site_postprocess
