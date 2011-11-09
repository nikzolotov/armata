<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="lowCase">абвгдеёжзийклмнопрстуфхцчшщыъьэюяabcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upCase">АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЪЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

  <xsl:template name="upper">
          <xsl:param name="str"/>
          <xsl:value-of select="translate($str, $lowCase, $upCase)"/>
     </xsl:template>

     <xsl:template name="lower">
          <xsl:param name="str"/>
          <xsl:value-of select="translate($str, $upCase, $lowCase)"/>
     </xsl:template>
	
	<xsl:template name="nbsp-by-default">
		<xsl:param name="string"/>
		<xsl:choose>
			<xsl:when test="normalize-space($string) != ''">
				<xsl:value-of select="$string"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#160;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="include-script">
		<xsl:param name="name"/>	<!-- script file name (without extension) -->
		<xsl:param name="type" select="'text/javascript'"/>	<!-- default script type -->
		<xsl:param name="base_url">
			<xsl:value-of select="/page/navigation/@base"/>
			<xsl:text>/js/</xsl:text>
		</xsl:param>
		<xsl:param name="query"/>
		<script>
			<xsl:attribute name="type">
				<xsl:value-of select="$type"/>
			</xsl:attribute>
			<xsl:attribute name="src">
				<xsl:value-of select="/page/navigation/@base"/>
				<xsl:value-of select="$base_url"/>
				<xsl:value-of select="$name"/>
				<xsl:choose>
					<xsl:when test="$type = 'text/javascript'">.js</xsl:when>
				</xsl:choose>
				<xsl:if test="$query">
					<xsl:value-of select="$query"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:comment/>
		</script>
	</xsl:template>
	
	<xsl:template name="include-css">
		<xsl:param name="name"/>
		<xsl:param name="media" select="'screen'"/>		<!-- default media type -->
		<xsl:param name="type" select="'text/css'"/>	<!-- default css type -->
		<xsl:param name="base_url">
			<xsl:value-of select="/page/navigation/@base"/>
			<xsl:text>/css/</xsl:text>
		</xsl:param>
		<link rel="stylesheet">
			<xsl:attribute name="type">
				<xsl:value-of select="$type"/>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="$base_url"/>
				<xsl:value-of select="$name"/>
				<xsl:choose>
					<xsl:when test="$type = 'text/css'">.css</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:if test="not($media = '')">
				<xsl:attribute name="media">
					<xsl:value-of select="$media"/>
				</xsl:attribute>
			</xsl:if>
		</link>
	</xsl:template>

	<xsl:template name="date">
		<xsl:param name="with-time">true</xsl:param>
		<xsl:value-of select="substring(., 9, 2)" />
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(., 6, 2)" />
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(., 1, 4)" />
		<xsl:if test="$with-time='true' and string-length(substring-after(., ' ')) &gt; 0">
			<xsl:text>, </xsl:text>
			<xsl:value-of select="substring(., 12, 5)" />
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="_month-name">
		<xsl:param name="num" />
		<xsl:param name="rod" />
		<xsl:choose>
			<xsl:when test="number($num)='1' and not($rod)">Январь</xsl:when>
			<xsl:when test="number($num)='1' and $rod">Января</xsl:when>
			<xsl:when test="number($num)='2' and not($rod)">Февраль</xsl:when>
			<xsl:when test="number($num)='2' and $rod">Февраля</xsl:when>
			<xsl:when test="number($num)='3' and not($rod)">Март</xsl:when>
			<xsl:when test="number($num)='3' and $rod">Марта</xsl:when>
			<xsl:when test="number($num)='4' and not($rod)">Апрель</xsl:when>
			<xsl:when test="number($num)='4' and $rod">Апреля</xsl:when>
			<xsl:when test="number($num)='5' and not($rod)">Май</xsl:when>
			<xsl:when test="number($num)='5' and $rod">Мая</xsl:when>
			<xsl:when test="number($num)='6' and not($rod)">Июнь</xsl:when>
			<xsl:when test="number($num)='6' and $rod">Июня</xsl:when>
			<xsl:when test="number($num)='7' and not($rod)">Июль</xsl:when>
			<xsl:when test="number($num)='7' and $rod">Июля</xsl:when>
			<xsl:when test="number($num)='8' and not($rod)">Август</xsl:when>
			<xsl:when test="number($num)='8' and $rod">Августа</xsl:when>
			<xsl:when test="number($num)='9' and not($rod)">Сентябрь</xsl:when>
			<xsl:when test="number($num)='9' and $rod">Сентября</xsl:when>
			<xsl:when test="number($num)='10' and not($rod)">Октябрь</xsl:when>
			<xsl:when test="number($num)='10' and $rod">Октября</xsl:when>
			<xsl:when test="number($num)='11' and not($rod)">Ноябрь</xsl:when>
			<xsl:when test="number($num)='11' and $rod">Ноября</xsl:when>
			<xsl:when test="number($num)='12' and not($rod)">Декабрь</xsl:when>
			<xsl:when test="number($num)='12' and $rod">Декабря</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="text()" mode="month-name" name="month-name">
		<xsl:param name="num">
			<xsl:value-of select="." />
		</xsl:param>
		<xsl:param name="rod" />
		<xsl:param name="text-transform" />
		<xsl:variable name="month">
			<xsl:call-template name="_month-name">
				<xsl:with-param name="num" select="$num" />
				<xsl:with-param name="rod" select="$rod" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$text-transform = 'upper'">
				<xsl:call-template name="upper">
					<xsl:with-param name="str" select="$month" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$text-transform = 'lower'">
				<xsl:call-template name="lower">
					<xsl:with-param name="str" select="$month" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$month" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*|@*" name="month-number" mode="month-number">
		<xsl:param name="month-name" select="." />
		<xsl:choose>
			<xsl:when test="$month-name = 'января'">1</xsl:when>
			<xsl:when test="$month-name = 'февраля'">2</xsl:when>
			<xsl:when test="$month-name = 'марта'">3</xsl:when>
			<xsl:when test="$month-name = 'апреля'">4</xsl:when>
			<xsl:when test="$month-name = 'мая'">5</xsl:when>
			<xsl:when test="$month-name = 'июня'">6</xsl:when>
			<xsl:when test="$month-name = 'июля'">7</xsl:when>
			<xsl:when test="$month-name = 'августа'">8</xsl:when>
			<xsl:when test="$month-name = 'сентября'">9</xsl:when>
			<xsl:when test="$month-name = 'октября'">10</xsl:when>
			<xsl:when test="$month-name = 'ноября'">11</xsl:when>
			<xsl:when test="$month-name = 'декабря'">12</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="format-date">
		<xsl:param name="date" />
		<xsl:param name="with-year" select="1"/>
		<xsl:param name="with-current-year" select="1"/>
		
		<xsl:value-of select="number(substring($date,9,2))" />
		<xsl:text> </xsl:text>
		<xsl:call-template name="month-name">
			<xsl:with-param name="num" select="substring($date,6,2)" />
			<xsl:with-param name="rod" select="'true'" />
			<xsl:with-param name="text-transform" select="'lower'" />
		</xsl:call-template>
		<xsl:if test="$with-year = 1">
			<xsl:choose>
				<xsl:when test="$with-current-year = 1">
					<xsl:text> </xsl:text>
					<xsl:value-of select="substring($date,1,4)"/>
					<xsl:text> года</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="substring($date,1,4) != substring($DateNow,1,4)">
						<xsl:text> </xsl:text>
						<xsl:value-of select="substring($date,1,4)"/>
						<xsl:text> года</xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="date-range">
		<xsl:param name="start" select="'0000-00-00'"/>
		<xsl:param name="finish" select="'0000-00-00'"/>
		<xsl:param name="with-current-year" select="1"/>
		<xsl:param name="short-separator" select="'&#8212;'"/>
		<xsl:param name="long-separator" select="' &#8212; '"/>
		
		<xsl:choose>
			<xsl:when test="substring($start,1,4) = substring($finish,1,4)">
				<xsl:choose>
					<xsl:when test="substring($start,6,2) = substring($finish,6,2)">
						<xsl:value-of select="number(substring($start,9,2))"/>
						<xsl:value-of select="$short-separator"/>
						<xsl:value-of select="number(substring($finish,9,2))"/>
						<xsl:text> </xsl:text>
						<xsl:call-template name="month-name">
							<xsl:with-param name="num" select="substring($start,6,2)" />
							<xsl:with-param name="rod" select="'true'" />
							<xsl:with-param name="text-transform" select="'lower'" />
						</xsl:call-template>
						<xsl:choose>
							<xsl:when test="$with-current-year = 1">
								<xsl:text> </xsl:text>
								<xsl:value-of select="substring($start,1,4)"/>
								<xsl:text> года</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="substring($start,1,4) != substring($DateNow,1,4)">
									<xsl:text> </xsl:text>
									<xsl:value-of select="substring($start,1,4)"/>
									<xsl:text> года</xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="format-date">
							<xsl:with-param name="date" select="$start"/>
							<xsl:with-param name="with-year" select="0"/>
						</xsl:call-template>
						<xsl:value-of select="$long-separator"/>
						<xsl:call-template name="format-date">
							<xsl:with-param name="date" select="$finish"/>
							<xsl:with-param name="with-year" select="0"/>
						</xsl:call-template>
						<xsl:choose>
							<xsl:when test="$with-current-year = 1">
								<xsl:text> </xsl:text>
								<xsl:value-of select="substring($start,1,4)"/>
								<xsl:text> года</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="substring($start,1,4) != substring($DateNow,1,4)">
									<xsl:text> </xsl:text>
									<xsl:value-of select="substring($start,1,4)"/>
									<xsl:text> года</xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="format-date">
					<xsl:with-param name="date" select="$start"/>
				</xsl:call-template>
				<xsl:value-of select="$long-separator"/>
				<xsl:call-template name="format-date">
					<xsl:with-param name="date" select="$finish"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>