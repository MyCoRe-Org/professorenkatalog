<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:import href="xslImport:workspace-title:profkat/workspace/person-object-header.xsl" />

  <xsl:template match="/mycoreobject[contains(@ID, '_person_') and metadata/box.surname/surname]">
    <xsl:variable name="surname" select="(metadata/box.surname/surname)[1]" />
    <xsl:variable name="firstname" select="(metadata/box.firstname/firstname)[1]" />
    <xsl:variable name="birth" select="(metadata/box.birth/birth/text[@xml:lang='de'])[1]" />
    <xsl:variable name="death" select="(metadata/box.death/death/text[@xml:lang='de'])[1]" />
    <xsl:variable name="dates" as="xs:string*" select="
      if ($birth) then concat('* ', $birth) else (),
      if ($death) then concat('✝ ', $death) else ()
    " />

    <h4>
      <xsl:value-of select="normalize-space(string-join(($firstname, $surname), ' '))" />
    </h4>
    <xsl:value-of select="string-join($dates, '&#160;&#160;&#160;')" />
  </xsl:template>

</xsl:stylesheet>
