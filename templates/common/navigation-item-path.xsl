<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="HostName" />
	<xsl:param name="ServerName" />

	<xsl:template name="navigation-item-path" match="item" mode="navigation-item-path">
		<xsl:param name="exclude-base" />
		<xsl:choose>
			<xsl:when test="@href">
				<xsl:value-of select="@href" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not($exclude-base)">
					<xsl:value-of select="ancestor-or-self::navigation/@base" />
				</xsl:if>
				<xsl:for-each select="ancestor-or-self::item[@key]">
					<xsl:text>/</xsl:text>
					<xsl:value-of select="@key" />
				</xsl:for-each>
				<xsl:choose>
					<xsl:when test="item or @dir='true' or not(@key)">/</xsl:when>
					<xsl:otherwise>.html</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <xsl:template name="navigation-item-link" match="item" mode="navigation-item-link">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="navigation-item-path" />
      </xsl:attribute>
      <xsl:value-of select="@name" />
    </a>
  </xsl:template>

</xsl:stylesheet>