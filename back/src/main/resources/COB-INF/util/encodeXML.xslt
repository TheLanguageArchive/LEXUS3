<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <!-- Encode everything except elements named 'password' -->
    <xsl:template match="text()" mode="encoded" priority="1">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="@*" mode="encoded" priority="1">
        <xsl:text> </xsl:text><xsl:value-of select="local-name()"/>=&quot;<xsl:value-of select="."/>&quot;<xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="password" mode="encoded"/>
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
