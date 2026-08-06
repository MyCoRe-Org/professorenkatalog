<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:import href="xslImport:workspace-object-display:profkat/workspace/default-object-display.xsl" />
  <xsl:import href="resource:xslt/functions/i18n.xsl" />

  <xsl:param name="CurrentLang" />
  <xsl:param name="DefaultLang" />

  <xsl:template match="/mycoreobject">
    <h4 class="mt-0">
      <xsl:value-of select="mcri18n:translate('WF.common.newObject')" />
    </h4>
  </xsl:template>

</xsl:stylesheet>
