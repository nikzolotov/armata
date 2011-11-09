<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="library_only" />

	<xsl:template match="pages" name="pages" mode="pages">
		<xsl:param name="search" />
		<xsl:if test="@last &gt; 1">
			<p class="pages">
				<strong>Страницы: </strong>
				<xsl:if test="@page &lt; @last">
					<a class="prev">
						<xsl:attribute name="href">
							<xsl:text>?</xsl:text>
								<xsl:if test="$search">
								<xsl:if test="$search/@year">year=<xsl:value-of select="$search/@year" />&amp;</xsl:if>
								<xsl:if test="$search/@publisher">publisher_id=<xsl:value-of select="$search/@publisher" />&amp;</xsl:if>
								<xsl:if test="$search/@group">group_id=<xsl:value-of select="$search/@group" />&amp;</xsl:if>
								<xsl:if test="$search/q-author">author=<xsl:value-of select="$search/q-author" />&amp;</xsl:if>
								</xsl:if>
								<xsl:if test="@q-query">query=<xsl:value-of select="@q-query" />&amp;</xsl:if>
								<xsl:if test="$library_only">where=library&amp;</xsl:if>
							<xsl:if test="@page &lt; @last - 1">
								<xsl:text>&amp;page=</xsl:text>
								<xsl:value-of select="@page + 1" />
							</xsl:if>
						</xsl:attribute>
						<xsl:text>&#171;</xsl:text>
					</a>
				</xsl:if>
				<xsl:call-template name="pages-loop">
					<xsl:with-param name="search" select="$search" />
				</xsl:call-template>
				<xsl:if test="@page &gt; 1">
					<a class="next">
						<xsl:attribute name="href">
							<xsl:text>?</xsl:text>
								<xsl:if test="$search">
								<xsl:if test="$search/@year">year=<xsl:value-of select="$search/@year" />&amp;</xsl:if>
								<xsl:if test="$search/@publisher">publisher_id=<xsl:value-of select="$search/@publisher" />&amp;</xsl:if>
								<xsl:if test="$search/@group">group_id=<xsl:value-of select="$search/@group" />&amp;</xsl:if>
								<xsl:if test="$search/q-author">author=<xsl:value-of select="$search/q-author" />&amp;</xsl:if>
								</xsl:if>
								<xsl:if test="@q-query">query=<xsl:value-of select="@q-query" />&amp;</xsl:if>
								<xsl:if test="$library_only">where=library&amp;</xsl:if>
							<xsl:text>&amp;page=</xsl:text>
							<xsl:value-of select="@page - 1" />
						</xsl:attribute>
						<xsl:text>&#187;</xsl:text>
					</a>
				</xsl:if>
			</p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="pages-loop">
		<xsl:param name="search" />
		<xsl:param name="cur">1</xsl:param>
		<xsl:variable name="p" select="@last - @page + 1" />
		<xsl:variable name="dist">
			<xsl:choose>
				<xsl:when test="$p &lt; $cur">
					<xsl:value-of select="$cur - $p" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$p - $cur" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$cur = 1 or $cur=@last or $dist &lt;=3 or ($p &lt; 3 and $cur &lt;= 5) or ($p &gt; @last - 2 and $cur &gt;= @last - 4)">
				<a>
					<xsl:choose>
						<xsl:when test="@last - $cur + 1 = @page">
							<xsl:attribute name="class">active</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="href">
								<xsl:text>?</xsl:text>
								<xsl:if test="$search">
								<xsl:if test="$search/@year">year=<xsl:value-of select="$search/@year" />&amp;</xsl:if>
								<xsl:if test="$search/@publisher">publisher_id=<xsl:value-of select="$search/@publisher" />&amp;</xsl:if>
								<xsl:if test="$search/@group">group_id=<xsl:value-of select="$search/@group" />&amp;</xsl:if>
								<xsl:if test="$search/q-author">author=<xsl:value-of select="$search/q-author" />&amp;</xsl:if>
								</xsl:if>
								<xsl:if test="@q-query">query=<xsl:value-of select="@q-query" />&amp;</xsl:if>
								<xsl:if test="$library_only">where=library&amp;</xsl:if>
								<xsl:if test="$cur &gt; 1">
									<xsl:text>page=</xsl:text>
									<xsl:value-of select="@last - $cur + 1" />
								</xsl:if>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="$cur" />
				</a>
			</xsl:when>
			<xsl:when test="(($p = 1 or $p = @last) and $dist = 5) or $dist &lt;= 4">&#160;&#133;&#160;</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
		<xsl:if test="$cur &lt; @last">
			<xsl:call-template name="pages-loop">
				<xsl:with-param name="cur" select="$cur + 1" />
				<xsl:with-param name="search" select="$search" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	
</xsl:stylesheet>