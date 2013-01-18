<?xml version="1.0" encoding="UTF-8"?>
<!--
  Massage the Chaperon Parser output to something useful and legible.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0" exclude-result-prefixes="#all">
  
  <!--Skip output element -->
  <xsl:template match="parser:output">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!--Switch to default namespace for lexicon element -->
  <xsl:template match="parser:lexicon">
    <lexicon><xsl:apply-templates/></lexicon>
  </xsl:template>
  
  
  <!--Switch to default namespace for lexical-entry element -->
  <xsl:template match="parser:lexical-entry">
    <lexical-entry><xsl:apply-templates/></lexical-entry>
  </xsl:template>
  
  <!--Switch to default namespace for lexical-entry element -->
  <xsl:template match="parser:last-lexical-entry">
    <lexical-entry><xsl:apply-templates/></lexical-entry>
  </xsl:template>

  <!--Skip attributeSequence elements -->
  <xsl:template match="parser:attributeSequence">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!--Skip lexicalEntrySequence elements -->
  <xsl:template match="parser:lexicalEntrySequence">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- Remove unused start and end tags -->
  <xsl:template match="parser:lf"/>
    

  <!-- Compact attributes -->
  <xsl:template match="parser:attribute[parser:attribute and parser:textSequence]" priority="1">
    <marker name="{translate(parser:attribute, '\', '')}" value="{normalize-space(parser:textSequence)}"/>
  </xsl:template>
  <xsl:template match="parser:attribute[parser:attribute]">
    <marker name="{translate(parser:attribute, '\', '')}"/>
  </xsl:template>
  <xsl:template match="parser:last-attribute[parser:attribute and parser:textSequence]" priority="1">
    <marker name="{translate(parser:attribute, '\', '')}" value="{normalize-space(parser:textSequence)}"/>
  </xsl:template>
  <xsl:template match="parser:last-attribute[parser:attribute]">
    <marker name="{translate(parser:attribute, '\', '')}"/>
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
