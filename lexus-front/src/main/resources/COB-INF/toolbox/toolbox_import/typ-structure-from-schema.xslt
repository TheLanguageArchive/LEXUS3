<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/" exclude-result-prefixes="#all" version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 14, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <xsl:template match="lexus:container[@mdf:marker]|lexus:datacategory[@mdf:marker]" priority="1">
        <xsl:element name="{@mdf:marker}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="lexus:container|lexus:datacategory">
        <xsl:copy><xsl:copy-of select="@name"/><xsl:apply-templates /></xsl:copy><xsl:comment><xsl:value-of select="@name"/></xsl:comment>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
