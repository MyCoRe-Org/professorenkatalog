<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:mcracl="http://www.mycore.de/xslt/acl"
  xmlns:mcrclass="http://www.mycore.de/xslt/classification"
  xmlns:mcrstring="http://www.mycore.de/xslt/stringutils"
  
  exclude-result-prefixes="xlink mcri18n mcracl fn"
  expand-text="yes">
  <xsl:import href="resource:xsl/functions/i18n.xsl" />
  <xsl:import href="resource:xsl/functions/classification.xsl" />
  <xsl:import href="resource:xsl/functions/acl.xsl" />
  <xsl:import href="resource:xsl/docdetails/docdetails.xsl" />
  <xsl:import href="resource:xsl/functions/stringutils.xsl" />
  
  <xsl:output method="html" indent="yes" standalone="no" encoding="UTF-8"/>

  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="CurrentLang" />
  <xsl:param name="DefaultLang" />

  <xsl:template match="/mycoreobject">
    <xsl:variable name="project" select="substring-before(@ID, '_')" />
    <div class="row">
      <div id="docdetails-data" class="col">
        <xsl:if test="./structure/derobjects/derobject">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'derobject'"/>
            <xsl:with-param name="css_class" select="'col_derivates w-100'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.derobjects'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./structure/derobjects/derobject">
                <xsl:choose>
                  <xsl:when test="mcracl:check-permission(./@xlink:href, 'read')">
                    <tr>
                      <th colspan="2">{./title}</th>
                    </tr>
                    <tr> 
                      <td class="icon">
                        <xsl:variable name="fontAwesomeName">
                          <xsl:choose>
                            <xsl:when test="ends-with(lower-case(./maindoc), '.pdf')">fas fa-file-pdf</xsl:when>
                            <xsl:when test="ends-with(lower-case(./maindoc), '_sig.jpg')">fas fa-file-signature</xsl:when>
                            <xsl:when test="ends-with(lower-case(./maindoc), '_pic.jpg')">fas fa-portrait</xsl:when>
                            <xsl:when test="ends-with(lower-case(./maindoc), '.jpg') or ends-with(lower-case(./maindoc), '.jpeg')">fas fa-file-image</xsl:when>
                            <xsl:otherwise>fa fa-file-o</xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <i class="{$fontAwesomeName}"></i>
                      </td>
                      <td>
                        <xsl:variable name="fulltext_url">{$WebApplicationBaseURL}file/{/mycoreobject/@ID}/{./@xlink:href}/{./maindoc/text()}</xsl:variable>
                        <a href="{$fulltext_url}" target="_blank">{./maindoc}</a>
                        <br />
                        <span class="small d-inline-block" style="width:9em">({mcrstring:pretty-filesize(./maindoc_size)})</span> 
                        <a class="small d-inline-block" style="width:9em" 
                           download="{./maindoc}.md5" onclick="event.stopPropagation();"
                           href="data:text/plain;charset=US-ASCII,{encode-for-uri(concat(./maindoc_md5,'  ', ./maindoc))}">
                          <i class="fas fa-download"></i> MD5
                        </a>
                        <span class="small d-inline-block">
                          (<xsl:value-of select="document(concat('classification:metadata:0:children:',classification/@classid,':', classification/@categid))//category/label[@xml:lang='de']/@text" />)
                        </span>
                      </td>
                    </tr>
                  </xsl:when>
                  <xsl:otherwise>
                    <tr>
                      <td colspan="2">
                        {./title}
                      </td>
                    </tr>
                    <tr> 
                      <td class="icon"><i class="far fa-eye-slash"></i></td>
                      <td>{./maindoc/text()}</td>
                    </tr>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
