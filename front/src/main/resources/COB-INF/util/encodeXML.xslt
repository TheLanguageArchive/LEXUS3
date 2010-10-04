<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0">
    
    <!-- Encode everything -->
    <xsl:template match="text()" mode="encoded" priority="1">
        <xsl:value-of select="fn:replace(fn:replace(., '\{', '&amp;#x7b;'), '\}', '&amp;#x7d;')"/>
    </xsl:template>
    
    <xsl:template match="@*" mode="encoded" priority="1">
        <xsl:text> </xsl:text><xsl:value-of select="local-name()"/>=&quot;<xsl:value-of select="fn:replace(fn:replace(., '\{', '&amp;#x7b;'), '\}', '&amp;#x7d;')"/>&quot;<xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="node()" mode="encoded">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="local-name()"/>
        <xsl:apply-templates select="@*" mode="encoded"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates select="node() | text()" mode="encoded"/>
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="local-name()"/>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
