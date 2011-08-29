<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0">

    <!-- Encode text -->
    <xsl:template match="text()" mode="encoded" priority="1">
        <xsl:text> text { &quot;</xsl:text>
        <xsl:value-of select="fn:replace(fn:replace(., '&amp;', '&amp;amp;'), '&quot;', '&amp;quot;')" />
        <xsl:text>&quot; }</xsl:text>
    </xsl:template>

    <!-- Encode attributes -->
    <xsl:template match="@*" mode="encoded" priority="1">
        <xsl:text> attribute </xsl:text>
        <xsl:value-of select="QName(namespace-uri(), local-name())"/>
        <xsl:text> { &quot;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&quot; }</xsl:text>
    </xsl:template>

    <!-- Encode nodes -->
    <xsl:template match="node()" mode="encoded">
        <xsl:text>element </xsl:text>
        <xsl:value-of select="QName(namespace-uri(), local-name())"/>
        <xsl:text> { </xsl:text>
        <xsl:for-each select="@* | * |  text()[not(. eq '&#x0a;')]">
            <xsl:apply-templates select="." mode="encoded"/>
            <xsl:if test="not(position() eq last())">
                <xsl:text>,
                </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text> }</xsl:text>
    </xsl:template>
</xsl:stylesheet>
