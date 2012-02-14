<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="calc-id" select="false()"/>
	
	<xsl:template match="*" />

	<xsl:template match="navigation">
		<navigation>
			<xsl:apply-templates select="item"/>
		</navigation>
	</xsl:template>
	
	<xsl:template match="group[not(@hide)]">
		<xsl:apply-templates select="item[not(@hide)]"/>
	</xsl:template>

	<xsl:template match="item">
		<item>
			<xsl:if test="$calc-id">
				<xsl:attribute name="id">
					<xsl:call-template name="id"/>
					<xsl:value-of select="@key"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="item[not(@hide)]"/>
		</item>
	</xsl:template>
	
	<xsl:template name="id">
		<xsl:for-each select="parent::item">
			<xsl:call-template name="id"/>
			<xsl:value-of select="@key"/>
			<xsl:text>.</xsl:text>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>