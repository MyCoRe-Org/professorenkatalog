<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions" exclude-result-prefixes="mods mcrxsl">
  <xsl:import href="xslImport:solr-document:profkat-solr.xsl" />

  <xsl:template match="mycoreobject">
    <xsl:param name="foo" />
    <xsl:apply-imports />
    <!-- fields from mycore-mods -->
    <xsl:apply-templates select="metadata"/>
    <field name="hasFiles">
      <xsl:value-of select="count(structure/derobjects/derobject)&gt;0" />
    </field>
  </xsl:template>

  <xsl:template match="metadata">
    <xsl:apply-imports/>
    <xsl:variable name="headline" select="concat(box.surname/surname,', ', box.firstname/firstname[1])" />
    <field name="profkat_idx_profkat">
    	<xsl:value-of select="$headline" />
    </field>
    <field name="profkat_idx_profkat_facet">
    	<!--  There is no replace in XSLT 1.0 !!! -->
    	<xsl:variable name="headline_normiert" select="translate($headline, 'äöüß', 'aous')" />
    	<xsl:choose>
    		<xsl:when test="starts-with($headline_normiert, 'Sch')"><xsl:value-of select="substring($headline_normiert,1,4)" /></xsl:when>
    		<xsl:when test="starts-with($headline_normiert, 'St')"><xsl:value-of select="substring($headline_normiert,1,3)" /></xsl:when>
    		<xsl:otherwise><xsl:value-of select="substring($headline_normiert,1,2)" /></xsl:otherwise>
    	</xsl:choose>
    </field>
    <field name="profkat_period"><xsl:value-of select="box.period/period/text" /></field>
    <field name="profkat_last_professorship"><xsl:value-of select="box.professorship/professorship[last()]/event" /></field>
    	<xsl:for-each select="box.faculty/faculty[last()]/classification">
    <field name="profkat_last_faculty_class"><xsl:value-of select="@classid" />:<xsl:value-of select="@categid" /></field>
    </xsl:for-each>
    <field name="profkat_status_msg">OMD.CPR.states.<xsl:value-of select="box.status/status" /></field>
    
    <xsl:for-each select="box.identifier/identifier[@type='gnd' or @type='pnd']">
    	<field name="gnd_uri">http://d-nb.info/gnd/<xsl:value-of select="." /></field>
    </xsl:for-each>
    
  </xsl:template>
</xsl:stylesheet>