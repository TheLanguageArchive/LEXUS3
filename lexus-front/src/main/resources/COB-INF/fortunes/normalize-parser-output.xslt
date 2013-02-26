<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:chaperon="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 1, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <xsl:preserve-space elements="chaperon:lf chaperon:fortune"/>
    
    
    
    <xsl:template match="chaperon:doc">
        <xsl:copy><xsl:apply-templates select=".//chaperon:fortune"/></xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="chaperon:textSequence">
        <xsl:apply-templates/>
    </xsl:template>
    

    <xsl:template match="chaperon:text">
        <xsl:value-of select="."/>
    </xsl:template>


    <xsl:template match="chaperon:fortuneSequence">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="chaperon:fortune-start"/>


    <xsl:template match="chaperon:lf">
        <xsl:text>&#10;</xsl:text>
    </xsl:template>    
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
