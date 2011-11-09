<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="base-dir">/admin</xsl:variable>
	<xsl:param name="use-fckeditor">false</xsl:param>

	<xsl:template match="*" />
	
	<xsl:template match="page">
		<html>
			<xsl:call-template name="html-head" />
			<xsl:call-template name="html-body" />
		</html>
	</xsl:template>
	
	<xsl:template name="html-head">
		<head>
			<title>
				<xsl:choose>
					<xsl:when test="navigation//item[@in and not(item[@in])]">
						<xsl:value-of select="navigation//item[@in and not(item[@in])]/@name" />
					</xsl:when>
					<xsl:otherwise>АРМ администратора</xsl:otherwise>
				</xsl:choose>
			</title>
			<link rel="StyleSheet" type="text/css" href="{$base-dir}/css/main.css" />
			<!-- этот код позволяет задавать файл стилей, специфичный для IE, вплоть до версии -->
			<xsl:comment>[if IE]&gt; &lt;style type="text/css"&gt; /*&lt;![CDATA[*/ @import url(<xsl:value-of select="$base-dir" />/css/ie-fixes.css); /*]]&gt;*/ &lt;/style&gt; &lt;![endif]</xsl:comment>
			<xsl:if test="$use-fckeditor = 'true'">
				<script type="text/javascript" src="/admin/js/fckeditor/fckeditor.js">&#160;</script>
				<script type="text/javascript">
					function showeditor(lnk){
						var oFCKeditor = new FCKeditor( lnk.name );
						oFCKeditor.BasePath = '/admin/js/fckeditor/';
						oFCKeditor.Height=450;
						oFCKeditor.ReplaceTextarea();
						lnk.parentNode.style.display="none";
						return false;
					}
				</script>
			</xsl:if>
		</head>
	</xsl:template>

	<xsl:template name="html-body">
		<body xsl:use-attribute-sets="body">
			<table id="grid" xsl:use-attribute-sets="grid">
				<xsl:apply-templates select="navigation" mode="navigation" />
				<xsl:call-template name="page-body" />
				<xsl:call-template name="tail" />
				<tr>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
					<td width="10%"><div style="width: 95px; height: 1px;"><spacer type="block" width="95" height="1" /></div></td>
				</tr>
			</table>
		</body>
	</xsl:template>
	
	<xsl:template name="page-body">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="navigation" mode="navigation">
		<tr>
			<td colspan="10" id="menu">
				<div id="logo">
					<a href="{$base-dir}">АРМ администратора</a>
				</div>
				<xsl:for-each select="item">
					<div class="menu-item">
						<a>
							<xsl:if test="not(@hit)">
								<xsl:attribute name="href">
									<xsl:call-template name="navigation-item-path" />
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="@in">
								<xsl:attribute name="class">in</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="@name" />
						</a>
					</div>
				</xsl:for-each>
			</td>
		</tr>
		<!--xsl:if test="not(item[@key='text' and @in])">
			<xsl:call-template name="sub-menu" />
		</xsl:if-->
	</xsl:template>

	<xsl:template name="sub-menu">
		<tr>
			<td colspan="10" id="submenu">
				<xsl:for-each select="item[@in]/item">
					<div class="menu-item">
						<a>
							<xsl:if test="not(@hit)">
								<xsl:attribute name="href">
									<xsl:call-template name="navigation-item-path" />
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="@in">
								<xsl:attribute name="class">in</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="@name" />
						</a>
					</div>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="tail">
		<tr class="tail">
			<td><br /></td>
			<td class="copyright" colspan="4">
				<xsl:text>&#169; 2005</xsl:text>
				<xsl:if test="substring($DateNow, 1, 4) &gt; 2005">
					<xsl:text>&#8212;</xsl:text>
					<xsl:value-of select="substring($DateNow, 1, 4)" />
				</xsl:if>
				<xsl:text> Студия </xsl:text>
				<a href="http://www.infolio.ru/">infolio / 2°</a>
			</td>
			<td colspan="5" class="support">
				<xsl:text>Электронная почта: </xsl:text>
				<a href="mailto:support@infolio.ru">support@infolio.ru</a>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="html">
		<xsl:copy-of select="*" />
	</xsl:template>
	
	
	<xsl:template name="formated-date">
		<xsl:param name="time">true</xsl:param>
		<xsl:value-of select="substring(., 9, 2)" />
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(., 6, 2)" />
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(., 1, 4)" />
		<xsl:if test="$time = true">
			<xsl:text>, </xsl:text>
			<xsl:value-of select="substring(., 12, 5)" />
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="body">
		<xsl:attribute name="id">body</xsl:attribute>
		<xsl:attribute name="marginwidth">0</xsl:attribute>
		<xsl:attribute name="marginheight">0</xsl:attribute>
		<xsl:attribute name="topmargin">0</xsl:attribute>
		<xsl:attribute name="leftmargin">0</xsl:attribute>
		<xsl:attribute name="rightmargin">0</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="grid">
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="cellpadding">0</xsl:attribute>
		<xsl:attribute name="cellspacing">0</xsl:attribute>
	</xsl:attribute-set>

</xsl:stylesheet>