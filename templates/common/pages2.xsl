<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="*" name="pages" mode="pages">
    <xsl:param name="base" />
    <xsl:param name="class" />
    <xsl:param name="arrows" />
    <xsl:param name="page" select="@page" />
    <xsl:param name="pages" select="@pages" />
    
    <div class="pages">
      <xsl:if test="$class">
        <xsl:attribute name="class">
          <xsl:text>pages </xsl:text>
          <xsl:value-of select="$class"/>
        </xsl:attribute>
      </xsl:if>
      <b>Страницы: </b>
      <xsl:if test="$page &gt; 1 and $arrows">
        <xsl:call-template name="page-link">
          <xsl:with-param name="text">&#8592;</xsl:with-param>
          <xsl:with-param name="page" select="$page - 1" />
          <xsl:with-param name="base" select="$base" />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$page=1">
        <xsl:call-template name="page-link">
          <xsl:with-param name="text">
            <b>1</b>
          </xsl:with-param>
          <xsl:with-param name="base" select="$base" />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="not($page=1)">
        <xsl:call-template name="page-link">
          <xsl:with-param name="page" select="1" />
          <xsl:with-param name="base" select="$base" />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$page &gt; 5">
        <xsl:text>&#160;&#133;&#160;</xsl:text>
      </xsl:if>
      <xsl:call-template name="pages-loop" >
      	<xsl:with-param name="pages" select="$pages" />
      	<xsl:with-param name="page" select="$page" />
        <xsl:with-param name="cur" select="$page - 3"></xsl:with-param>
        <xsl:with-param name="base" select="$base" />
      </xsl:call-template>
      <xsl:if test="$page &lt; $pages - 4">
        <xsl:text>&#160;&#133;&#160;</xsl:text>
      </xsl:if>
      <xsl:if test="$page=$pages">
        <xsl:call-template name="page-link">
          <xsl:with-param name="text">
            <b>
              <xsl:value-of select="$pages" />
            </b>
          </xsl:with-param>
          <xsl:with-param name="base" select="$base" />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="not($page=$pages)">
        <xsl:call-template name="page-link">
          <xsl:with-param name="page" select="$pages" />
          <xsl:with-param name="base" select="$base" />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$page &lt; $pages and $arrows">
        <xsl:call-template name="page-link">
          <xsl:with-param name="text">&#8594;</xsl:with-param>
          <xsl:with-param name="page" select="$page + 1" />
          <xsl:with-param name="base" select="$base" />
        </xsl:call-template>
      </xsl:if>
    </div>
  </xsl:template>


  <xsl:template name="pages-loop">
    <xsl:param name="base" />
    <xsl:param name="cur">1</xsl:param>
    <xsl:param name="page" />
    <xsl:param name="pages" />
    <xsl:if test="$cur &lt; $page + 4 and $cur &lt; $pages">
      <xsl:if test="$cur &gt; 1">
        <xsl:choose>
          <xsl:when test="$cur = $page">
            <xsl:call-template name="page-link">
              <xsl:with-param name="text">
                <b>
                  <xsl:value-of select="$cur" />
                </b>
              </xsl:with-param>
              <xsl:with-param name="base" select="$base" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="page-link">
              <xsl:with-param name="page" select="$cur" />
              <xsl:with-param name="base" select="$base" />
            </xsl:call-template>
            <xsl:if test="($page &gt; 5 and $cur=2) or ($page &lt; $pages - 5 and $cur = $pages - 1)">
              <xsl:text>&#160;&#133;&#160;</xsl:text>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:call-template name="pages-loop">
      	<xsl:with-param name="pages" select="$pages" />
      	<xsl:with-param name="page" select="$page" />
        <xsl:with-param name="cur" select="$cur + 1" />
        <xsl:with-param name="base" select="$base" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <xsl:template name="page-link">
    <xsl:param name="base" />
    <xsl:param name="text" />
    <xsl:param name="page" />
    <xsl:text>&#160;</xsl:text>
    <xsl:choose>
      <xsl:when test="$page">
        <a href="?">
          <xsl:if test="$base">
            <xsl:attribute name="href">
              <xsl:value-of select="$base" />
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$page &gt; 1">
            <xsl:attribute name="href">
              <xsl:value-of select="$base" />
              <xsl:text>?page=</xsl:text>
              <xsl:value-of select="$page" />
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$text" />
          <xsl:if test="not($text)">
            <xsl:value-of select="$page" />
          </xsl:if>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#160;</xsl:text>
  </xsl:template>

</xsl:stylesheet>