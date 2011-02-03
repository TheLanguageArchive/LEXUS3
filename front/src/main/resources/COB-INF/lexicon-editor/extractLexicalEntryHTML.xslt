<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="/">
        <xsl:apply-templates select="/data/lexus:display/lexical-entry/xhtml:html"/>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}" select="text()"/>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:copy/>
    </xsl:template>
    <xsl:template match="xhtml:*">
        <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*| xhtml:* | text()"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
