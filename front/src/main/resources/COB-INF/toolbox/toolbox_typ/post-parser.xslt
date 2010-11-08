<?xml version="1.0" encoding="UTF-8"?>
<!--
  Massage the Chaperon Parser output to something useful and legible.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0">
  
  <!--Skip output element -->
  <xsl:template match="parser:output">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!--Skip doc element -->
  <xsl:template match="parser:doc">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!--Skip markerSequence elements -->
  <xsl:template match="parser:markerSequence">
    <xsl:apply-templates/>
  </xsl:template>

  <!--Skip complexAttributeSequence elements -->
  <xsl:template match="parser:complexAttributeSequence">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- Remove unused start and end tags -->
  <xsl:template match="parser:complexAttribute-start"/>
  <xsl:template match="parser:complexAttribute-end"/>
  <xsl:template match="parser:mkrset-start"/>
  <xsl:template match="parser:mkrset-end"/>
  <xsl:template match="parser:databaseType-start"/>
  <xsl:template match="parser:databaseType-end"/>
  
  <!-- Compact the marker set -->
  <xsl:template match="parser:marker-set">
    <parser:markerSet>
      <xsl:apply-templates select="parser:complexAttributeSequence"/>
      <xsl:apply-templates select="parser:markerSequence"/>
    </parser:markerSet>
  </xsl:template>
  
  <!-- Compact a marker -->
  <xsl:template match="parser:marker">
    <parser:marker>
      <xsl:attribute name="name">
        <xsl:apply-templates select="parser:textSequence"/>
      </xsl:attribute>
      <xsl:apply-templates select="parser:complexAttributeSequence"/>
    </parser:marker>
  </xsl:template>


  <!-- Compact attributes -->
  <xsl:template match="parser:attribute[parser:attribute and parser:textSequence]" priority="1">
    <parser:attribute name="{translate(parser:attribute, '\', '')}">
      <xsl:value-of select="normalize-space(parser:textSequence)"/>
    </parser:attribute>
  </xsl:template>
  <xsl:template match="parser:attribute[parser:attribute]">
    <parser:attribute name="{translate(parser:attribute, '\', '')}"/>
  </xsl:template>
  <xsl:template match="parser:complexAttribute" priority="1">
    <parser:attribute type="complex" name="{translate(parser:complexAttribute-start, '\+', '')}">
      <xsl:apply-templates/>
    </parser:attribute>
  </xsl:template>

  <!-- Compact text sequence -->
  <xsl:template match="parser:textSequence">
    <parser:text>
      <xsl:value-of select="."/>
    </parser:text>
  </xsl:template>

  <!-- Identity transform: copy all others -->
  <xsl:template match="parser:*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
