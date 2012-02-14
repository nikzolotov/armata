<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="lang">ru</xsl:param>

	<xsl:include href="../common/utils.xsl" />
	<xsl:include href="../common/text.xsl" />

	
	<xsl:template name="langs">

	</xsl:template>
	
	<xsl:template match="item" mode="nav">
		<li>
			<xsl:choose>
				<xsl:when test="@in">
					<b>
						<xsl:call-template name="navigation-item-link" />
					</b>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="navigation-item-link" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="@in and item">
				<ul>
					<xsl:apply-templates select="item" mode="nav" />
				</ul>
			</xsl:if>
		</li>
		
	</xsl:template>
	
	<xsl:template match="text">
		<tr class="content">
			<xsl:call-template name="right-navigation" />
			<td colspan="8" valign="top" style="padding: 20px;">
				<a style="float:right;border:1px #d4d4d4 solid;padding:3px; background:#e4e4e4;" href="?act=edit&amp;l={$lang}">редактировать</a>
				<div class="text">
					<xsl:apply-templates select="text" mode="text" />
				</div>
				<p>
					<a href="/admin/gallery/?group={id}">Редактировать связанные фотографии</a> <br/>
					<a href="/admin/context/?id={id}">Редактировать содержимое левой колонки</a>
				</p>
			</td>
		</tr>
	</xsl:template>
	

	<xsl:template match="html">
		<tr class="content">
			<xsl:call-template name="right-navigation" />
			<td colspan="8" valign="top" style="padding: 20px;">
				<xsl:copy-of select="*"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="list">
		<tr class="content">
			<xsl:call-template name="right-navigation" />
			<td colspan="8" valign="top" style="padding: 20px;">
				<h1>Текстовые разделы</h1>
				<p>Выберите раздел, текст которого вы бы хотели просмотреть или редактировать.</p>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="textform">
		<tr class="content">
			<xsl:call-template name="right-navigation" />
			<td colspan="8" valign="top" style="padding: 20px;">
				<form action="?act=update&amp;l={$lang}" method="post">
					<p>SEO-title<br /><input type="text" class="wide" name="title" value="{title}" /></p>
					<p>Текст <span>(<a name="text" href="#" onclick="return showeditor(this)">редактор</a>)</span><br /><textarea class="wide" rows="20" name="text"><xsl:if test="not(text)"><xsl:text> </xsl:text></xsl:if><xsl:copy-of select="text/*|text/text()" /></textarea></p>
					<!--input type="hidden" name="l" value="{$lang}" />
					<input type="hidden" name="act" value="update" /-->
					<input type="submit" value="Обновить" />
					&#160;<input type="button" value="Назад">
						<xsl:attribute name="onclick">
							<xsl:text>window.location='</xsl:text>
							<xsl:apply-templates select="../navigation//item[@in and not(item[@in])]" mode="navigation-item-path" />
							<xsl:text>?l=</xsl:text>
							<xsl:value-of select="$lang" />
							<xsl:text>'</xsl:text>
						</xsl:attribute>
					</input>
				</form>
			</td>
		</tr>
	</xsl:template>
	
	
	<xsl:template name="right-navigation">
		<td colspan="2" valign="top">
			<br />
			<xsl:call-template name="langs"/>
			
		<ul>
		<xsl:apply-templates select="/page/navigation/item[@in]/item" mode="nav" />
		</ul>
		</td>
	</xsl:template>
	

</xsl:stylesheet>