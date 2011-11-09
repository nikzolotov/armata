<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../common/utils.xsl" />

	<xsl:template match="votings">
		<tr class="content">
			<td colspan="2" valign="top" style="padding: 20px;">
				<p>
					<a href="?act=new">+ Добавить</a>
				</p>
			</td>
			<td colspan="8" valign="top" style="padding: 20px;">
				<h1>
					<xsl:value-of select="/page/navigation//item[@in and not(item/@in)]/@name"/>
				</h1>
				<xsl:if test="not(voting)">
					<p>Нет голосований</p>
				</xsl:if>
				<xsl:apply-templates mode="list"/>
			</td>
		</tr>
	</xsl:template>	
	
	<xsl:template match="voting" mode="list">
		<div style="background: whitesmoke; margin-bottom: 10px; border: 1px solid silver;">
			<div style="background: silver; padding: 5px;">
				<a href="?act=edit&amp;id={@id}">Редактировать</a>
				<xsl:text> </xsl:text>
				<a href="?act=del&amp;id={@id}" onclick="return confirm('Вы уверены что хотите удалить это голосование?')">Удалить</a>
			</div>
			<div style="padding: 5px;">
				<h2>
					<xsl:value-of select="question" />
				</h2>
				<xsl:apply-templates select="date"/>
				<p><xsl:text>Тип: </xsl:text>
				<xsl:if test="@type='radio'">Простой</xsl:if>
				<xsl:if test="@type='checkbox'">Множестенный</xsl:if>
				</p>
				<p><xsl:text>Статус: </xsl:text>
				<xsl:if test="@status='open'">Открытое</xsl:if>
				<xsl:if test="@status='close'">Закрытое</xsl:if>
				</p>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="form">
		<tr class="content">
			<td colspan="2" valign="top" style="padding: 20px;">
				<p>
					<a href="?">Назад</a>
				</p>
			</td>
			<td colspan="8" valign="top" style="padding: 20px;">
				<form action="?act=update" method="post">
					<p>Вопрос:<br/>
						<input type="text" name="question" class="wide" maxlen="255" value="{voting/question}" />
					</p>
					<p>Тип: <br/>
						<select name="type">
							<option value="radio">
								<xsl:if test="voting/@type='radio'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:text>Простой</xsl:text>
							</option>
							<option value="checkbox">
								<xsl:if test="voting/@type='checkbox'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:text>Множественный</xsl:text>
							</option>
						</select>
					</p>
					<p>Статус: <br/>
						<select name="status">
							<option value="open">
								<xsl:if test="voting/@status='open'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:text>Открытое</xsl:text>
							</option>
							<option value="close">
								<xsl:if test="voting/@status='close'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:text>Закрытое</xsl:text>
							</option>
						</select>
					</p>
					<input type="hidden" name="id" value="{voting/@id}" />
					<p><input type="submit" value="Сохранить" /></p>
				</form>
				<xsl:if test="voting/@id">
					<h2>Варианты ответов:</h2>
					<form action="?act=ans" method="post">
					<table>
						<xsl:for-each select="voting/answer">
							<tr>
								<td>
									<input type="text" name="{@id}" value="{.}" />
									<xsl:text>&#160;</xsl:text>
								</td>
								<td>
									<a href="?act=del_ans&amp;id={@id}&amp;b={../@id}" onclick="return confirm('Вы действительно хотите удалить вариант ответа?')">удалить</a>
								</td>
							</tr>
						</xsl:for-each>
						<tr>
							<td colspan="2">
								<label for="f_new">Новый вариант:</label><br/>
								<input id="f_new" type="text" name="new"/>
							</td>
						</tr>
					</table>
					<input type="hidden" name="id" value="{voting/@id}" />
					<input type="submit" value="Сохранить" />
					</form>
				</xsl:if>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="date">
		<xsl:call-template name="date">
			<xsl:with-param name="with-time" select="'false'" />
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>