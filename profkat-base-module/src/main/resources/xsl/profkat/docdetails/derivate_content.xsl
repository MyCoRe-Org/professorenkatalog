<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:mcracl="http://www.mycore.de/xslt/acl"
  xmlns:mcrclass="http://www.mycore.de/xslt/classification"
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"

  exclude-result-prefixes="xlink mcri18n mcracl fn"
  expand-text="yes">

  <xsl:import href="resource:xsl/functions/acl.xsl" />
  <xsl:import href="resource:xsl/functions/classification.xsl" />
  <xsl:import href="resource:xsl/functions/i18n.xsl" />
  <xsl:import href="resource:xsl/docdetails/docdetails.xsl" />

  <xsl:output method="html" indent="yes" standalone="no" encoding="UTF-8"/>

  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="CurrentLang" />
  <xsl:param name="DefaultLang" />

  <xsl:template match="/mycoreobject">
    <div class="row">
      <div class="col docdetails-content">
        <xsl:if test="./structure/derobjects/derobject">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'derobject_content'"/>
            <xsl:with-param name="css_class" select="'col_derivates w-100'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.documents'"/>
            <xsl:with-param name="items">
              <xsl:for-each select = "./structure/derobjects/derobject[classification[@classid='derivate_types'][@categid='display_biography']]">
              <tr>
                <td>
                  <xsl:if test="mcracl:check-permission(./@xlink:href, 'read')">
                    <xsl:variable name="url">{$WebApplicationBaseURL}file/{/mycoreobject/@ID}/{./@xlink:href}/{./maindoc}</xsl:variable>
                    <xsl:if test="ends-with(lower-case(./maindoc), '.jpeg') or ends-with(lower-case(./maindoc), '.jpg')">
                      <a href="{$url}" target="_blank" title="{mcri18n:translate('OMD.showLargerImage')}" alt="{mcri18n:translate('OMD.showLargerImage')}">
                       <img src="{$url}" width="100%" />
                      </a>
                      <span class="docdetails-content-citation">{./title}</span>
                    </xsl:if>
                    <xsl:if test="ends-with(lower-case(./maindoc), '.html') or ends-with(lower-case(./maindoc), '.htm')">
                      <xsl:variable name="text" select="document($url)"/>
                      <xsl:choose>
                        <xsl:when test="$text//xhtml:body">
                          <xsl:copy-of select="$text//xhtml:body/*" />
                         </xsl:when>
                         <xsl:otherwise>
                           <xsl:copy-of select="$text" />
                         </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:if>
                </td>
              </tr>
              </xsl:for-each>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
