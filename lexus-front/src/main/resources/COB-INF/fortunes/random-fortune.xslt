<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:chaperon="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd chaperon" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 1, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    
    <xsl:preserve-space elements="chaperon:fortune"/>
    

    <xsl:param name="random" select="7163812365481"/>
    
    <xsl:template match="chaperon:output">
        <xsl:apply-templates/>        
    </xsl:template>

    <xsl:template match="chaperon:doc">
        <xsl:variable name="count" select="count(chaperon:fortune)"/>
        <fortune>
            <xsl:copy-of select="chaperon:fortune[position()=(number($random) mod $count)+1]/text()"
            />
        </fortune>
    </xsl:template>


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
