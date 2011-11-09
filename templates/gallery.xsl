<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="*" mode="gallery" />

	<xsl:template match="gallery[photo]" mode="gallery">
		<xsl:param name="top" select="0"/>
		<xsl:param name="in-context" select="false()"/>
		<div class="gallery">
			<xsl:if test="$top = 0 and not($in-context)">
				<hr class="short"/>
			</xsl:if>
			<ul class="clearfix">
				<xsl:apply-templates select="photo" mode="gallery">
					<xsl:with-param name="in-context" select="$in-context"/>
				</xsl:apply-templates>
			</ul>
			<xsl:if test="$top = 1 and not($in-context)">
				<hr class="short"/>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="photo" mode="gallery">
		<xsl:param name="in-context" select="false()"/>
		<li>
			<a class="thickbox" href="/share/{photo}.jpg" rel="gallery" title="{desc}">
				<img src="/share/{preview}.jpg" alt="{desc}"/>
				<br/>
				<xsl:if test="desc/text()">
					<em>
						<xsl:value-of select="desc"/>
					</em>
				</xsl:if>
			</a>
			<xsl:if test="not($in-context)">
				<span>
					<xsl:comment/>
				</span>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>