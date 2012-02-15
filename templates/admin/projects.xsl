<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../common/utils.xsl"/>
	<xsl:import href="../common/date-form.xsl"/>
	<xsl:import href="../common/fckeditor.xsl"/>
	<xsl:import href="../common/text.xsl"/>
	
	<xsl:template match="choose-type">
		<tr class="content">
			<xsl:call-template name="right-navigation"/>
			<td colspan="8" valign="top" style="padding: 20px;">
				<h1>
					<xsl:value-of select="/page/navigation/item[@in]/@name"/>
				</h1>
				<p>Выберите раздел, в который вы бы хотели добавить проект.</p>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="projects">
		<tr class="content">
			<xsl:call-template name="right-navigation"/>
			<td colspan="8" valign="top" style="padding: 20px;">
				<h1>
					<xsl:value-of select="/page/navigation//item[@in and not(item[@in])]/@name"/>
				</h1>
				<xsl:apply-templates mode="list"/>
				<p>
					<a href="?act=edit&amp;l={$lang}">+ Добавить</a>
				</p>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="project[@id]" mode="list">
		<p style="clear:both">
			<span style="color: gray;">
				<xsl:apply-templates select="date"/>
				<xsl:text>&#160;&#8212; </xsl:text>
			</span>
			<a href="?id={@id}">
				<xsl:value-of select="title"/>
			</a>
			<xsl:if test="not(@published)">
				<span style="margin-left: 20px; padding: 0px 5px; background-color: red; color: white;">Не опубликованно!</span>
			</xsl:if>
			<br/>		
			<xsl:value-of select="address"/>
		</p>
	</xsl:template>
	
	<xsl:template match="project[@id]">
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
				<p style="color: gray;">
					<xsl:apply-templates select="date"/>
					<xsl:if test="not(@published)">
						<span style="margin-left: 20px; padding: 0px 5px; background-color: red; color: white;">Не опубликованно!</span>
					</xsl:if>
				</p>
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
				<p>
					<a href="/admin/gallery/?group=projects.{@id}">Редактировать связанные фотографии</a> <br/>
					<a href="/admin/context/?id={$lang}.projects.{/page/navigation/item[@module = 'project']/item[@in]/@key}.{@id}">Редактировать содержимое левой колонки</a>
				</p>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="project-form">
		<xsl:call-template name="js-showeditor"/>
		<tr class="content">
			<td colspan="2" valign="top" style="padding: 20px;">
				<p>
					<a href="?id={project/@id}">Назад</a>
				</p>
			</td>
			<td colspan="8" valign="top" style="padding: 20px;">
				<h1>
					<xsl:choose>
						<xsl:when test="project">
							<xsl:text>Редактирование</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Добавление</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text> проекта</xsl:text>
				</h1>
				<form action="?id={project/@id}&amp;act=update" method="post">
					<fieldset style="padding: 0; border: none;">
						<p>
							<label for="f_title">Заголовок</label>
							<br/>
							<input id="f_title" type="text" name="title" style="width: 100%;" value="{project/title}"/>
						</p>
						<p>
							<label for="f_seo_title">SEO-title</label>
							<br/>
							<input id="f_seo_title" type="text" name="seo_title" style="width: 100%;" value="{project/seo-title}"/>
						</p>
						<p>
							<label for="f_address">Адрес</label>
							<br/>
							<input id="f_address" type="text" name="address" style="width: 100%;" value="{project/address}"/>
						</p>
						<p>
							<label for="f_end">Дата окончания</label>
							<br/>
							<input id="f_end" type="text" name="end" style="width: 100%;" value="{project/end}"/>
						</p>
						<p>
							<label for="f_body">Текст</label>
							<span> (<a name="body" class="link" onclick="return showeditor(this);">редактор</a>)</span>
							<br/>
							<textarea id="f_body" name="body" style="width: 100%; height: 450px;">
								<xsl:value-of select="project/body"/>
								<xsl:comment/>
							</textarea>
						</p>
						<p>
							<label for="f_see_also">Смотрите также</label>
							<span> (<a name="see_also" class="link" onclick="return showeditor(this);">редактор</a>)</span>
							<br/>
							<textarea id="f_see_also" name="see_also" style="width: 100%; height: 200px;">
								<xsl:value-of select="project/see-also"/>
								<xsl:comment/>
							</textarea>
						</p>
						<p>
							<input id="f_published" type="checkbox" value="1" name="published">
								<xsl:if test="project/@published">
									<xsl:attribute name="checked">true</xsl:attribute>
								</xsl:if>
							</input>
							<label for="f_published"> Опубликовать</label>
						</p>
						<p>
							<input type="submit" value="Сохранить"/>
							<input type="button" value="Отмена" onclick="window.history.back();"/>
						</p>
						<xsl:variable name="date">
							<xsl:choose>
								<xsl:when test="project/date">
									<xsl:value-of select="project/date"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$DateNow"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<input type="hidden" name="year">
							<xsl:attribute name="value">
								<xsl:value-of select="substring($date, 1, 4)"/>
							</xsl:attribute>
						</input>
						<input type="hidden" name="month">
							<xsl:attribute name="value">
								<xsl:value-of select="substring($date, 6, 2)"/>
							</xsl:attribute>
						</input>
						<input type="hidden" name="day">
							<xsl:attribute name="value">
								<xsl:value-of select="substring($date, 9, 2)"/>
							</xsl:attribute>
						</input>
						<input type="hidden" name="hour">
							<xsl:attribute name="value">
								<xsl:value-of select="substring($date, 12, 2)"/>
							</xsl:attribute>
						</input>
						<input type="hidden" name="minute">
							<xsl:attribute name="value">
								<xsl:value-of select="substring($date, 15, 2)"/>
							</xsl:attribute>
						</input>
						<input type="hidden" name="second">
							<xsl:attribute name="value">
								<xsl:value-of select="substring($date, 18, 2)"/>
							</xsl:attribute>
						</input>
					</fieldset>
				</form>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="right-navigation">
		<td colspan="2" valign="top">
			<br/>
			<ul>
				<xsl:apply-templates select="/page/navigation/item[@in]/item" mode="nav"/>
			</ul>
		</td>
	</xsl:template>
	
	<xsl:template match="item" mode="nav">
		<li>
			<xsl:choose>
				<xsl:when test="@in">
					<b>
						<xsl:call-template name="navigation-item-link"/>
					</b>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="navigation-item-link"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="@in and item">
				<ul>
					<xsl:apply-templates select="item" mode="nav" />
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="date">
		<xsl:call-template name="date">
			<xsl:with-param name="with-time" select="'false'"/>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>