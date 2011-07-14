<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
     xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="xd"
    version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jun 21, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="lexus:value">
        <xsl:copy>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>