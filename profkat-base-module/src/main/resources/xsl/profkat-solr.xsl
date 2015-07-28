<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xalan="http://xml.apache.org/xalan" 
  xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"   
  xmlns:encoder="xalan://java.net.URLEncoder"
  xmlns:mcrjsp="xalan://org.mycore.frontend.jsp.MCRJSPUtils"
  exclude-result-prefixes="mcrxsl mcrjsp xlink encoder">
  <xsl:import href="xslImport:solr-document:profkat-solr.xsl" />

  <xsl:template match="mycoreobject">
    <xsl:param name="foo" />
    <xsl:apply-imports />
    <!-- fields from mycore-mods -->
    <xsl:apply-templates select="metadata"/>
    <field name="hasFiles">
      <xsl:value-of select="count(structure/derobjects/derobject)&gt;0" />
    </field>
    
    <!-- online type of derivate -->
    <xsl:for-each select="/mycoreobject/structure/derobjects/derobject">
      <field name="derivatelabel"><xsl:value-of select="@xlink:label|@xlink:title" /></field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="metadata">
    <xsl:apply-imports/>
    <xsl:variable name="headline" select="concat(box.surname/surname,', ', box.firstname/firstname[1])" />
    <field name="profkat.idx_headline">
    	<xsl:value-of select="$headline" />
    </field>
    <field name="profkat.idx_profkat.facet">
    	<!--  There is no replace in XSLT 1.0 !!! -->
    	<xsl:variable name="headline_normiert" select="mcrjsp:normalizeUmlauts($headline)" />
    	<xsl:choose>
    		<xsl:when test="starts-with($headline_normiert, 'Sch')"><xsl:value-of select="substring($headline_normiert,1,4)" /></xsl:when>
    		<xsl:when test="starts-with($headline_normiert, 'St')"><xsl:value-of select="substring($headline_normiert,1,3)" /></xsl:when>
    		<xsl:otherwise><xsl:value-of select="substring($headline_normiert,1,2)" /></xsl:otherwise>
    	</xsl:choose>
    </field>
    <xsl:variable name="lifetime_out">
      <xsl:if test="box.birth/birth">
      	* 
      		<xsl:value-of select="box.birth/birth/text" />
     		<xsl:if test="box.birth/birth/event">
     			in <xsl:value-of select="box.birth/birth/event" />
     		</xsl:if>
      </xsl:if>
      <xsl:if test="box.death/death">
      	|† 
      		<xsl:value-of select="box.death/death/text" />
     		<xsl:if test="box.death/death/event">
     			in <xsl:value-of select="box.death/death/event" />
     		</xsl:if>
      </xsl:if>
    </xsl:variable>
    <field name="profkat.lifetime">
		<xsl:value-of select="normalize-space($lifetime_out)" />
    </field>
    <field name="profkat.period"><xsl:value-of select="box.period/period/text" /></field>
    <field name="profkat.last_professorship"><xsl:value-of select="box.professorship/professorship[last()]/event" /></field>
    <xsl:for-each select="box.faculty/faculty[last()]/classification">
    	<field name="profkat.last_faculty_class"><xsl:value-of select="@classid" />:<xsl:value-of select="@categid" /></field>
    </xsl:for-each>
    <field name="profkat.status_msg">OMD.CPR.states.<xsl:value-of select="box.status/status" /></field>
    
    <xsl:for-each select="box.identifier/identifier[@type='gnd' or @type='pnd']">
    	<field name="gnd_uri">http://d-nb.info/gnd/<xsl:value-of select="." /></field>
        <field name="profkat.gnd"><xsl:value-of select="." /></field>
    </xsl:for-each>
  
    <xsl:for-each select="box.surname/surname | box.firstname/firstname | box.nameaffix/nameaffix">
      <field name="profkat.name"><xsl:value-of select="text()" /></field> 
    </xsl:for-each>
    

               <xsl:for-each select="box.institute/institute">
      <field name="profkat.institute"><xsl:value-of select="normalize-space(text())" /></field> 
    </xsl:for-each>
    
              <xsl:for-each select="box.fieldofstudy/fieldofstudy">
      <field name="profkat.area"><xsl:value-of select="normalize-space(text())" /></field> 
    </xsl:for-each>
      
               <xsl:for-each select="box.professorship/professorship/event">
      <field name="profkat.proftype"><xsl:value-of select="normalize-space(text())" /></field> 
    </xsl:for-each>
    
              <xsl:for-each select="box.birth/birth/event">
      <field name="profkat.birthplace"><xsl:value-of select="text()" /></field> 
    </xsl:for-each>
      
              <xsl:for-each select="box.death/death/event">
      <field name="profkat.deathplace"><xsl:value-of select="text()" /></field> 
    </xsl:for-each>
   
              <xsl:for-each select="box.confession/confession">
      <field name="profkat.confession"><xsl:value-of select="text()" /></field> 
    </xsl:for-each>
       
             <xsl:for-each select="box.family/family[@type='father' or @type='mother']/profession">
      <field name="profkat.parentprofession"><xsl:value-of select="normalize-space(text())" /></field> 
    </xsl:for-each>
         
              <xsl:for-each select="box.biographic/biographic">
      <field name="profkat.biography"><xsl:value-of select="concat(normalize-space(./time),' ',normalize-space(./text))" /></field> 
    </xsl:for-each>
            
             <xsl:for-each select="box.academicdegree/academicdegree">
      <field name="profkat.academicdegree"><xsl:value-of select="concat(normalize-space(./text/text()),' ',normalize-space(./event/text()))" /></field> 
    </xsl:for-each>
        
              <xsl:for-each select="box.academicdegree/academicdegree[@type='studies']">
      <field name="profkat.acad_degree_study"><xsl:value-of select="concat(normalize-space(./time),' ',normalize-space(./text))" /></field> 
    </xsl:for-each>

           <xsl:for-each select="box.academicdegree/academicdegree[@type='promotion']">
      <field name="profkat.acad_degree_promo"><xsl:value-of select="concat(normalize-space(./time),' ',normalize-space(./text))" /></field> 
    </xsl:for-each>

          <xsl:for-each select="box.academicdegree/academicdegree[@type='habilitation']">
      <field name="profkat.acad_degree_habil"><xsl:value-of select="concat(normalize-space(./time),' ',normalize-space(./text))" /></field> 
    </xsl:for-each>
      
         <xsl:for-each select="box.biographic/biographic[@type='otherprofessorship']">
      <field name="profkat.otherprofessorship"><xsl:value-of select="concat(normalize-space(./time),' ',normalize-space(./text))" /></field> 
    </xsl:for-each>
     
         <xsl:for-each select="box.adminfunction/adminfunction">
      <field name="profkat.adminfunction"><xsl:value-of select="concat(normalize-space(./time),' ',normalize-space(./text))" /></field> 
    </xsl:for-each>

           <xsl:for-each select="box.otherfunction/otherfunction">
      <field name="profkat.otherfunction"><xsl:value-of select="concat(normalize-space(./time),' ',normalize-space(./text))" /></field> 
    </xsl:for-each>
 
       <xsl:for-each select="box.membership/membership">
      <field name="profkat.membership"><xsl:value-of select="concat(normalize-space(./time),' ',normalize-space(./text))" /></field> 
    </xsl:for-each>
  
      <xsl:for-each select="box.award/award">
      <field name="profkat.award"><xsl:value-of select="concat(normalize-space(./time),' ',normalize-space(./text))" /></field> 
    </xsl:for-each>
     
          <xsl:for-each select="box.mainpublication/mainpublication">
      <field name="profkat.mainpublication"><xsl:value-of select="normalize-space(./text())" /></field> 
    </xsl:for-each>
    
             <xsl:for-each select="box.source/source">
      <field name="profkat.source"><xsl:value-of select="@xlink:title" /></field> 
    </xsl:for-each>
   
             <xsl:for-each select="box.reference/reference">
      <field name="profkat.reference"><xsl:value-of select="@xlink:title" /></field> 
    </xsl:for-each>
 
  <xsl:for-each select="box.status/status">
      <field name="profkat.profstate"><xsl:value-of select="text()" /></field> 
    </xsl:for-each>

<xsl:for-each select="box.period/period[1]">
      <field name="profkat.proftime_from"><xsl:value-of select="substring(./von,1,10)" /></field> 
    </xsl:for-each>

<xsl:for-each select="box.period/period[last()]">
      <field name="profkat.proftime_to"><xsl:value-of select="substring(./bis,1,10)" /></field> 
    </xsl:for-each>

<xsl:for-each select="box.birth/birth">
      <field name="profkat.lifetime_from"><xsl:value-of select="substring(./von,1,10)" /></field> 
    </xsl:for-each>

<xsl:for-each select="box.death/death">
      <field name="profkat.lifetime_to"><xsl:value-of select="substring(./bis,1,10)" /></field> 
    </xsl:for-each>
    
    
             
               
       
  </xsl:template>
</xsl:stylesheet>