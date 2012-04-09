<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="p" mode="text">
		<p>
			<xsl:copy-of select="@id | @class | @align | @style"/>
			<xsl:apply-templates mode="text"/>
		</p>
	</xsl:template>

	<xsl:template match="i|b|u|em|strong|del|ins|sup|sub|li|dt|dd|div|blockquote" mode="text">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@id | @class"/>
			<xsl:apply-templates mode="text"/>
			<xsl:if test="not(text() or node())">
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="a" mode="text">
		<a>
			<xsl:copy-of select="@id | @class | @href | @name | @target"/>
			<xsl:apply-templates mode="text"/>
		</a>
	</xsl:template>
	
	<xsl:template match="br" mode="text">
		<br/>
	</xsl:template>
		
	<xsl:template match="font" mode="text">
		<font>
			<xsl:copy-of select="@size | @color"/>
			<xsl:apply-templates mode="text"/>
		</font>
	</xsl:template>
	
	<xsl:template match="h1|h2|h3|h4|h5" mode="text">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@id | @class"/>
			<xsl:apply-templates mode="text"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="span" mode="text">
		<span>
			<xsl:copy-of select="@class"/>
			<xsl:if test="@style">
				<xsl:attribute name="style">
					<xsl:apply-templates select="@style" mode="style"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="text"/>
		</span>
	</xsl:template>

	<xsl:template match="@style" mode="style">
		<xsl:call-template name="style">
			<xsl:with-param name="text" select="string(.)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="style">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="substring-before($text,'-')='background'">
				<xsl:value-of select="substring-before($text,';')"/><xsl:text>;</xsl:text>
			</xsl:when>
<!--			<xsl:when test="substring-before($text,':')='background'">
				<xsl:value-of select="substring-before($text,';')"/><xsl:text>;</xsl:text>
			</xsl:when> -->
		</xsl:choose>
		<xsl:if test="text()">
			<xsl:call-template name="style">
				<xsl:with-param name="text" select="substring-after($text,';')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ol|ul|dl" mode="text">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@id | @class"/>
			<xsl:apply-templates select="li|dt|dd" mode="text"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="img" mode="text">
		<img title="{@alt}">
			<xsl:copy-of select="@src | @alt | @border | @width | @height | @style | @class"/>
			<xsl:if test="@align='right' or @align='left'">
				<xsl:attribute name="class">
					<xsl:text>pic-</xsl:text><xsl:value-of select="@align"/>
				</xsl:attribute>
			</xsl:if>
		</img>
	</xsl:template>
	
	<xsl:template match="text()" mode="text">
		<!--xsl:text>&#171;</xsl:text-->
		<xsl:value-of select="."/>
		<!--xsl:text>&#187;</xsl:text-->
	</xsl:template>
	
	<xsl:template match="table" mode="text">
		<table>
			<xsl:copy-of select="@id|@class"/>
			<xsl:apply-templates select="col | colgroup" mode="text"/>
			<!--
			<xsl:if test="@border">
				<xsl:attribute name="class">border</xsl:attribute>
			</xsl:if>
			-->
			<xsl:apply-templates select="tr|tbody" mode="text"/>
		</table>
	</xsl:template>
	
	<xsl:template match="col" mode="text">
		<col>
			<xsl:copy-of select="@width|@span"/>
		</col>
	</xsl:template>
	
	<xsl:template match="colgroup" mode="text">
		<colgroup>
			<xsl:apply-templates select="col" mode="text"/>
		</colgroup>
	</xsl:template>

	<xsl:template match="tbody" mode="text">
		<tbody>
			<xsl:copy-of select="@id|@class"/>
			<xsl:apply-templates select="tr" mode="text"/>
		</tbody>
	</xsl:template>

	<xsl:template match="tr" mode="text">
		<tr>
			<xsl:apply-templates select="td|th" mode="text"/>
		</tr>
	</xsl:template>

	<xsl:template match="td|th" mode="text">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@colspan | @rowspan | @class"/>
			<xsl:apply-templates mode="text"/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>