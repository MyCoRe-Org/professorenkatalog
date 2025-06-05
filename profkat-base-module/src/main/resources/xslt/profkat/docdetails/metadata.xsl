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
  <xsl:import href="resource:xslt/functions/i18n.xsl" />
  <xsl:import href="resource:xslt/functions/classification.xsl" />
  <xsl:import href="resource:xslt/docdetails/docdetails.xsl" />
  <xsl:import href="resource:xslt/profkat/docdetails/profkat_util.xsl" />
  
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
            <xsl:with-param name="key" select="'institute'"/>
            <xsl:with-param name="css_class" select="if (./metadata/box.institute/institute/time) then ('col2') else ('col1')"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.institutes'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="/mycoreobject/metadata/box.institute/institute">
                <tr>
                  <xsl:if test="./time">
                    <td><xsl:if test="not(./time='#')">{./time}</xsl:if></td>
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
       
       <xsl:if test="./metadata/box.departure">
         <xsl:call-template name="dd_block">
           <xsl:with-param name="key" select="'departure'"/>
           <xsl:with-param name="labelkey" select="'OMD.profkat.departure'"/>
           <xsl:with-param name="items">
             <xsl:for-each select="/mycoreobject/metadata/box.departure/departure">
               <tr>
                 <td><xsl:value-of select="mcrclass:current-label-text(.)" /></td>
               </tr>
             </xsl:for-each> 
           </xsl:with-param>
         </xsl:call-template>
       </xsl:if>
       
       <xsl:call-template name="dd_separator" />
       
      <xsl:if test="./metadata/box.email/email and not($project='cpb')">
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
                <xsl:variable name="birth_date" select="string(./../../box.birth/birth/text[@xml:lang='de'])" />
                <xsl:variable name="death_type" select="local-name(./../../box.death/death)" />
                <xsl:variable name="death_place" select="string(./../../box.death/death/event)" />
                <xsl:variable name="death_date" select="string(./../../box.death/death/text[@xml:lang='de'])" />
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
                    <xsl:variable name="output" select="string-join((
                         (if (string-length($name) &gt; 1) then ($name) else ()),
                         (if (string-length($profession) &gt; 1) then ($profession) else ())
                      ), ',&#160;')">
                    </xsl:variable>
                    
                    <xsl:choose>
                      <xsl:when test="string-length($url) &lt;=1">
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
                                 <img src="{$WebApplicationBaseURL}images/link_extern.png" alt="Link" />)</nobr>
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
                  <td><xsl:if test="not(./time='#')">{./time}</xsl:if></td>
                  <td><xsl:value-of select="./text" /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.academicdegree/academicdegree">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'academicdegree'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.academicdegrees'"/>
            <xsl:with-param name="css_class" select="'col3'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.academicdegree/academicdegree">
                <tr>
                  <td>{mcri18n:translate(concat('OMD.profkat.academicdegree.display.', ./@type))}</td>
                  <td><xsl:if test="not(./time='#')">{./time}</xsl:if></td>
                  <td>
                    <xsl:value-of select="./text" />
                    <xsl:if test="./dissertation and string-length(./dissertation) &gt; 1">
                      <br />
                      <span class="docdetails-sublabel">
                        {mcri18n:translate('OMD.profkat.dissertationTitle')}:&#160;</span>
                        <xsl:value-of select="./dissertation" />
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
                  <td><xsl:if test="not(./time='#')">{./time}</xsl:if></td>
                  <td><xsl:value-of select="./text" /></td>
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
                  <td><xsl:if test="not(./time='#')">{./time}</xsl:if></td>
                  <td><xsl:value-of select="./text" /></td>
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
                  <td><xsl:if test="not(./time='#')">{./time}</xsl:if></td>
                  <td><xsl:value-of select="./text" /></td>
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
                  <td><xsl:if test="not(./time='#')">{./time}</xsl:if></td>
                  <td><xsl:value-of select="./text" /></td>
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
                  <td><xsl:if test="not(./time='#')">{./time}</xsl:if></td>
                  <td><xsl:value-of select="./text" /></td>
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
                  <td><xsl:if test="not(./time='#')">{./time}</xsl:if></td>
                  <td><xsl:value-of select="./text" /></td>
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
                  <td><xsl:value-of select="." /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:call-template name="dd_separator" />
        
        <xsl:if test="./metadata/box.mainpublication/mainpublication and not($project='cpb')">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'mainpublication'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.mainpublications'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.mainpublication/mainpublication">
                <tr>
                  <td><xsl:value-of select="." /></td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.publicationslink/publicationslink">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'bibliographicref'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.bibliographicrefs'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.publicationslink/publicationslink">
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

       <xsl:if test="./metadata/box.source/source">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'source'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.sources'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.source/source">
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
        
        <xsl:if test="./metadata/box.complexref/complexref|./metadata/box.reference/reference">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'references'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.references'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.reference/reference">
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
              
              <xsl:for-each select="./metadata/box.complexref/complexref">
                <tr>
                  <td>
                    <xsl:variable name="doc" select="document(concat('data:text/xml,',.))" />
                    <xsl:for-each select="$doc/register/werk">
                      <xsl:if test="position()>1"> <br /> </xsl:if>
                      {./@titel} {if (string-length(./band/@title)>0) then ('-') else ()}
                      <xsl:for-each select="./band">
                        <xsl:if test="position()>1">; </xsl:if>
                        {./@titel}:
                        <xsl:variable name="band" select="." />
                        <xsl:for-each select="tokenize(./@seiten, ' ')">
                          <a href="https://rosdok.uni-rostock.de/resolve/id/{$band/@docid}/image/page/{tokenize(.,'-')[1]}">S. {.}</a>{if(position()!=last()) then (', ') else ()} 
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:for-each>
                  </td>
                </tr>
              </xsl:for-each>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.identifier/identifier[@type!='nognd']">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'identifier'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.identifier'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.identifier/identifier[@type!='nognd']">
                <tr>
                  <td>{mcri18n:translate(concat('OMD.profkat.identifier.',./@type))}:</td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="@type='gnd'">
                        <a href="https://explore.gnd.network/gnd/{text()}" target="_blank">
                          <xsl:value-of select="text()" disable-output-escaping="true" />
                        </a>
                      </xsl:when>
                      <xsl:when test="@type='viaf'">
                        <a href="https://viaf.org/viaf/{text()}" target="_blank">
                          <xsl:value-of select="text()" disable-output-escaping="true" />
                        </a>
                      </xsl:when>
                      <xsl:when test="@type='orcid'">
                        <a href="https://orcid.org/{text()}" target="_blank">
                          <xsl:value-of select="text()" disable-output-escaping="true" />
                        </a>
                      </xsl:when>
                      <xsl:otherwise>                      
                        <xsl:value-of select="text()" disable-output-escaping="true" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.identifier/identifier[@type='gnd' and text()!='xxx']">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'onlineres'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.onlineres'"/>
            <xsl:with-param name="css_class" select="'w-100'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.identifier/identifier[@type='gnd' and text()!='xxx']">
                <tr>
                  <td>
                   <xsl:variable name="pnd" select="string(.)" />
                   <xsl:variable name="thispk">{if($project='cpr') then ('DE-28 ') else()}{if($project!='cph') then ('') else()}</xsl:variable>
                     <div data-entityfacts-gnd="{$pnd}" data-entityfacts-blacklist="{$thispk}"></div>
                     <div class="text-right small">
                       {mcri18n:translate('OMD.profkat.entityfacts_provided_by_DNB')}
                       <a class="btn btn-xs" href="https://hub.culturegraph.org/entityfacts/{$pnd}" title="GND EntityFacts (JSON)"><i class="fas fa-paperclip" style="color:#EFEFEF;"></i></a>
                     </div>
                     <script type="text/javascript" src="{concat($WebApplicationBaseURL,'js/profkat_entityfacts.js')}"></script>

                     <xsl:if test="$project='cpb'">
                       <div id="digibib_bs_link" class="profkat-beacon-result d-none" data-gnd="{$pnd}">
                         <ul style="list-style-position:inside">
                           <li>
                             <a target="beacon_result" href="https://leopard.tu-braunschweig.de/servlets/solr/find?condQuery={$pnd}">
                               <span id="digibib_bs_link_numfound" ></span> {mcri18n:translate('OMD.profkat.cpb.documents_in_digibib')}
                             </a>
                           </li>
                         </ul>
                       </div>
                       <script type="text/javascript">
                         $.ajax({{
                           type : "GET",
                           url : "https://publikationsserver.tu-braunschweig.de/api/v1/search?q=allMeta%3D"+$('#digibib_bs_link').attr('data-gnd') +"&amp;wt=json&amp;json.wrf=?",
                           dataType : "jsonp",
                           success : function(data) {{
                             var c = data.response.numFound;
                             if(c>0){{
                               $('#digibib_bs_link_numfound').text(c);
                               $('#digibib_bs_link').removeClass('d-none');
                             }}
                           }}
                         }});
                       </script>
                     </xsl:if>
                  </td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="./metadata/box.epoch/epoch and not($project='cpb')">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'epoch'"/>
            <xsl:with-param name="css_class" select="'col2'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.classification'"/>
            <xsl:with-param name="items">
              <xsl:for-each select="./metadata/box.epoch/epoch">
                <tr>
                  <td>
                    <xsl:if test="local-name(.)='epoch'">
                      {mcri18n:translate('OMD.profkat.epoch')}
                     </xsl:if>
                  </td>
                  <td>
                      <xsl:value-of select="mcrclass:current-label-text(.)" />
                  </td>
                </tr>
              </xsl:for-each> 
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:call-template name="dd_separator" />
        
        <xsl:if test=".">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'created_changed'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.created_changed'"/>
            <xsl:with-param name="items">
                <tr>
                  <td>
                    {format-dateTime(./service/servdates/servdate[@type='createdate'], '[D,2].[M,2].[Y]')}{
                     if(not($project='cpb')) then (concat(', ', ./service/servflags/servflag[@type='createdby'])) else()}
                     /
                    {format-dateTime(./service/servdates/servdate[@type='modifydate'], '[D,2].[M,2].[Y]')}{
                    if(not($project='cpb')) then (concat(', ', ./service/servflags/servflag[@type='modifiedby'])) else()}
                  </td>
                </tr>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <!-- RS: jetzt Zitierweise jetzt Rechts, mit Hamburg abstimmen dann Block löschen -->
        <!-- 
        <xsl:if test=". and not($project='cpb')">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'quoting'"/>
            <xsl:with-param name="labelkey" select="'OMD.profkat.quoting'"/>
            <xsl:with-param name="items">
                <tr>
                  <td>
                    <xsl:variable name="name">{./metadata/box.firstname/firstname[1]} {.//metadata/box.surname/surname[1]}</xsl:variable>
                    <xsl:variable name="url">{if ($project='cpr') 
                                              then (concat('https://purl.uni-rostock.de/cpr/', substring-after(./@ID, 'cpr_person_') )) 
                                              else (concat($WebApplicationBaseURL,'resolve/id/',./@ID))}</xsl:variable>
                    <xsl:variable name="date" select="format-date(current-date(), '[D,2].[M,2].[Y]')" />  
                    <xsl:copy-of select="parse-xml(concat('&lt;xml&gt;',mcri18n:translate-with-params('OMD.profkat.quoting.text', ($name, $url, $url,  $date)),'&lt;/xml&gt;'))" />
                  </td>
                </tr>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        -->
      </div>
    </div>

  </xsl:template>

</xsl:stylesheet>