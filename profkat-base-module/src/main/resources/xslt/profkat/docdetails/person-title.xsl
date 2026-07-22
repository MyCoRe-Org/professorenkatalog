<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:import href="xslImport:docdetails-title:profkat/docdetails/person-title.xsl" />

  <xsl:template match="/mycoreobject[contains(@ID, '_person_') and metadata/box.surname/surname or metadata/box.firstname/firstname]">
    <xsl:variable name="surname" select="(metadata/box.surname/surname)[1]" />
    <xsl:variable name="firstname" select="(metadata/box.firstname/firstname)[1]" />
    <xsl:variable name="affix" select="(metadata/box.nameaffix/nameaffix)[1]" />

    <xsl:variable name="name" as="xs:string" select="
      string-join(($surname, if ($firstname) then concat(', ', $firstname) else ()), '')
    " />

    <xsl:value-of select="
      if ($affix)
      then concat($name, ' (', $affix, ')')
      else $name
    " />
  </xsl:template>

</xsl:stylesheet>
