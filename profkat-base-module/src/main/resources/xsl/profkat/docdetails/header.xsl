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

  <xsl:template match="/mycoreobject">
    <div class="row">
      <div id="docdetails-header" class="col">
        <xsl:variable name="last" select="./metadata/box.surname/surname[1]" />
        <xsl:variable name="first" select="./metadata/box.firstname/firstname[1]" />
        <xsl:variable name="affix" select="./metadata/box.nameaffix/nameaffix[1]" />
        <xsl:variable name="akadtitle" select="./metadata/box.academictitle/academictitle" />
        
        <h2>
          {$last},&#160;{$first}
          <xsl:if test="fn:string-length(affix)>1">({$affix})</xsl:if>
        </h2>
        <div id="docdetails-academictitle" class="docdetails-block">
          {if (fn:string-length($akadtitle)>2) then $akadtitle else '&#160;'}
        </div>
     
        <xsl:call-template name="dd_block">
          <xsl:with-param name="key" select="'professorships'"/>
          <xsl:with-param name="showInfo" select="false()"/>
          <xsl:with-param name="css_class" select="'col2 font-weight-bold w-100'"/>
          <xsl:with-param name="items">
            <xsl:for-each select="/mycoreobject/metadata/box.professorship/professorship">
              <tr>
                <td>{./text[@xml:lang='de']}</td>
                <td>{./event}</td>
                <td class="profkat-prev-next">
                  <div style="text-align: right; white-space: nowrap; font-size:80%;">
                   <!-- TODO Trennzeichen bei mehreren Vorgängern / Nachfolgern prüfen alter Code: delims=":;|" -->
                    <xsl:for-each select="tokenize(./text[@xml:lang='x-predec']/text(),'\|')">
                      <xsl:if test="contains(., '_person_')">
                        <xsl:variable name="linked" select="document(concat('mcrobject:',.))" />
                        <xsl:if test="$linked">
                            <xsl:variable name="doctitle">
                              {mcri18n:translate('OMD.profkat.hint.predec')}:
                              {$linked/mycoreobject/metadata/box.surname/surname[1]},&#160;
                              {$linked/mycoreobject/metadata/box.firstname/firstname[1]}
                              {if(string-length($linked/mycoreobject/metadata/box.nameaffix/nameaffix)>1) 
                                 then ($linked/mycoreobject/metadata/box.nameaffix/nameaffix[1])
                                 else ()}
                            </xsl:variable>
                            <a href="{$WebApplicationBaseURL}resolve/id/{.}" style="color:grey;margin-left:6px">
                               <i class="fas fa-backward" title="{normalize-space($doctitle)}"></i>
                             </a>
                        </xsl:if>
                      </xsl:if>
                   </xsl:for-each>

                  <xsl:for-each select="tokenize(./text[@xml:lang='x-succ']/text(),'\|')">
                    <xsl:if test="contains(., '_person_')">
                      <xsl:variable name="linked" select="document(concat('mcrobject:',.))" />
                      <xsl:if test="$linked">
                        <xsl:variable name="doctitle">
                          {mcri18n:translate('OMD.profkat.hint.succ')}:
                          {$linked/mycoreobject/metadata/box.surname/surname[1]},&#160;
                          {$linked/mycoreobject/metadata/box.firstname/firstname[1]}
                          {if(string-length($linked/mycoreobject/metadata/box.nameaffix/nameaffix)>1) 
                           then ($linked/mycoreobject/metadata/box.nameaffix/nameaffix[1])
                           else ()}
                        </xsl:variable>
                        <a href="{$WebApplicationBaseURL}resolve/id/{.}" style="color:grey;margin-left:6px">
                          <i class="fas fa-forward" title="{normalize-space($doctitle)}"></i>
                        </a>
                      </xsl:if>
                    </xsl:if>
                  </xsl:for-each>
                </div>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:with-param>
        </xsl:call-template>
        <xsl:if test="/mycoreobject/metadata/box.professorship/professorship/text[@xml:lang='x-succ' or @xml:lang='x-predec']">
          <div id="docdetails-label-predec_succ" class="text-right text-nowrap">
            <span class="docdetails-label">{mcri18n:translate('OMD.profkat.professorships.predec_succ')}</span>
          </div>
        </xsl:if> 
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
