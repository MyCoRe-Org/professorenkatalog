<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mods="http://www.loc.gov/mods/v3" 
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:mcracl="http://www.mycore.de/xslt/acl"
  exclude-result-prefixes="mods xlink mcri18n mcracl"
  expand-text="yes">
 
  <xsl:import href="resource:xsl/functions/i18n.xsl" />
  <xsl:output method="html" indent="yes" standalone="no" encoding="UTF-8"/>

  <xsl:param name="WebApplicationBaseURL"></xsl:param>
  <xsl:template match="/mycoreobject">
  
    <p><xsl:value-of select="./metadata/box.academictitle/academictitle"/></p>
    <p> * <xsl:value-of select="./metadata/box.birth/birth/text[@xml:lang='de']" />
       &#160;&#160;&#160; &#10013; <xsl:value-of select="./metadata/box.death/death/text[@xml:lang='de']" />
    </p>
  </xsl:template>

</xsl:stylesheet>