<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:encoder="xalan://java.net.URLEncoder"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  exclude-result-prefixes="xsl xalan i18n">
	<xsl:output method="text" encoding="UTF-8" />
	<xsl:template match="metadata">
		<xsl:variable name="output">
		<xsl:value-of select="box.academictitle/academictitle" /> 
	<xsl:if test="not(box.epoch/epoch[@categid='cpr.1945-1989']) and not(box.epoch/epoch[@categid='cpr.1989-heute'])">
	      <xsl:if test="box.birth/birth">
      		<xsl:text> / geb. </xsl:text>
      		<xsl:if test="not(box.birth/birth/text = '#')">
      		   <xsl:value-of select="box.birth/birth/text" />
      		</xsl:if>
     		<xsl:if test="box.birth/birth/event and not(box.birth/birth/event = '#')">
     			in <xsl:value-of select="box.birth/birth/event" />
    		</xsl:if>
	      </xsl:if>
    	  <xsl:if test="box.death/death">
	      	    <xsl:text> , gest. </xsl:text>
      			<xsl:if test="not(box.death/death/text = '#')">
      				<xsl:value-of select="box.death/death/text" />
    	  		</xsl:if>
	     		<xsl:if test="box.death/death/event and not(box.death/death/event = '#')">
     				in <xsl:value-of select="box.death/death/event" />
     			</xsl:if>
    		</xsl:if>
    		/
  	</xsl:if>
  	<xsl:if test="box.period/period/text">
  		<xsl:choose>
    		<xsl:when test="starts-with(/mycoreobject/@ID, 'cpr')">
    			/ tätig in Rostock: 
        	</xsl:when>
        	<xsl:when test="starts-with(/mycoreobject/@ID, 'cph')">
    			tätig in Hamburg:
        	</xsl:when>
        	<xsl:when test="starts-with(/mycoreobject/@ID, 'cpb')">
    			tätig in Braunschweig:
        	</xsl:when>
        	<xsl:otherwise>
        		tätig: 
        	</xsl:otherwise>
    	</xsl:choose>
  	</xsl:if>
	   	<xsl:apply-templates select="box.period/period/text" mode="concat">
    		<xsl:with-param name="separator">, </xsl:with-param>
        </xsl:apply-templates>
    / zuletzt als
    <xsl:value-of select="box.professorship/professorship[last()]/event" />
    <xsl:variable name="status_out">OMD.profkat.state.<xsl:value-of select="box.status/status" /></xsl:variable>
    [<xsl:value-of select="i18n:translate($status_out)" />]
    </xsl:variable>
    	<xsl:value-of select="normalize-space($output)" />
	</xsl:template>
	<!-- joins the given nodelist - parameter separator will be used as separator char -->
   <xsl:template match = "service" >
   <!--  do nothing -->
   </xsl:template>
   <xsl:template match = "*" mode = "concat" >
   		<xsl:param name = "separator" />
   		<xsl:value-of select = "./text()" />
        <xsl:if test = "not(position()=last())" >
        	<xsl:value-of select = "$separator" />
    	</xsl:if>
 	</xsl:template> 	
</xsl:stylesheet> 