<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:variable name="this-context-id" select="/page/context-form/context/id/text()"/>

	<xsl:template match="context">
		<tr class="content">
			<td colspan="2" valign="top" style="padding: 20px;">
				<p>
					<a href="?action=edit&amp;id={id/text()}">Редактировать</a>
				</p>
			</td>
			<td colspan="8" valign="top" style="padding: 20px;">
				<h1>Контекстная информация</h1>
				<xsl:choose>
					<xsl:when test="/page/context-copy">
						<p style="padding: 10px 15px; background: #EEE; color: #999">Это копия <a href="?id={/page/context-copy/context/id/text()}">другого раздела</a></p>
						<xsl:apply-templates select="/page/context-copy/context/text" mode="text"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="text" mode="text"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="context-form">
		<tr class="content">
			<td colspan="2" valign="top" style="padding: 20px;">
				<p>
					<a href="?id={context/id/text()}">Назад</a>
				</p>
			</td>
			<td colspan="8" valign="top" style="padding: 20px;">
				<form action="?action=update&amp;id={context/id/text()}" method="post">
					<h1>Контекстная информация</h1>
					<p>
						<label>Текст</label>
						<br/>
						<textarea class="wide" rows="20" name="text">
							<xsl:value-of select="context/text"/>
							<xsl:comment/>
						</textarea>
					</p>
					<p>
						<label>Копия другого раздела</label>
						<br/>
						<select name="copy_page_id">
							<option value=""><xsl:text><![CDATA[]]></xsl:text></option>
							<xsl:call-template name="context-select"/>
						</select>
					</p>
					<p>
						<input type="hidden" name="published" value="1"/>
						<input type="submit" value="Обновить"/>
					</p>
				</form>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="context-select">
		<xsl:apply-templates select="/page/navigation/item[@module = 'text']/item" mode="select"/>
 	</xsl:template>
	
	<xsl:template match="item" mode="select">
		<xsl:param name="level" select="0"/>
		<xsl:variable name="context" select="/page/contexts/context[id/text() = concat($lang, '.', current()/@id)]"/>
		<option value="">
			<xsl:choose>
				<xsl:when test="not($context) or $context/copy/text() or $context/id/text() = $this-context-id">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="value">
						<xsl:value-of select="$context/id/text()"/>
					</xsl:attribute>
					<xsl:if test="/page/context-form/context/copy/text() = $context/id/text()">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="padding">
				<xsl:with-param name="level" select="$level"/>
			</xsl:call-template>
			<xsl:value-of select="@name"/>
		</option>
		<xsl:if test="item">
			<xsl:apply-templates select="item" mode="select">
				<xsl:with-param name="level" select="$level + 1"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="@module = 'project'">
			<xsl:call-template name="projects"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="padding">
		<xsl:param name="level" select="0"/>
		<xsl:if test="$level &gt; 0">
			<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
			<xsl:call-template name="padding">
				<xsl:with-param name="level" select="$level - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="projects">
		<xsl:for-each select="/page/navigation/item[@module = 'project']/item">
			<option value="" disabled="disabled">
				<xsl:call-template name="padding">
					<xsl:with-param name="level" select="1"/>
				</xsl:call-template>
				<xsl:value-of select="@name"/>
			</option>
			<xsl:apply-templates select="/page/projects/project[@type = current()/@type]"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="project">
		<xsl:variable name="project-type" select="/page/navigation/item[@module = 'project']/item[@type = current()/@type]/@key"/>
		<xsl:variable name="context" select="/page/contexts/context[id/text() = concat($lang, '.projects.', $project-type, '.', current()/@id)]"/>
		<option value="">
			<xsl:choose>
				<xsl:when test="not($context) or $context/copy/text() or $context/id/text() = $this-context-id">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="value">
						<xsl:value-of select="$context/id/text()"/>
					</xsl:attribute>
					<xsl:if test="/page/context-form/context/copy/text() = $context/id/text()">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="padding">
					<xsl:with-param name="level" select="2"/>
				</xsl:call-template>
			<xsl:value-of select="title/text()"/>
		</option>
	</xsl:template>

</xsl:stylesheet>