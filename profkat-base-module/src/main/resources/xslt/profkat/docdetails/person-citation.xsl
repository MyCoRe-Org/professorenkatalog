<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:import href="xslImport:docdetails-citation:profkat/docdetails/person-citation.xsl" />
  <xsl:import href="resource:xslt/functions/i18n.xsl" />

  <xsl:param name="CurrentLang" />
  <xsl:param name="DefaultLang" />
  <xsl:param name="WebApplicationBaseURL" />

  <xsl:template match="/mycoreobject[contains(@ID, '_person_')]">
    <div id="citation" class="ir-box ir-box-emph py-2 profkat-citation">
      <h5>
        <xsl:value-of select="mcri18n:translate('OMD.profkat.quoting') || ':'" />
      </h5>
      <xsl:variable name="name" select="
        normalize-space(string-join((metadata/box.firstname/firstname, metadata/box.surname/surname), ' '))
      " />
      <xsl:variable name="url" as="xs:string" select="
        if (starts-with(@ID, 'cpr_'))
        then 'https://purl.uni-rostock.de/cpr/' || substring-after(mcrid, 'cpr_person_')
        else $WebApplicationBaseURL || 'resolve/id/' || @ID
      " />
      <xsl:variable name="now" select="format-date(current-date(), '[D01].[M01].[Y0001]')" />

      <xsl:value-of select="mcri18n:translate-with-params('OMD.profkat.quoting.text.1', $name)" />
      <br />
      <xsl:value-of select="mcri18n:translate('OMD.profkat.quoting.text.2') ||  ' '" />
      <a href="{$url}">
        <xsl:value-of select="$url" />
      </a>
      <xsl:value-of select="' ' || mcri18n:translate-with-params('OMD.profkat.quoting.text.3', $now)" />
    </div>
  </xsl:template>

</xsl:stylesheet>
