<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="map">
		<h1>Карта сайта</h1>
			<ul>
				<xsl:apply-templates select="/page/navigation/item" mode="menu">
					<xsl:with-param name="depth" select="3"/>
				</xsl:apply-templates>
			</ul>
	</xsl:template>

</xsl:stylesheet>