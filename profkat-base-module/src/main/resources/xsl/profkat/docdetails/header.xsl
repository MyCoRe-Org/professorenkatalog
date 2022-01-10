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
  
  
  </xsl:template>

</xsl:stylesheet>