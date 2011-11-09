<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="dateForm">
		<xsl:param name="date"/>
		<xsl:param name="year">year</xsl:param>
		<xsl:param name="month">month</xsl:param>
		<xsl:param name="day">day</xsl:param>
		<xsl:param name="hour">hour</xsl:param>
		<xsl:param name="minute">minute</xsl:param>
		<xsl:param name="second"/>
		<xsl:param name="type">date</xsl:param>
		<xsl:param name="min-year">1930</xsl:param>
		<xsl:param name="max-year"/>
		<xsl:if test="contains($type, 'date')">
			<select name="{$day}">
				<xsl:call-template name="dateFormLoop">
					<xsl:with-param name="begin" select="1"/>
					<xsl:with-param name="end" select="31"/>
					<xsl:with-param name="value" select="substring(substring-after(substring-after($date, '-'), '-'),1,2)"/>
				</xsl:call-template>
			</select>
			<xsl:text> / </xsl:text>
			<select name="{$month}">
				<xsl:call-template name="dateFormLoop">
					<xsl:with-param name="begin" select="1"/>
					<xsl:with-param name="end" select="12"/>
					<xsl:with-param name="value" select="substring-before(substring-after($date, '-'), '-')"/>
				</xsl:call-template>
			</select>
			<xsl:text> / </xsl:text>
			<select name="{$year}">
				<xsl:call-template name="dateFormLoop">
					<xsl:with-param name="begin" select="$min-year"/>
					<xsl:with-param name="end" select="$max-year"/>
					<xsl:with-param name="value" select="substring-before($date, '-')"/>
				</xsl:call-template>
			</select>
			<xsl:if test="contains($type, 'time')">
				<xsl:text> , </xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:if test="contains($type, 'time')">
			<select name="{$hour}">
				<xsl:call-template name="dateFormLoop">
					<xsl:with-param name="begin" select="0"/>
					<xsl:with-param name="end" select="23"/>
					<xsl:with-param name="value" select="substring($date, 12, 2)"/>
				</xsl:call-template>
			</select>
			<xsl:text> : </xsl:text>
			<select name="{$minute}">
				<xsl:call-template name="dateFormLoop">
					<xsl:with-param name="begin" select="0"/>
					<xsl:with-param name="end" select="59"/>
					<xsl:with-param name="value" select="substring($date, 15, 2)"/>
				</xsl:call-template>
			</select>
			<xsl:if test="$second">
				<xsl:text> . </xsl:text>
				<select name="{$second}">
					<xsl:call-template name="dateFormLoop">
						<xsl:with-param name="begin" select="0"/>
						<xsl:with-param name="end" select="59"/>
						<xsl:with-param name="value" select="substring($date, 15, 2)"/>
					</xsl:call-template>
				</select>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="dateFormLoop">
		<xsl:param name="begin"/>
		<xsl:param name="end"/>
		<xsl:param name="value"/>
		<option value="{$begin}">
			<xsl:if test="$begin = $value">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$begin"/>
		</option>
		<xsl:if test="$begin &lt; $end">
			<xsl:call-template name="dateFormLoop">
				<xsl:with-param name="begin" select="$begin + 1"/>
				<xsl:with-param name="end" select="$end"/>
				<xsl:with-param name="value" select="$value"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>