<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:mcracl="http://www.mycore.de/xslt/acl"
  xmlns:mcrclass="http://www.mycore.de/xslt/classification"
  
  exclude-result-prefixes="xlink mcri18n mcracl fn"
  expand-text="yes">
  <xsl:import href="resource:xsl/functions/i18n.xsl" />
  <xsl:import href="resource:xsl/functions/classification.xsl" />
  <xsl:import href="resource:xsl/docdetails/docdetails.xsl" />
  <xsl:import href="resource:xsl/profkat/docdetails/profkat_util.xsl" />
  
  <xsl:output method="html" indent="yes" standalone="no" encoding="UTF-8"/>

  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="CurrentLang" />
  <xsl:param name="DefaultLang" />

  <xsl:template match="/mycoreobject">
    <xsl:variable name="project" select="substring-before(@ID, '_')" />
    <div class="row">
      <div id="docdetails-data" class="col">
        <xsl:if test="./metadata/box.faculty">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'faculties'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.faculties'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="/mycoreobject/metadata/box.faculty/faculty">
                <tr>
                  <td>{./text}</td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$project='cpr'">
                        <xsl:value-of select="document(concat('classification:metadata:0:children:',classification/@classid,':', classification/@categid))//category/label[@xml:lang='x-de-short']/@text" />
                      </xsl:when>
                      <xsl:otherwise>
                       <xsl:value-of select="mcrclass:current-label-text(./classification)" />
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="./event">
                      <br />
                      {./event}
                    </xsl:if>  
                  </td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.institute">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'institutes'"/>
            <xsl:with-param name="css_class" select="if (./institute/time) then ('col2') else ('col1')"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.institutes'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="/mycoreobject/metadata/box.institute/institute">
                <tr>
                  <xsl:if test="./time">
                    <td>{./time}</td>
                  </xsl:if>
                  <td>{./text}</td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.fieldofstudy">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'fieldofstudy'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.fieldofstudies'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="/mycoreobject/metadata/box.fieldofstudy/fieldofstudy">
                <tr>
                    <td>{.}</td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
       <xsl:if test="./metadata/box.subjectclass">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'subjects'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.subjects'"/>
            <xsl:with-param name="items">
            <xsl:for-each select="/mycoreobject/metadata/box.subjectclass/subjectclass">
               <tr>
                 <td><xsl:value-of select="mcrclass:current-label-text(.)" /></td>
               </tr>
             </xsl:for-each> 
           </xsl:with-param>
         </xsl:call-template>
       </xsl:if>
       
      <xsl:call-template name="dd_separator" />
       
      <xsl:if test="./metadata/box.email/email and not(project='cpb')">
       <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'emails'"/>
            <xsl:with-param name="showInfo" select="false()"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.emails'"/>
            <xsl:with-param name="items">
            <xsl:for-each select="/mycoreobject/metadata/box.email/email">
               <tr>
                 <td>
                   <xsl:variable name="email" select="." />
                   <span style="direction: rtl; unicode-bidi: bidi-override;text-align: left;">
                      {codepoints-to-string(reverse(string-to-codepoints(replace($email, '@', ')at('))))}
                   </span>
                 </td>
               </tr>
             </xsl:for-each> 
           </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
     
        <xsl:if test="./metadata/box.homepage/homepage">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'homepage'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.homepages'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="/mycoreobject/metadata/box.homepage/homepage">
                <tr>
                  <td>
                    <xsl:call-template name="pk_link">
                      <xsl:with-param name="href" select="./@xlink:href" />
                      <xsl:with-param name="title" select="./@xlink:title" />
                      <xsl:with-param name="project" select="$project"  />
                    </xsl:call-template>
                  </td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>     
     
        <xsl:call-template name="dd_separator" />  
       
      </div>
    </div>
       
  </xsl:template>

</xsl:stylesheet>