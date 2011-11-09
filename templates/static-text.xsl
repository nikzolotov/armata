<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="common/text.xsl"/>
	<xsl:import href="gallery.xsl"/>
	
	<xsl:template name="content-blocks">
		<xsl:call-template name="general-content-blocks"/>
	</xsl:template>
	
	<xsl:template name="general-content-blocks">
		<div class="wrapper-fix">
			<div class="wrapper">
				<div class="main-content">
					<xsl:call-template name="content"/>
				</div>
			</div>
			<div id="extra">
				<xsl:call-template name="extra"/>
				<xsl:if test="/page/navigation//item[@hit and @context-gallery]">
					<xsl:apply-templates select="gallery" mode="gallery">
						<xsl:with-param name="in-context" select="true()"/>
					</xsl:apply-templates>
				</xsl:if>
			</div>
		</div>
		<xsl:if test="/page/navigation//item[@hit and not(@context-gallery)]">
			<xsl:apply-templates select="gallery" mode="gallery"/>
		</xsl:if>
		<xsl:apply-templates select="/page/static-text//div[@class='tail-press']" mode="after-gallery"/>
	</xsl:template>
	
	<xsl:template name="content">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="static-text">
		<xsl:choose>
			<xsl:when test="not(text/*)">
				<p>
					<xsl:value-of select="text"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="text" mode="text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="div[@class='tail-press']" mode="text"/>
	
	<xsl:template match="div[@class='tail-press']" mode="after-gallery">
		<div class="main-content">
			<hr class="short"/>
			<xsl:copy-of select="*"/>
		</div>
	</xsl:template>

</xsl:stylesheet>