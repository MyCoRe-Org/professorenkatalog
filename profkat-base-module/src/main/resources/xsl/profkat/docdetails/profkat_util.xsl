<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:mcracl="http://www.mycore.de/xslt/acl"
  
  exclude-result-prefixes="xlink mcri18n mcracl fn"
  expand-text="yes">
  
  <xsl:import href="resource:xsl/functions/i18n.xsl" />
  <xsl:import href="resource:xsl/docdetails/docdetails.xsl" />
  <xsl:output method="html" indent="yes" standalone="no" encoding="UTF-8"/>

  <xsl:param name="WebApplicationBaseURL"></xsl:param>
  
  
  <xsl:template name="pk_link">
    <xsl:param name="href" />
    <xsl:param name="title" />
    <xsl:param name="project" />
  
    <xsl:variable name="vTitle" select = "if($title='#') then ('') else ($title)" />
    
    <xsl:choose>
      <xsl:when test="$href='#'">
        {$vTitle}
      </xsl:when>
      <xsl:when test="$project='cpr'">
        <xsl:value-of select="$vTitle" disable-output-escaping="yes"/>
        <a href="{$href}" target="_blank">
          <xsl:choose>
            <xsl:when test="contains($href, 'rosdok')">
              <nobr>({mcri18n:translate('OMD.profkat.link.internal')}
                    <img src="{$WebApplicationBaseURL}images/link_intern.png"
                        alt="interner Link" />)</nobr>
            </xsl:when>
            <xsl:otherwise>
              <nobr> ({mcri18n:translate('OMD.profkat.link.external')}
                    <img src="{$WebApplicationBaseURL}images/link_extern.png"
                    alt="externer Link" />)</nobr>
            </xsl:otherwise>
        </xsl:choose> 
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$href}" target="_blank">
          <xsl:value-of select="$vTitle" disable-output-escaping="yes"/>
        </a>  
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>  