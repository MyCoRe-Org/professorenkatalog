<?xml version="1.0"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mcrmods="http://www.mycore.de/xslt/mods"
                exclude-result-prefixes="mods fn xs">
                
<!--                 
BUG SOLR-Dependencies
mycore-solr/../mycoreobject-dynamicfields-3.xsl enthält Abhängigkeit zu xsl/functions/mods.xsl (in mycore-mods)
- temporär: leeres xsl/functions/mods.xsl in profkat-base
-->                
                
  <xsl:function name="mcrmods:is-supported" as="xs:boolean">
    <xsl:param name="node" as="element()"/>
    
    <xsl:sequence select="false()"/>
  </xsl:function>
  
  <xsl:function name="mcrmods:to-mycoreclass" as="element()?">
    <xsl:param name="node" as="element()"/>
    <xsl:param name="mode" as="xs:string"/>
    
    <xsl:sequence select="()" />
  </xsl:function>
  
</xsl:stylesheet>
