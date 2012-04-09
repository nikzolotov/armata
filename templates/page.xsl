<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="common/navigation-item-path.xsl"/>
	<xsl:import href="common/utils.xsl"/>
	<xsl:import href="common/text.xsl"/>

	<xsl:param name="default-lang"/>
	<xsl:param name="lang"/>
	<xsl:param name="index"/>
	<xsl:param name="DateNow"/>
	<xsl:param name="body-id"/>

	<xsl:variable name="languages" select="document('../resources/languages.xml')/languages"/>
	<xsl:variable name="txtres" select="document('../resources/txtres.xml')/txtres/resources[@lang=$lang]"/>

	<xsl:template match="*"/>

	<xsl:template match="page">
		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">]]></xsl:text>
		<html xml:lang="ru" lang="ru">
			<xsl:attribute name="xmlns">http://www.w3.org/1999/xhtml</xsl:attribute>
			<xsl:call-template name="html-head"/>
			<xsl:call-template name="html-body"/>
		</html>
	</xsl:template>

	<xsl:template name="html-head">
		<head>
			<title>
				<xsl:call-template name="title-text"/>
			</title>
			<meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
			
			<xsl:call-template name="include-css">
				<xsl:with-param name="name" select="'base'"/>
			</xsl:call-template>
			<xsl:call-template name="include-css">
				<xsl:with-param name="name" select="'main'"/>
			</xsl:call-template>
			<xsl:call-template name="include-css">
				<xsl:with-param name="name" select="'thickbox'"/>
			</xsl:call-template>
			
			<xsl:comment><xsl:text disable-output-escaping="yes"><![CDATA[[if lte IE 7]><link rel="stylesheet" type="text/css" href="/css/ie.css"/><![endif]]]></xsl:text></xsl:comment>
			<xsl:comment><xsl:text disable-output-escaping="yes"><![CDATA[[if lte IE 6]><link rel="stylesheet" type="text/css" href="/css/ie6.css"/><![endif]]]></xsl:text></xsl:comment>
			
			<xsl:call-template name="css-includes"/>
			
			<xsl:call-template name="include-script">
				<xsl:with-param name="name" select="'jquery-1.2.6.min'"/>
			</xsl:call-template>
			<xsl:call-template name="include-script">
				<xsl:with-param name="name" select="'thickbox.min'"/>
			</xsl:call-template>
			<xsl:call-template name="include-script">
				<xsl:with-param name="name" select="'main'"/>
				<xsl:with-param name="query" select="'?v=1.1'"/>
			</xsl:call-template>
			
			<xsl:call-template name="script-includes"/>
			
			<link href="/favicon.ico" rel="shortcut icon"/>
		</head>
	</xsl:template>
	
	<xsl:template name="title-text">
		<xsl:value-of select="$txtres/title"/>
		<xsl:choose>
			<xsl:when test="string-length(/page/static-text/title/text()) != 0">
				<xsl:text> — </xsl:text>
				<xsl:value-of select="/page/static-text/title/text()"/>
			</xsl:when>
			<xsl:when test="string-length(/page/navigation//item[@hit]/@name) != 0">
				<xsl:text> — </xsl:text>
				<xsl:value-of select="/page/navigation//item[@hit]/@name"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="css-includes"/>
	<xsl:template name="script-includes"/>

	<xsl:template name="html-body">
		<body>
			<xsl:choose>
				<xsl:when test="$index">
					<xsl:attribute name="id">index-page</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$body-id">
						<xsl:attribute name="id">
							<xsl:value-of select="$body-id"/>
						</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<div id="container-wrapper">
				<div id="container">
					<div id="header">
						<xsl:call-template name="header"/>
					</div>
					<xsl:if test="$index">
						<xsl:call-template name="promo"/>
					</xsl:if>
					<hr class="hidden"/>
					<div class="wrapper-fix">
						<div class="wrapper">
							<div id="content">
								<xsl:call-template name="content-blocks"/>
							</div>
						</div>
						<hr class="hidden"/>
						<div id="navigation">
							<xsl:call-template name="navigation"/>
						</div>
					</div>
					<div id="footer">
						<xsl:call-template name="footer"/>
					</div>
				</div>
			</div>
		</body>
	</xsl:template>

	<xsl:template name="header">
		<h1>
			<xsl:choose>
				<xsl:when test="$index">
					<strong>
						<xsl:value-of select="$txtres/title"/>
					</strong>
				</xsl:when>
				<xsl:otherwise>
					<a href="/">
						<xsl:value-of select="$txtres/title"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</h1>
		<em>
			<xsl:copy-of select="$txtres/slogan/text()|$txtres/slogan/*"/>
		</em>
		<div class="menu">
			<xsl:call-template name="main-menu"/>
			<p>
				<xsl:for-each select="navigation//item[@key='map']">
					<a>
						<xsl:attribute name="href">
							<xsl:call-template name="navigation-item-path"/>
						</xsl:attribute>
						<xsl:value-of select="@name"/>
					</a>
				</xsl:for-each>
			</p>
		</div>
		<div class="b-contacts">
			<h2 class="title">Есть проект?</h2>
			<xsl:apply-templates select="phones" mode="contacts"/>
		</div>
	</xsl:template>

	<xsl:template name="main-menu">
		<ul class="clearfix">
			<xsl:for-each select="navigation/item">
				<li>
					<xsl:if test="@in">
						<xsl:attribute name="class">
							<xsl:text>active</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="@hit">
							<strong>
								<xsl:value-of select="@name"/>
							</strong>
						</xsl:when>
						<xsl:otherwise>
							<a>
								<xsl:attribute name="href">
									<xsl:call-template name="navigation-item-path"/>
								</xsl:attribute>
								<xsl:value-of select="@name"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
	<xsl:template match="phones" mode="contacts">
		<xsl:if test="phone">
			<ul class="tabs-controls">
				<xsl:apply-templates select="phone" mode="link"/>
			</ul>
			<xsl:apply-templates select="phone" mode="contacts"/>
		</xsl:if>
		<div class="more">
			<a class="link">
				<xsl:attribute name="href">
					<xsl:apply-templates mode="navigation-item-path" select="/page/navigation//item[@key = 'contacts']"/>
				</xsl:attribute>
				<xsl:text>другие контакты</xsl:text>
			</a>
		</div>
	</xsl:template>
	
	<xsl:template match="phone" mode="link">
		<li class="item">
			<a class="link" href="#phone-{@id}">
				<xsl:value-of select="title/text()"/>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template match="phone" mode="contacts">
		<div class="tab" id="phone-{@id}">
			<xsl:if test="position() != 1">
				<xsl:attribute name="style">display: none</xsl:attribute>
			</xsl:if>
			<h3 class="phone">
				<xsl:value-of select="number/text()"/>
			</h3>
			<div class="desc">
				<xsl:value-of select="desc/text()"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="promo">
		<div id="promo" class="clearfix">
			<div class="specialization">
				<h2 class="directing">Наша специализация</h2>
				<ul>
					<xsl:for-each select="promo/type">
						<li>
							<xsl:if test="position() = 1">
								<xsl:attribute name="class">selected</xsl:attribute>
							</xsl:if>
							<a href="#{@id}">
								<xsl:value-of select="title"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</div>
			<div class="illustration">
				<img src="/img/ill/food1.jpg" alt="some alt"/>
			</div>
			<div class="description">
				<xsl:for-each select="promo/type">
					<div id="{@id}">
						<h3>
							<xsl:value-of select="description/title"/>
						</h3>
						<p>
							<xsl:value-of select="description/text"/>
						</p>
						<p class="examples">
							<a href="{description/link/@href}">
								<xsl:value-of select="description/link/text()"/>
							</a>
						</p>
					</div>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="content-blocks">
		<div class="wrapper-fix">
			<div class="wrapper">
				<div class="main-content">
					<xsl:call-template name="content"/>
				</div>
			</div>
			<div id="extra">
				<xsl:if test="$index">
					<xsl:attribute name="class">l-extra-compact</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="extra"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="content">
		<xsl:apply-templates/>
		<xsl:if test="$index">
			<xsl:if test="news/article">
				<div class="news">
					<h2>
						<xsl:text>Новости и события</xsl:text>
						<a href="/news.rss">
							<img src="/img/ico/rss.gif" alt="RSS" title="RSS"/>
						</a>
					</h2>
					<dl>
						<xsl:apply-templates select="news/article" mode="list"/>
					</dl>
					<p class="archive">
						<a>
							<xsl:attribute name="href">
								<xsl:apply-templates select="navigation//item[@key='news']" mode="navigation-item-path"/>
							</xsl:attribute>
							<xsl:text>Архив новостей</xsl:text>
						</a>
					</p>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="extra">
		<xsl:choose>
			<xsl:when test="context/text">
				<xsl:apply-templates select="context/text" mode="text"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#160;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="navigation">
		<xsl:if test="navigation/item[@in and @key != 'catalog']/item">
			<ul class="sub-menu">
				<xsl:apply-templates select="navigation/item[@in]/item" mode="sub"/>
			</ul>
		</xsl:if>
		<xsl:if test="navigation/item[@in and (@key = 'collaboration' or @key = 'catalog')] or $index">
			<h2 class="directing">Выпускаемая продукция</h2>
			<ul class="sub-menu catalog">
				<xsl:apply-templates select="navigation/item[@key = 'catalog']/item" mode="sub">
					<xsl:with-param name="full" select="true()"/>
				</xsl:apply-templates>
			</ul>
		</xsl:if>
		<xsl:call-template name="collaboration-menu"/>
	</xsl:template>
	
	<xsl:template match="item" mode="sub">
		<xsl:param name="full" select="false()"/>
		<li>
			<xsl:if test="@in">
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test=".//item[@in]">active-parent</xsl:when>
						<xsl:otherwise>active</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@highlight">
				<xsl:attribute name="class">
					<xsl:text>highlighted</xsl:text>
					<xsl:if test="preceding-sibling::item[@highlight]"> highlighted-next</xsl:if>
					<xsl:if test="@in"> active</xsl:if>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@hit">
					<strong>
						<xsl:value-of select="@name"/>
					</strong>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="@in and .//item[@in]">
							<em>
								<xsl:call-template name="navigation-item-link"/>
							</em>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="navigation-item-link"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="(@in or $full = true()) and item">
				<ul>
					<xsl:apply-templates select="item" mode="sub"/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template name="collaboration-menu">
		<xsl:if test="not(navigation/item[@in and @key = 'collaboration'])">
			<h2 class="directing">Предлагаем сотрудничество</h2>
			<ul class="another-menu">
				<xsl:for-each select="navigation/item[@key = 'collaboration']/item">
					<li>
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="navigation-item-path"/>
							</xsl:attribute>
							<xsl:value-of select="@name"/>
						</a>
					</li>				
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="footer">
		<hr class="short"/>
		<em>
			<xsl:value-of select="$txtres/small-slogan"/>
		</em>
		<address class="vcard">
			<xsl:text>© 1994—</xsl:text>
			<xsl:value-of select="substring($DateNow, 1, 4)"/>
			<xsl:text>, </xsl:text>
			<a class="fn org url masked" href="http://www.armata.ru/">
				<xsl:value-of select="$txtres/title"/>
			</a>
			<xsl:text>®</xsl:text>
			<br/>
			<span class="adr">
				<span class="country-name">
					<xsl:value-of select="$txtres/address/country-name"/>
				</span>
				<xsl:text>, </xsl:text>
				<span class="region">
					<xsl:value-of select="$txtres/address/region"/>
				</span>
				<xsl:text>, </xsl:text>
				<span class="locality">
					<xsl:value-of select="$txtres/address/locality"/>
				</span>
				<xsl:text>, </xsl:text>
				<span class="street-address">
					<xsl:value-of select="$txtres/address/street-address"/>
				</span>
			</span>
			<span class="tel hidden">
				<span class="value">
					<xsl:attribute name="title">
						<xsl:value-of select="translate($txtres/phone/code, ' ()', '')"/>
						<xsl:value-of select="translate($txtres/phone/number, '-', '')"/>
					</xsl:attribute>
					<xsl:value-of select="$txtres/phone/code"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$txtres/phone/number"/>
				</span>
			</span>
		</address>
		<p>
			<xsl:copy-of select="$txtres/copyright/text()|$txtres/copyright/*"/>
		</p>
		<ul class="clearfix">
			<li>
				<xsl:apply-templates select="navigation//item[@key = 'contacts']" mode="navigation-item-link"/>
			</li>
			<li>
				<xsl:apply-templates select="navigation//item[@key = 'vacancy']" mode="navigation-item-link"/>
			</li>
		</ul>
		<p class="partners">
			<a href="http://7lepestok.ru/anketa.html">
				<img src="http://www.7lepestok.ru/assets/images/Banners/468banner-action.gif" alt="Помогите детям"/>
			</a> 
		</p>
		<div>
			<xsl:call-template name="counters"/>
		</div>
		<p class="developer vcard">
			<xsl:copy-of select="$txtres/developer/text()|$txtres/developer/*"/>
		</p>
	</xsl:template>
	
	<xsl:template name="counters">
		<xsl:comment>Yandex.Metrika counter</xsl:comment>
		<script src="//mc.yandex.ru/metrika/watch_visor.js" type="text/javascript"><xsl:text><![CDATA[]]></xsl:text></script>
		<div style="display:none;">
			<xsl:text disable-output-escaping="yes"><![CDATA[<script type="text/javascript"><!--
				try {
					var yaCounter111380 = new Ya.Metrika({
						id: 111380,
						clickmap: true,
						accurateTrackBounce: true
					});
				}
				catch(e){}
				//--></script>]]></xsl:text>
		</div>
		<noscript>
			<div>
				<img src="//mc.yandex.ru/watch/111380" style="position:absolute; left:-9999px;" alt="" />
			</div>
		</noscript>
		<xsl:comment>/Yandex.Metrika counter</xsl:comment>
	</xsl:template>
	
	<xsl:template match="static-text">
		<xsl:apply-templates select="text" mode="text"/>
	</xsl:template>
	
	<xsl:template match="article" mode="list">
		<dt>
			<xsl:if test="preview">
				<xsl:attribute name="class">
					<xsl:text>img</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<a href="/about/news/{@id}.html">
				<xsl:if test="preview">
					<img alt="{title}" title="{title}">
						<xsl:copy-of select="preview/@*"/>
					</img>
				</xsl:if>
				<xsl:value-of select="title"/>
			</a>
		</dt>
		<dd>
			<xsl:if test="preview">
				<xsl:attribute name="class">
					<xsl:text>img</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<p>
				<xsl:apply-templates select="lead" mode="text"/>
			</p>
			<p class="date">
				<xsl:value-of select="number(substring(date,9,2))"/>
				<xsl:text>&#160;</xsl:text>
				<xsl:call-template name="month-name">
					<xsl:with-param name="num" select="substring(date,6,2)"/>
					<xsl:with-param name="text-transform" select="'lower'"/>
					<xsl:with-param name="rod" select="'true'"/>
				</xsl:call-template>
				<xsl:text>&#160;</xsl:text>
				<xsl:value-of select="substring(date,1,4)"/>
				<xsl:text> года</xsl:text>
			</p>
		</dd>
	</xsl:template>
	
	<xsl:template match="item" mode="menu">
		<xsl:param name="wrap"/>
		<xsl:param name="wrap-in"/>
		<xsl:param name="wrap-link"/>
		<xsl:param name="key"/>
		<xsl:param name="depth"/>
		<xsl:param name="ex-classes"/>
		<li>
			<xsl:variable name="class">
				<xsl:if test="@in">
					<xsl:text>active</xsl:text>
				</xsl:if>
				<!--
					<xsl:if test="$ex-classes and ($depth &gt; 0) and @in">
					<xsl:text> selected</xsl:text>
					</xsl:if>
				-->
				<xsl:if test="$key">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@key"/>
				</xsl:if>
				<xsl:if test="$ex-classes and ($depth = 0) and (position() = last())">
					<xsl:text> last</xsl:text>
				</xsl:if>
				<xsl:if test="$ex-classes and ($depth = 0) and (position() = 1)">
					<xsl:text> first</xsl:text>
				</xsl:if>
			</xsl:variable>
			<xsl:if test="string-length($class) &gt; 1">
				<xsl:attribute name="class">
					<xsl:value-of select="$class"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@hit or (@in and not(item[@in]))">
					<xsl:choose>
						<xsl:when test="$wrap">
							<xsl:element name="{$wrap}">
								<xsl:choose>
									<xsl:when test="$wrap-link">
										<a>
											<xsl:attribute name="href">
												<xsl:call-template name="navigation-item-path"/>
											</xsl:attribute>
											<xsl:value-of select="@name"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@name"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@name"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@in and $wrap-in">
					<xsl:element name="{$wrap-in}">
						<xsl:choose>
							<xsl:when test="$wrap-link">
								<a>
									<xsl:attribute name="href">
										<xsl:call-template name="navigation-item-path"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@name"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<a>
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="@follow">
									<xsl:apply-templates select="item[1]" mode="navigation-item-path"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="navigation-item-path"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="$ex-classes and ($depth &gt; 0)">
							<xsl:attribute name="class">head</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@name"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="item and $depth &gt; 0">
				<ul>
					<xsl:apply-templates select="item" mode="menu">
						<xsl:with-param name="wrap" select="$wrap"/>
						<xsl:with-param name="wrap-link" select="$wrap-link"/>
						<xsl:with-param name="ex-classes" select="$ex-classes"/>
						<xsl:with-param name="key" select="$key"/>
						<xsl:with-param name="depth" select="$depth - 1"/>
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
</xsl:stylesheet>