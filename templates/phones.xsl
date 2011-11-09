<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
	<xsl:import href="gallery.xsl"/>
	
	<xsl:template name="title-text">
		<xsl:value-of select="$txtres/title"/>
		<xsl:choose>
			<xsl:when test="/page/project/seo-title">
				<xsl:text> - </xsl:text>
				<xsl:value-of select="/page/project/seo-title"/>
			</xsl:when>
			<xsl:when test="/page/project/title">
				<xsl:text> - </xsl:text>
				<xsl:value-of select="/page/project/title"/>
			</xsl:when>
			<xsl:when test="string-length(/page/static-text/title/text()) != 0">
				<xsl:text> — </xsl:text>
				<xsl:value-of select="/page/static-text/title/text()"/>
			</xsl:when>
			<xsl:when test="string-length(/page/navigation//item[@hit]/@name) != 0">
				<xsl:text> — </xsl:text>
				<xsl:value-of select="/page/navigation//item[@hit]/@name"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="content-blocks">
		<div class="wrapper-fix">
			<div class="wrapper">
				<div class="main-content">
					<xsl:call-template name="content"/>
				</div>
			</div>
			<div id="extra">
				<xsl:call-template name="extra"/>
			</div>
		</div>
		<xsl:apply-templates select="gallery" mode="gallery"/>
	</xsl:template>
	
	<xsl:template name="content">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template name="navigation">
		<ul class="sub-menu catalog">
			<xsl:apply-templates select="navigation/item[@in]/item" mode="sub"/>
		</ul>
		<xsl:call-template name="collaboration-menu"/>
	</xsl:template>
	
	<xsl:template match="item" mode="sub">
		<xsl:if test="/page/projects/project[@type = current()/@type and @body_length &gt; 1]">
			<li>
				<xsl:if test="@in">
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when test="@type = /page/project/@type">active-parent</xsl:when>
							<xsl:otherwise>active</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="@hit">
						<strong>
							<xsl:value-of select="@name"/>
						</strong>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="@in and @type = /page/project/@type">
								<em>
									<xsl:call-template name="navigation-item-link"/>
								</em>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="navigation-item-link"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<ul>
					<xsl:for-each select="/page/projects/project[@type = current()/@type and @body_length &gt; 1]">
						<li>
							<xsl:if test="@id = /page/project/@id">
								<xsl:attribute name="class">active</xsl:attribute>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="@id = /page/project/@id">
									<strong>
										<xsl:value-of select="title"/>
									</strong>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="." mode="link"/>
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</xsl:for-each>
				</ul>
			</li>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="project" mode="link">
		<xsl:param name="full" select="false()"/>
		<a>
			<xsl:attribute name="href">
				<xsl:apply-templates select="/page/navigation/item[@in]" mode="navigation-item-path"/>
				<xsl:value-of select="/page/navigation/item[@in]/item[@type = current()/@type]/@key"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="@id"/>
				<xsl:text>.html</xsl:text>
			</xsl:attribute>
			<xsl:value-of select="title"/>
			<xsl:if test="$full">
				<xsl:if test="title and address">
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:value-of select="address"/>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template match="static-text">
		<xsl:apply-templates select="text" mode="text"/>
		<xsl:apply-templates select="/page/projects" mode="list"/>
	</xsl:template>
	
	<xsl:template match="projects" mode="list">
		<xsl:for-each select="/page/navigation/item[@in]/item">
			<xsl:if test="/page/projects/project[@type = current()/@type]">
				<h3>
					<xsl:value-of select="@name"/>
				</h3>
				<ul>
					<xsl:apply-templates select="/page/projects/project[@type = current()/@type]" mode="list"/>
				</ul>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="project" mode="list">
		<li>
			<xsl:choose>
				<xsl:when test="@body_length &gt; 1">
					<xsl:apply-templates select="." mode="link">
						<xsl:with-param name="full" select="true()"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="title"/>
					<xsl:if test="title and address">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:value-of select="address"/>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>
	
	<xsl:template match="project">
		<xsl:if test="title">
			<h2>
				<xsl:value-of select="title"/>
			</h2>
		</xsl:if>
		<xsl:if test="address">
			<p>
				<xsl:text>Адрес: </xsl:text>
				<xsl:value-of select="address"/>
			</p>
		</xsl:if>
		<xsl:if test="end">
			<p>
				<xsl:text>Дата окончания: </xsl:text>
				<xsl:value-of select="end"/>
			</p>
		</xsl:if>
		<xsl:apply-templates select="body" mode="text"/>
		<xsl:if test="normalize-space(see-also)">
			<p>
				<strong>Смотрите также:</strong>
			</p>
			<xsl:apply-templates select="see-also" mode="text"/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>