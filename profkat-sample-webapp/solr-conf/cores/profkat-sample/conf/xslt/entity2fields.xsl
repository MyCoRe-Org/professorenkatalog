<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template mode="objValues" match="obj[@name='type']">
    <field name="objectType">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template mode="objValues" match="obj[@name='project']">
    <field name="objectProject">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>

  <xsl:template match="/solr-document-container/source/mycoreobject[contains(@ID, '_person_') or contains(@ID, '_corporation_')]">
    <xsl:if test="./metadata/def.heading/heading">
      <field name="heading">
        <xsl:call-template name="getHeadingName">
          <xsl:with-param name="firstName" select="./metadata/def.heading/heading/firstName" />
          <xsl:with-param name="lastName" select="./metadata/def.heading/heading/lastName" />
          <xsl:with-param name="personalName" select="./metadata/def.heading/heading/personalName" />
          <xsl:with-param name="collocation" select="./metadata/def.heading/heading/collocation" />
          <xsl:with-param name="nameAffix" select="./metadata/def.heading/heading/nameAffix" />
        </xsl:call-template>
      </field>

      <xsl:for-each select="./metadata/def.alternative/alternative">
        <field name="alternative.name">
          <xsl:call-template name="getHeadingName">
            <xsl:with-param name="firstName" select="firstName" />
            <xsl:with-param name="lastName" select="lastName" />
            <xsl:with-param name="personalName" select="personalName" />
            <xsl:with-param name="collocation" select="collocation" />
            <xsl:with-param name="nameAffix" select="nameAffix" />
          </xsl:call-template>
        </field>
      </xsl:for-each>

      <xsl:variable name="indexBrowse">
        <xsl:if test="contains(@ID, '_person_')">
          <xsl:value-of select="'indexBrowsePerson'" />
        </xsl:if>
        <xsl:if test="contains(@ID, '_corporation_')">
          <xsl:value-of select="'indexBrowseCorporation'" />
        </xsl:if>
      </xsl:variable>

      <field name="{$indexBrowse}">
        <xsl:call-template name="getHeadingName">
          <xsl:with-param name="firstName" select="./metadata/def.heading/heading/firstName" />
          <xsl:with-param name="lastName" select="./metadata/def.heading/heading/lastName" />
          <xsl:with-param name="personalName" select="./metadata/def.heading/heading/personalName" />
          <xsl:with-param name="collocation" select="./metadata/def.heading/heading/collocation" />
          <xsl:with-param name="nameAffix" select="./metadata/def.heading/heading/nameAffix" />
        </xsl:call-template>
      </field>
    </xsl:if>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="getHeadingName">
    <xsl:param name="firstName" />
    <xsl:param name="lastName" />
    <xsl:param name="personalName" />
    <xsl:param name="collocation" />
    <xsl:param name="nameAffix" />
    <xsl:param name="nameAsInOpac" />
    <xsl:param name="name" />

    <xsl:choose>
      <xsl:when test="$personalName">
        <xsl:value-of select="$personalName" />
        <xsl:if test="$collocation">
          <xsl:value-of select="concat(' &lt;',$collocation,'&gt;')" />
        </xsl:if>
      </xsl:when>

      <xsl:when test="$firstName and $lastName and $collocation">
        <xsl:value-of select="concat($lastName,', ',$firstName,' &lt;',$collocation,'&gt;')" />
      </xsl:when>

      <xsl:when test="$name">
        <xsl:value-of select="$name" />
      </xsl:when>

      <xsl:otherwise>
        <xsl:if test="$firstName and $lastName and $nameAffix">
          <xsl:value-of select="concat($lastName,', ',$firstName,' ',$nameAffix)" />
        </xsl:if>

        <xsl:if test="$firstName and $lastName and not($nameAffix)">
          <xsl:value-of select="concat($lastName,', ',$firstName)" />
        </xsl:if>

        <xsl:if test="$firstName and not($lastName or $nameAffix)">
          <xsl:value-of select="firstName" />
        </xsl:if>

        <xsl:if test="not ($firstName) and $lastName">
          <xsl:value-of select="$lastName" />
        </xsl:if>

        <xsl:if test="$firstName and not($lastName)">
          <xsl:value-of select="$firstName" />
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
