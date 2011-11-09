#cp1251#########################################################################
#	Класс templates v1.5 23/03/2006
#	Автор: Шургалин Евгений | shurgalin@infolio.ru
################################################################################
#	Библиотека формирования последовательности используемых XSL-шаблонов
################################################################################
#	^templates::create[BASE_PATH]	- Создаёт объект последовательности.
#	^templates::create[				- Создаёт объект последовательности c одним
#		BASE_PATH					     файлом в последовательности.
#	;
#		XSL_FILE_NAME
#	]
#	^OBJ.empty[]					- Возвращает TRUE, если последовательность
#										пуста, в противном случае - FALSE.
#	^OBJ.clear[]					- Очищает последовательность файлов.
#	^OBJ.add[XSL_FILE_NAME]			- Добаляет файл в последовательность.
#	^OBJ.xdoc[]						- Возвращает объект класса xdoc, в котором
#										находится инструкции по загрузке файлов
#										с шаблонами.
################################################################################
#	BASE_PATH			- Путь относительно которого будут искаться добавляемые
#							в последовательность файлы шаблонов (string)
#	XSL_FILE_NAME		- Имя добовляемого файла шаблонов (string)
################################################################################

@CLASS
templates
#/CLASS

@create[_base_path;_file]
	$base_path[$_base_path]
	$files[^table::create{file}]
	^if(def $_file){ ^add[$_file] }
#/create

@empty[]
	$result(^if(def $files){0}{1}) 
#/empty

@clear[]
	$files[^table::create{file}]
#/clear

@add[_file][_node]
	^files.append{$_file}
	$result[]
#/add

@xdoc[][xslt]
	^if(def $base_path){
		$result[^xdoc::create[$base_path]{<?xml version="1.0" encoding="$request:charset"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">^if($files){^files.menu{<xsl:import href="$files.file"/>}}</xsl:stylesheet>}]
	}{
		$result[^xdoc::create{<?xml version="1.0" encoding="$request:charset"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">^if($files){^files.menu{<xsl:import href="$files.file"/>}}</xsl:stylesheet>}]
	}
#/xdoc
