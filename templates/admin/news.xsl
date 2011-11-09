<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../common/utils.xsl" />
	<xsl:import href="../common/date-form.xsl" />
	<xsl:import href="../common/pages.xsl" />
	<xsl:import href="../common/fckeditor.xsl" />
	<xsl:import href="../common/text.xsl" />

	<xsl:param name="action" />
	
	<xsl:template match="article-list">
		<tr class="content">
			<td colspan="2" valign="top" style="padding: 20px;">
				<p><a href="?act=edit">+ Добавить</a></p>
			</td>
			<td colspan="8" valign="top" style="padding: 20px;">
				<h1><xsl:value-of select="/page/navigation//item[@in and not(item/@in)]/@name" /></h1>
				<xsl:apply-templates select="../pages" mode="pages" />
				<xsl:apply-templates mode="list" />
				<xsl:apply-templates select="../pages" mode="pages" />
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="article[@id]" mode="list">
		<p style="clear:both">
			<xsl:if test="img"><img src="/i/news/{@id}.{img}" style="float:left; margin-right:10px;"/></xsl:if>
			<span style="color: gray;">
				<xsl:apply-templates select="date" />
				<xsl:text>&#160;&#8212; </xsl:text>
			</span>
			<a href="?id={@id}">
				<xsl:value-of select="title" />
			</a>
			<xsl:if test="not(@published)"><span style="margin-left: 20px; padding: 0px 5px; background-color: red; color: white;">Не опубликованно!</span></xsl:if>
			<br />		
			<xsl:value-of select="lead" />
		</p>
	</xsl:template>
	
	<xsl:template match="article[@id]">
			<tr class="content">
			<td colspan="2" valign="top" style="padding: 20px;">
				<p>
					<a href="?">Назад</a>
				</p>
				<p>
					<a href="?id={@id}&amp;act=edit">Редактировать</a>
				</p>
				<p>
					<a href="?id={@id}&amp;act=delete" onclick="return confirm('Вы уверены?');">Удалить</a>
				</p>
			</td>
			<td colspan="10" valign="top" style="padding: 20px;">
				<h1><xsl:value-of select="title" /></h1>
				<xsl:if test="img"><img src="/i/news/{@id}.{img}" style="float:left; margin-right:10px;"/></xsl:if>
				<p style="color: gray;">
					<xsl:apply-templates select="date" />
					<xsl:if test="not(@published)"><span style="margin-left: 20px; padding: 0px 5px; background-color: red; color: white;">Не опубликованно!</span></xsl:if>
				</p>
				<p style="color: gray; font-style: italic;"><xsl:apply-templates select="preview" /><xsl:value-of select="lead" /></p>
				<xsl:apply-templates select="body" mode="text" />
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="preview">
		<a href="/share/{@share_id - 1}.jpg">
			<img>
				<xsl:copy-of select="@*" />
			</img>
		</a>
		<br />
	</xsl:template>
	
	<xsl:template match="article-form">
		<xsl:call-template name="js-showeditor" />
		<tr class="content">
			<td colspan="2" valign="top" style="padding: 20px;">
				<p><a href="?id={article/@id}">Назад</a></p>
			</td>
			<td colspan="8" valign="top" style="padding: 20px;">
			<h1><xsl:value-of select="/page/navigation//item[@in and not(item/@in)]/@name" /></h1>
			<form action="?id={article/@id}&amp;act=update" method="post" enctype="multipart/form-data">
				<p>Дата<br /><xsl:call-template name="dateForm">
					<xsl:with-param name="date">
						<xsl:choose>
							<xsl:when test="article/date"><xsl:value-of select="article/date" /></xsl:when>
							<xsl:otherwise><xsl:value-of select="$DateNow" /></xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="min-year">2006</xsl:with-param>
					<xsl:with-param name="max-year"><xsl:value-of select="substring($DateNow, 1, 4) + 1" /></xsl:with-param>
					<xsl:with-param name="type">datetime</xsl:with-param>
				</xsl:call-template></p>
				<!--p>META Description<br /><input type="text" name="meta-description" value="{article/meta-description}" class="wide" /></p>
				<p>META Keywords<br /><input type="text" name="meta-keywords" value="{article/meta-keywords}" class="wide" /></p-->
				<p>Заголовок<br /><input type="text" name="title" style="width: 100%;" value="{article/title}" /></p>
				<p>Резюме<br /><textarea name="lead" rows="3" style="width: 100%;"><xsl:value-of select="article/lead"/><xsl:comment></xsl:comment></textarea></p>
				<xsl:apply-templates select="article/preview"/>
				<p>
					<label>Изображение</label>
					<br />
					<input type="file" name="preview" />
					<xsl:if test="article/preview">
						<span style="padding-left: 20px;">
							<input type="checkbox" name="del-preview" value="1" id="del-preview" />
							<label for="del-preview"> удалить</label>
						</span>
					</xsl:if>
				</p>
				<p>Текст<span> (<a name="body" class="link" onclick="return showeditor(this);">редактор</a>)</span><br /><textarea name="body" style="width: 100%; height: 450px;"><xsl:value-of select="article/body" /><xsl:comment></xsl:comment></textarea></p>
				<p>
					<input type="checkbox" value="1" name="published" id="published">
						<xsl:if test="article/@published"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
					</input>
					<label for="published"> Опубликовать</label>
				</p>
				<p><input type="submit" value="Сохранить" /><input type="button" value="Отмена" onclick="window.history.back();" /></p>
			</form>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="date">
		<xsl:call-template name="date">
			<xsl:with-param name="with-time" select="'false'" />
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>