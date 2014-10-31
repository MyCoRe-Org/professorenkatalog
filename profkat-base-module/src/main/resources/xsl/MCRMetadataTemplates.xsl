<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================== -->
<!-- $Revision: 1.2 $ $Date: 2007-04-16 12:04:31 $ -->
<!-- ============================================== -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd='http://www.w3.org/2001/XMLSchema'
  version="1.0">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<!-- Template for the application dependendent metadata -->



<!-- Template for the metadata MCRMetaHistoryEvent -->
<xsl:template match="mcrmetahistoryevent">
<xsd:sequence>
 <xsd:element name="{@name}" minOccurs="{@minOccurs}" maxOccurs="{@maxOccurs}">
  <xsd:complexType>
   <xsd:sequence>
   <xsd:choice minOccurs="1" maxOccurs="20">
     <xsd:element name="text" minOccurs="1" maxOccurs="unbounded" >
     <xsd:complexType>
      <xsd:simpleContent>
       <xsd:extension base="xsd:string">
        <xsd:attribute ref="xml:lang" use="optional" />
       </xsd:extension>
      </xsd:simpleContent>
     </xsd:complexType>
	</xsd:element>
    <xsd:element name="calendar"  type="xsd:string" minOccurs='0' maxOccurs='1'/>
    <xsd:element name="ivon"  type="xsd:integer" minOccurs='0' maxOccurs='1'/>
    <xsd:element name="von"  type="xsd:string" minOccurs='0' maxOccurs='1'/>
    <xsd:element name="ibis"  type="xsd:integer" minOccurs='0' maxOccurs='1'/>
    <xsd:element name="bis"  type="xsd:string" minOccurs='0' maxOccurs='1'/>
    <xsd:element name="event"  type="xsd:string" minOccurs='0' maxOccurs='1'/>
   	<!-- copied from MCRMetadataCoreTemplates -->
    <xsd:element name="classification" minOccurs='0' maxOccurs='1'>
    	<xsd:complexType>
		    <xsd:attribute name="classid" use="required" type="mcrobjectid" />
     		<xsd:attribute name="categid" use="required" type="mcrcategory" />
    		 <xsd:attribute name="type" use="optional" type="mcrdefaulttype" />
     		<xsd:attribute name="inherited" use="optional" type="xsd:integer" />
     		<xsd:attribute ref="xml:lang" use="optional" />
	  </xsd:complexType>
    </xsd:element>
    </xsd:choice> 
   </xsd:sequence>
   <xsd:attribute name="type" use="optional" type="xsd:string" />
   <xsd:attribute name="inherited" use="optional" type="xsd:integer" />
   <xsd:attribute ref="xml:lang" />
  
  </xsd:complexType>
 </xsd:element>
</xsd:sequence>
<xsd:attribute name="class" type="xsd:string" use="required"
  fixed="MCRMetaHistoryEvent"/>
</xsl:template>

</xsl:stylesheet>

