<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  exclude-result-prefixes="mcrxsl">

  <xsl:include href="copynodes.xsl" />

  <xsl:template match="//*[@class='MCRMetaHistoryDate' or @class='MCRMetaHistoryEvent']/*">
    <xsl:copy>

      <xsl:copy-of select="text" />
      <xsl:copy-of select="calendar" />
      <xsl:copy-of select="ivon" />
      <xsl:copy-of select="von" />
      <xsl:if test="not(von)">
        <xsl:if test="(string-length(text[@xml:lang='de']) = 4 and translate(text[@xml:lang='de'], '0123456789', '') = '')">
          <von>01.01.<xsl:value-of select="text[@xml:lang='de']" /> AD</von>
        </xsl:if>
        <xsl:if test="(string-length(text[@xml:lang='de']) = 10 and translate(text[@xml:lang='de'], '0123456789', '') = '..')">
          <von><xsl:value-of select="text[@xml:lang='de']" /> AD</von>
        </xsl:if>
        <xsl:if test="(string-length(text[@xml:lang='de']) = 9 and translate(text[@xml:lang='de'], '0123456789', '') = '-')">
          <von>01.01.<xsl:value-of select="substring(text[@xml:lang='de'],1,4)" /> AD</von>
        </xsl:if>
      </xsl:if>
      <xsl:copy-of select="ibis" />
      <xsl:copy-of select="bis" />
      <xsl:if test="not(bis)">
        <xsl:if test="(string-length(text[@xml:lang='de']) = 4 and translate(text[@xml:lang='de'], '0123456789', '') = '')">
          <bis>31.12.<xsl:value-of select="text[@xml:lang='de']" /> AD</bis>
        </xsl:if>
        <xsl:if test="(string-length(text[@xml:lang='de']) = 10 and translate(text[@xml:lang='de'], '0123456789', '') = '..')">
          <bis><xsl:value-of select="text[@xml:lang='de']" /> AD</bis>
        </xsl:if>
        <xsl:if test="(string-length(text[@xml:lang='de']) = 9 and translate(text[@xml:lang='de'], '0123456789', '') = '-')">
          <bis>31.12.<xsl:value-of select="substring(text[@xml:lang='de'],6,4)" /> AD</bis>
        </xsl:if>
      </xsl:if>
      <xsl:copy-of select="event" />
      <xsl:copy-of select="classification" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>