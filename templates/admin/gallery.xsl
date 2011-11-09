<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="../common/utils.xsl" />

	<xsl:template name="langs">
		<form style="padding-left:20px;">
			<select name="l">
				<xsl:if test="/page/textform"><xsl:attribute name="disabled">true</xsl:attribute></xsl:if>
				<xsl:for-each select="$languages/lang">
					<option value="{@id}" onclick="form.submit()">
						<xsl:if test="$lang = @id">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@name" />
					</option>
				</xsl:for-each>
			</select>
		</form>
	</xsl:template>


	<xsl:template match="html">
		<tr class="content">
			<xsl:call-template name="right-navigation" />
			<td colspan="8" valign="top" style="padding: 20px;">
				<xsl:copy-of select="*"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="gallery">
		<tr class="content">
			<!--			<td colspan="2" valign="top" style="padding: 20px;">
				<xsl:apply-templates mode="nav" />
			</td> -->
			<xsl:call-template name="right-navigation" />
			<td colspan="8" valign="top">
				<a style="float:right;border:1px #d4d4d4 solid;padding:3px; background:#e4e4e4;margin:0 10px 0 0"  href="?act=form&amp;group={@group}">Добавить фото</a>
				<h1>Фотографии</h1>
				<xsl:apply-templates />
			</td>
		</tr>
	</xsl:template>


	<xsl:template match="photo">
		<div class="photo">
			<a href="?act=form&amp;id={id}">
				<img src="/share/{preview}.jpg" alt="{desc}" title="{desc}" />
			</a>
			<div class="nav">
				<a class="prev" title="Влево">
					<xsl:if test="preceding-sibling::photo">
						<xsl:attribute name="href">
							<xsl:text>?act=swap&amp;group=</xsl:text>
							<xsl:value-of select="@group" />
							<xsl:text>&amp;swap=</xsl:text>
							<xsl:value-of select="id" />
							<xsl:text>;</xsl:text>
							<xsl:value-of select="preceding-sibling::photo[1]/id" />
						</xsl:attribute>
					</xsl:if>
					<xsl:text>&#8592;</xsl:text>
				</a>
				<a class="next" title="Вправо">
					<xsl:if test="following-sibling::photo">
						<xsl:attribute name="href">
							<xsl:text>?act=swap&amp;group=</xsl:text>
							<xsl:value-of select="@group" />
							<xsl:text>&amp;swap=</xsl:text>
							<xsl:value-of select="id" />
							<xsl:text>;</xsl:text>
							<xsl:value-of select="following-sibling::photo[1]/id" />
						</xsl:attribute>
					</xsl:if>
					<xsl:text>&#8594;</xsl:text>
				</a>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="form">
		<tr class="content">
			<xsl:call-template name="right-navigation" />
			<td colspan="8" valign="top" style="padding: 20px;">
				<form action="?act=update&amp;id={photo/id}" method="post" enctype="multipart/form-data">
					<table>
						<tr>
							<td>
								<xsl:if test="photo/preview/text()">
									<img src="/share/{photo/preview}.jpg" />
								</xsl:if>
							</td>
							<td>&#160;</td>
							<td>
								<p>Загрузить фотографию<br/><input type="file" name="photo" /></p>
							</td>
						</tr>
					</table>
					<xsl:variable name="photo" select="photo"/>
					<xsl:for-each select="$languages/lang">
						<xsl:variable name="id" select="@id" />
						<!--p>Альтернативный текст<br/><input type="text" class="wide" name="title_{@id}" value="{$photo/title[@lang=$id]}" /></p-->
						<p>Подпись<br/><input type="text" class="wide" name="desc_{@id}"  value="{$photo/desc[@lang=$id]}" /></p>
					</xsl:for-each>
					<input type="hidden" name="group" value="{@group}{photo/@group}" />
					<input type="submit" value="Обновить" />
<!--					&#160;<input type="button" value="Назад">
						<xsl:attribute name="onclick">
							<xsl:text>window.location='</xsl:text>
							<xsl:apply-templates select="../navigation//item[@in and not(item[@in])]" mode="navigation-item-path" />
							<xsl:text>'</xsl:text>
						</xsl:attribute>
					</input>
					-->
					<xsl:if test="photo/id">
						<p>
							<a href="?act=drop&amp;id={photo/id}&amp;group={photo/@group}" onClick="return confirm('Вы уверены, что хотите удалить это фото?');">Удалить</a>
						</p>
					</xsl:if>
				</form>
			</td>
		</tr>
	</xsl:template>


	<xsl:template match="item" mode="nav">
		<p>
			<a>
				<xsl:choose>
					<xsl:when test="not(@in and not(item[@in]))">
						<xsl:attribute name="href">
							<xsl:call-template name="navigation-item-path" />
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="style">font-weight:bold;</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="@name" />
			</a>
		</p>
	</xsl:template>

	<xsl:template name="right-navigation">
		<td colspan="2" valign="top">
			<br />
			<div style="padding-left:20px">
<!--				<xsl:choose>
					<xsl:when test="not(../navigation//item[@in and not(item[@in])]/item)">
						<xsl:apply-templates select="../navigation//item[@in and not(item[@in])]/../item" mode="nav" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="../navigation//item[@in and not(item[@in])]/item" mode="nav" />
					</xsl:otherwise>
				</xsl:choose> -->
<!--				<xsl:if test="../navigation/item[@key='gallery']/item[@in]">
					<p>
						<br/>
						<a href="?act=form">Добавить фото</a>
					</p>
				</xsl:if> -->
			</div>
		</td>
	</xsl:template>
	

</xsl:stylesheet>