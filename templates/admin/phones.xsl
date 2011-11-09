<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../common/utils.xsl"/>
	<xsl:import href="../common/text.xsl"/>
	
	<xsl:template match="phones">
		<tr class="content">
			<xsl:call-template name="right-navigation"/>
			<td colspan="8" valign="top" style="padding: 20px;">
				<h1>
					<xsl:value-of select="/page/navigation//item[@in and not(item[@in])]/@name"/>
				</h1>
				<xsl:if test="phone">
					<ol>
						<xsl:apply-templates mode="list"/>
					</ol>
				</xsl:if>
				<p>
					<a href="?act=edit&amp;l={$lang}">+ Добавить</a>
				</p>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="phone[@id]" mode="list">
		<li>
			<a href="?id={@id}">
				<xsl:value-of select="title/text()"/>
			</a>
			<xsl:if test="not(@published)">
				<span style="margin-left: 20px; padding: 0px 5px; background-color: red; color: white;">Не опубликованно!</span>
			</xsl:if>
			<br/>
			<xsl:value-of select="number/text()"/>
		</li>
	</xsl:template>
	
	<xsl:template match="phone[@id]">
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
				<xsl:if test="title">
					<h1>
						<xsl:value-of select="title"/>
					</h1>
				</xsl:if>
				<xsl:if test="not(@published)">
					<p>
						<span style="padding: 0px 5px; background-color: red; color: white;">Не опубликованно!</span>
					</p>
				</xsl:if>
				<xsl:if test="number">
					<p>
						<xsl:text>Номер: </xsl:text>
						<xsl:value-of select="number"/>
					</p>
				</xsl:if>
				<xsl:if test="desc">
					<p>
						<xsl:text>Краткое описание: </xsl:text>
						<xsl:value-of select="desc"/>
					</p>
				</xsl:if>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="phone-form">
		<tr class="content">
			<td colspan="2" valign="top" style="padding: 20px;">
				<p>
					<a href="?id={phone/@id}">Назад</a>
				</p>
			</td>
			<td colspan="8" valign="top" style="padding: 20px;">
				<h1>
					<xsl:choose>
						<xsl:when test="phone">
							<xsl:text>Телефон</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Новый телефон</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</h1>
				<form action="?id={phone/@id}&amp;act=update" method="post">
					<fieldset style="padding: 0; border: none;">
						<p>
							<label for="f_title">Заголовок</label>
							<br/>
							<input id="f_title" type="text" name="title" style="width: 100%;" value="{phone/title}"/>
						</p>
						<p>
							<label for="f_number">Номер</label>
							<br/>
							<input id="f_number" type="text" name="number" style="width: 100%;" value="{phone/number}"/>
						</p>
						<p>
							<label for="f_desc">Краткое описание</label>
							<br/>
							<textarea id="f_desc" name="desc" style="width: 100%; height: 100px;">
								<xsl:value-of select="phone/desc"/>
								<xsl:comment/>
							</textarea>
						</p>
						<p>
							<input id="f_published" type="checkbox" value="1" name="published">
								<xsl:if test="phone/@published">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
							</input>
							<label for="f_published"> Опубликовать</label>
						</p>
						<p>
							<input type="submit" value="Сохранить"/>
							<input type="button" value="Отмена" onclick="window.history.back();"/>
						</p>
					</fieldset>
				</form>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="right-navigation">
		<td colspan="2" valign="top" style="padding: 20px">
			<p>
				<a href="?act=edit&amp;l={$lang}">+ Добавить</a>
			</p>
		</td>
	</xsl:template>
	
</xsl:stylesheet>