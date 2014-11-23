<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:xalan="http://xml.apache.org/xalan">
  <xsl:template match="element[@type='historyevent']" mode="metadata">
    <xsl:apply-templates select="." mode="enclosing">
      <xsl:with-param name="class" select="'MCRMetaHistoryEvent'" />
    </xsl:apply-templates>
    <xsl:variable name="innerSchema">
      <xs:sequence>
        <xs:element maxOccurs="unbounded" minOccurs="1" name="text">
          <xs:complexType>
            <xs:simpleContent>
              <xs:extension base="xs:string">
                <xs:attribute use="optional" ref="xml:lang" />
              </xs:extension>
            </xs:simpleContent>
          </xs:complexType>
        </xs:element>
        <xs:element maxOccurs="1" minOccurs="0" type="xs:string" name="calendar" />
        <xs:element maxOccurs="1" minOccurs="0" type="xs:integer" name="ivon" />
        <xs:element maxOccurs="1" minOccurs="0" type="xs:string" name="von" />
        <xs:element maxOccurs="1" minOccurs="0" type="xs:integer" name="ibis" />
        <xs:element maxOccurs="1" minOccurs="0" type="xs:string" name="bis" />
        <xs:element maxOccurs="1" minOccurs="0" type="xs:string" name="event" />
        <xs:element maxOccurs="1" minOccurs="0" name="classification">
    	  <xs:complexType>
		    <xs:attribute name="type" type="xs:string" />
            <xs:attributeGroup ref="MCRMetaClassification" />
	  	  </xs:complexType>
	  	</xs:element>
      </xs:sequence>
    </xsl:variable>
    <xsl:apply-templates select="." mode="inner">
      <xsl:with-param name="class" select="'MCRMetaHistoryDate'" />
      <xsl:with-param name="complexType" select="xalan:nodeset($innerSchema)/*" />
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>