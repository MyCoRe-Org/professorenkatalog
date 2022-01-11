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
        
        <xsl:if test="./metadata/box.surname/surname[position()>1] | ./metadata/box.variantname/variantname">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'variantnames'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.variantnames'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="/mycoreobject/metadata/box.surname/surname[position()>1] | /mycoreobject/metadata/box.variantname/variantname">
                <tr>
                  <td>{.}</td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>  
       
        <xsl:if test="./metadata/box.firstname/firstname[position()>1]">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'variantnames'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.firstnames'"/>
            <xsl:with-param name="showInfo" select="false()"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.firstname/firstname[position()>1]">
                <tr>
                  <td>{.}</td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
       <xsl:if test="./metadata/box.birth/birth|/mycoreobject/metadata/box.death/death">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'birth_death'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.lifetimes'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="(./metadata/box.birth/birth|./metadata/box.death/death)[1]">
                <xsl:variable name="birth_type" select="local-name(./../../box.birth/birth)" />
                <xsl:variable name="birth_place" select="string(./../../box.birth/birth/event)" />
                <xsl:variable name="birth_date" select="string(./../../box.birth/birth/text)" />
                <xsl:variable name="death_type" select="local-name(./../../box.death/death)" />
                <xsl:variable name="death_place" select="string(./../../box.death/death/event)" />
                <xsl:variable name="death_date" select="string(./../../box.death/death/text)" />
                <xsl:if test="$birth_type">
                  <tr>
                    <td>{mcri18n:translate('OMD.common.born')}
                      <xsl:if test="$birth_date and not($birth_date = '#')">
                        <xsl:if test="contains($birth_date, '.')">
                          {mcri18n:translate('OMD.common.at')}
                        </xsl:if>  
                        {$birth_date}
                      </xsl:if>
                      <xsl:if test="$birth_place and not($birth_place = '#')">
                        {mcri18n:translate('OMD.common.in')}
                        {$birth_place}
                      </xsl:if>
                    </td>
                  </tr>
                </xsl:if>
                <xsl:if test="$death_type">
                  <tr>
                    <td>
                      {mcri18n:translate('OMD.common.died')}
                      <xsl:if test="$death_date and not($death_date = '#')">
                        <xsl:if test="contains($death_date, '.')">
                           {mcri18n:translate('OMD.common.at')}
                        </xsl:if>
                        {$death_date}
                      </xsl:if>
                      <xsl:if test="$death_place and not($death_place = '#')">
                        {mcri18n:translate('OMD.common.in')}
                        {$death_place}
                      </xsl:if>
                    </td>
                  </tr>
                </xsl:if>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.confession/confession">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'confession'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.confessions'"/>
            <xsl:with-param name="showInfo" select="false()"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.confession/confession">
                <tr>
                  <td>{.}</td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.family/family">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'family'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.families'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.family/family">
                <tr>
                  <td>{mcri18n:translate(concat('OMD.profkat.family.',./@type))}:</td>
                  <td>
                    <xsl:variable name="name" select="./name/text()" />
                    <xsl:variable name="profession" select="./profession" />
                    <xsl:variable name="url" select="./name/@id"/>
                    <xsl:variable name="output">
                         <xsl:if test="string-length($name) &gt; 1">
                           {$name}
                         </xsl:if>
                        <xsl:if test="string-length($profession) &gt; 1">
                          ,&#160;
                          {$profession}
                      </xsl:if>
                    </xsl:variable>
                    
                    <xsl:choose>
                      <xsl:when test="string-length($url) &lt;=1">
                        <xsl:variable name="output">
                          <xsl:if test="string-length($name) &gt; 1">
                             {$name}
                          </xsl:if>
                          <xsl:if test="string-length($profession) &gt; 1">
                             ,&#160;
                             {$profession}
                          </xsl:if>
                        </xsl:variable>
                        <xsl:value-of select="normalize-space($output)" disable-output-escaping="true" />
                      </xsl:when>
                      <xsl:when test="$project='cpb'">
                        <a href="{$url}" target="_blank">
                          <xsl:value-of select="normalize-space($output)" disable-output-escaping="true" />
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="normalize-space($output)" disable-output-escaping="true" />
                        <a href="{$url}" target="_blank">
                          <nobr> ({mcri18n:translate('OMD.profkat.link.external')}
                                 <img src="${WebApplicationBaseURL}images/link_extern.png" alt="Link" />)</nobr>
                       </a>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:call-template name="dd_separator" />
        
        <xsl:if test="./metadata/box.biographic/biographic">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'biographic'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.biographics'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.biographic/biographic">
                <tr>
                  <td>{./time}</td>
                  <td><xsl:value-of select="./text" disable-output-escaping="true" /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.academicdegree/academicdegree">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'biographic'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.academicdegrees'"/>
            <xsl:with-param name="css_class" select="'col3'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.academicdegree/academicdegree">
                <tr>
                  <td>{mcri18n:translate(concat('OMD.profkat.academicdegree.display.', ./@type))}</td>
                  <td>{./time}</td>
                  <td>
                    <xsl:value-of select="./text" disable-output-escaping="true" />
                    <xsl:if test="./dissertation and string-length(./dissertation) &gt; 1">
                      <br />
                      <i>
                        {mcri18n:translate('OMD.profkat.dissertationTitle')}:&#160;</i>
                        <xsl:value-of select="./dissertation" disable-output-escaping="true" />
                    </xsl:if>
                  </td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      
        <xsl:call-template name="dd_separator" />
      
        <xsl:if test="./metadata/box.adminfunction/adminfunction">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'adminfunction'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.adminfunctions'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.adminfunction/adminfunction">
                <tr>
                  <td>{./time}</td>
                  <td><xsl:value-of select="./text" disable-output-escaping="true" /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="./metadata/box.otherfunction/otherfunction">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'otherfunction'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.otherfunctions'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.otherfunction/otherfunction">
                <tr>
                  <td>{./time}</td>
                  <td><xsl:value-of select="./text" disable-output-escaping="true" /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
            
        <xsl:if test="./metadata/box.membership/membership[@type='scientific']">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'scientific_membership'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.scientific_memberships'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.membership/membership[@type='scientific']">
                <tr>
                  <td>{./time}</td>
                  <td><xsl:value-of select="./text" disable-output-escaping="true" /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.membership/membership[not(@type='party') and not(@type='scientific')]">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'other_membership'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.other_memberships'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.membership/membership[not(@type='party') and not(@type='scientific')]">
                <tr>
                  <td>{./time}</td>
                  <td><xsl:value-of select="./text" disable-output-escaping="true" /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="./metadata/box.award/award">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'award'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.awards'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.award/award">
                <tr>
                  <td>{./time}</td>
                  <td><xsl:value-of select="./text" disable-output-escaping="true" /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.partymember/partymember">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'partymember'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.partymembers'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.partymember/partymember">
                <tr>
                  <td>{./time}</td>
                  <td><xsl:value-of select="./text" disable-output-escaping="true" /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.otherinfo/otherinfo">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'otherinfo'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.otherinfos'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.otherinfo/otherinfo">
                <tr>
                  <td><xsl:value-of select="." disable-output-escaping="true" /></td>
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