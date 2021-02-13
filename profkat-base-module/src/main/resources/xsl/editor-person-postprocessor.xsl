<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  exclude-result-prefixes="mcrxsl">

  <xsl:include href="copynodes.xsl" />

  <xsl:template match="//*[@class='MCRMetaHistoryDate' or @class='MCRMetaHistoryEvent']/*">
    <xsl:copy>
      <xsl:copy-of select="text" />
      <xsl:copy-of select="calendar" />
      <xsl:copy-of select="ivon" />
      <xsl:choose>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 4 and translate(text[@xml:lang='de'], '0123456789', '') = '')">
          <von><xsl:value-of select="text[@xml:lang='de']" />-01-01 AD</von>
        </xsl:when>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 10 and translate(text[@xml:lang='de'], '0123456789', '') = '..')">
          <von><xsl:value-of select="substring(text[@xml:lang='de'],7,4)" />-<xsl:value-of select="substring(text[@xml:lang='de'],4,2)" />-<xsl:value-of select="substring(text[@xml:lang='de'],1,2)" /> AD</von>
        </xsl:when>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 9 and translate(text[@xml:lang='de'], '0123456789', '') = '-')">
          <von><xsl:value-of select="substring(text[@xml:lang='de'],1,4)" />-01-01 AD</von>
        </xsl:when>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 9 and translate(text[@xml:lang='de'], '0123456789', '') = 'seit ')">
          <von><xsl:value-of select="substring(text[@xml:lang='de'],6,4)" />-01-01 AD</von>
        </xsl:when>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 7 and translate(text[@xml:lang='de'], '0123456789', '') = 'ab ')">
          <von><xsl:value-of select="substring(text[@xml:lang='de'],4,4)" />-01-01 AD</von>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="von" />  
        </xsl:otherwise>
      </xsl:choose>
      <xsl:copy-of select="ibis" />
      <xsl:choose>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 4 and translate(text[@xml:lang='de'], '0123456789', '') = '')">
          <bis><xsl:value-of select="text[@xml:lang='de']" />-12-31 AD</bis>
        </xsl:when>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 10 and translate(text[@xml:lang='de'], '0123456789', '') = '..')">
          <bis><xsl:value-of select="substring(text[@xml:lang='de'],7,4)" />-<xsl:value-of select="substring(text[@xml:lang='de'],4,2)" />-<xsl:value-of select="substring(text[@xml:lang='de'],1,2)" /> AD</bis>
        </xsl:when>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 9 and translate(text[@xml:lang='de'], '0123456789', '') = '-')">
          <bis><xsl:value-of select="substring(text[@xml:lang='de'],6,4)" />-12-31 AD</bis>
        </xsl:when>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 9 and translate(text[@xml:lang='de'], '0123456789', '') = 'seit ')">
          <bis>4000-01-01 AD</bis>
        </xsl:when>
        <xsl:when test="(string-length(text[@xml:lang='de']) = 7 and translate(text[@xml:lang='de'], '0123456789', '') = 'ab ')">
          <bis>4000-01-01 AD</bis>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="bis" />  
        </xsl:otherwise>
      </xsl:choose>
      <xsl:copy-of select="event" />
      <xsl:copy-of select="classification" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="//*[time or dissertation or places]">
  	<xsl:copy>
    	<xsl:copy-of select="@*" />
    	<xsl:apply-templates select="time" />
    	<xsl:apply-templates select="text" />
    	<xsl:apply-templates select="dissertation" />
    	<xsl:apply-templates select="places" />   
  	</xsl:copy>
  </xsl:template>
  <xsl:template match="family">
	<xsl:copy>
    	<xsl:copy-of select="@*" />
    	<xsl:apply-templates select="name" />
    	<xsl:apply-templates select="profession" />
	</xsl:copy>
  </xsl:template>

</xsl:stylesheet>