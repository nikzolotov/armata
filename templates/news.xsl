<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="common/text.xsl"/>
	
	<xsl:param name="m"/>
	<xsl:param name="y"/>
	
	<xsl:template name="title-text">
		<xsl:text>Новости АРМАТА: </xsl:text>
		<xsl:choose>
			<xsl:when test="/page/news">
				<xsl:for-each select="/page/news/article">
					<xsl:if test="position() &lt; 4">
						<xsl:value-of select="title/text()"/>
						<xsl:if test="position() != last() and position() != 3">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="/page/article">
				<xsl:value-of select="/page/article/title/text()"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="extra">
		<xsl:if test="next/article or previous/article">
			<ul class="nearest-news">
				<xsl:apply-templates select="next/article"/>
				<xsl:apply-templates select="previous/article"/>
			</ul>
		</xsl:if>
		<h2 class="directing">Архив новостей</h2>
		<xsl:apply-templates select="calendar" mode="list"/>
	</xsl:template>
	
	<xsl:template match="news">
		<h1>
			<xsl:choose>
				<xsl:when test="$m and $y">
					<xsl:text>Новости за </xsl:text>
					<xsl:call-template name="month-name">
						<xsl:with-param name="num" select="$m"/>
						<xsl:with-param name="text-transform" select="'lower'"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$y"/>
					<xsl:text> года</xsl:text>
				</xsl:when>
				<xsl:when test="y">
					<xsl:text>Новости за </xsl:text>
					<xsl:value-of select="$y"/>
					<xsl:text> год</xsl:text>
				</xsl:when>
				<xsl:otherwise>Новости и события</xsl:otherwise>
			</xsl:choose>
		</h1>
		<dl class="news">
			<xsl:apply-templates select="article" mode="list"/>
		</dl>
	</xsl:template>
	
	<xsl:template match="calendar" mode="list">
		<ul class="news">
			<xsl:for-each select="year">
				<xsl:sort select="@number" order="descending"/>
				<li>
					<xsl:choose>
						<xsl:when test="(@number = $y) and ($m = '')">
							<strong>
								<xsl:value-of select="@number"/>
							</strong>
						</xsl:when>
						<xsl:otherwise>
							<a href="/about/news/{@number}/">
								<xsl:value-of select="@number"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
					<ul>
						<xsl:apply-templates select="month">
							<xsl:sort select="@number" order="descending"/>
						</xsl:apply-templates>
					</ul>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
	<xsl:template match="month">
		<li>
			<xsl:choose>
				<xsl:when test="(parent::year/@number = $y) and (@number = $m)">
					<xsl:choose>
						<xsl:when test="/page/article">
							<a href="/about/news/{parent::year/@number}/{@number}/">
								<strong>
									<xsl:call-template name="month-name">
										<xsl:with-param name="num" select="@number"/>
									</xsl:call-template>
								</strong>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<strong>
								<xsl:call-template name="month-name">
									<xsl:with-param name="num" select="@number"/>
								</xsl:call-template>
							</strong>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<a href="/about/news/{parent::year/@number}/{@number}/">
						<xsl:call-template name="month-name">
							<xsl:with-param name="num" select="@number"/>
						</xsl:call-template>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>

	<xsl:template match="article">
		<h1>
			<xsl:value-of select="title"/>
		</h1>
		<xsl:choose>
			<xsl:when test="not(body/*)">
				<p>
					<xsl:apply-templates select="body/text()" mode="text"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="body/*|body/text()" mode="text"/>
			</xsl:otherwise>
		</xsl:choose>
		<p class="date">
			<xsl:call-template name="format-date">
				<xsl:with-param name="date" select="date"/>
			</xsl:call-template>
		</p>
	</xsl:template>
	
	<xsl:template match="next/article">
		<li class="next">
			<div>
				<xsl:call-template name="nearest-news-text"/>
			</div>
		</li>
	</xsl:template>
	
	<xsl:template match="previous/article">
		<li class="prev">
			<xsl:if test="/page/next/article">
				<xsl:attribute name="class">prev separated</xsl:attribute>
			</xsl:if>
			<div>
				<xsl:call-template name="nearest-news-text">
					<xsl:with-param name="is-next" select="false()"/>
				</xsl:call-template>
			</div>
		</li>
	</xsl:template>
	
	<xsl:template name="nearest-news-text">
		<xsl:param name="is-next" select="true()"/>
		<h3>
			<xsl:choose>
				<xsl:when test="$is-next">Следующая:</xsl:when>
				<xsl:otherwise>Предыдущая:</xsl:otherwise>
			</xsl:choose>
		</h3>
		<p>
			<a href="/about/news/{@id}.html">
				<xsl:value-of select="title"/>
			</a>
		</p>
	</xsl:template>
	
</xsl:stylesheet>