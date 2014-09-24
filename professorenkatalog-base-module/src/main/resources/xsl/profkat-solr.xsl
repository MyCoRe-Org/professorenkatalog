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
    <field name="idx_person">
    	<xsl:value-of select="concat(box.surname/surname,', ', box.firstname/firstname[1])" />
    </field>
    <field name="idx_person_data">
    	{period:<xsl:value-of select="box.period/period/text" />,last_professorship:<xsl:value-of select="box.professorship/professorship[last()]/event" />,last_faculty:<xsl:value-of select="box.faculty/faculty[last()]/classification/@categid" />,state:<xsl:value-of select="box.state/state" />}
    </field>

  </xsl:template>
</xsl:stylesheet>