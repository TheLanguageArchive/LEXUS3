<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rr="http://nl.mpi.lexus/resource-resolver" 
    exclude-result-prefixes="#all" version="2.0">

    <xsl:preserve-space elements="*"/>
    
    <xsl:template match="/page">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="text">
        <fo:inline><xsl:value-of select="translate(. , ' ', '&#160;')"/></fo:inline>
    </xsl:template>
    
    
    <!--
        An inline decorator element. 
        -->
    <xsl:template match="div[@type eq 'dsl_show'][@block eq 'false']" priority="1">
        <fo:inline>
            <xsl:apply-templates select="@* | node()"/>
        </fo:inline>
    </xsl:template>
    
    
    <!--
        A block decorator element. 
    -->
    <xsl:template match="div[@type eq 'dsl_show'][@block eq 'true']" priority="1">
        <fo:block>
            <xsl:apply-templates select="@* | node()"/>
        </fo:block>
    </xsl:template>



    <!--
        A block div element. 
    -->
    <xsl:template match="div[@block eq 'true']">
        <fo:block>
            <xsl:apply-templates select="@* | node()"/>
        </fo:block>
    </xsl:template>
    
    
    <!--
        An inline div element. 
    -->
    <xsl:template match="div[@block eq 'false']">
        <fo:inline>
            <xsl:apply-templates select="@* | node()"/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="@bold[.='true']">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:template>


    <xsl:template match="@italic[.='true']">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:template>


    <xsl:template match="@fontSize">
        <xsl:attribute name="font-size"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>


    <xsl:template match="@fontFamily">
        <xsl:attribute name="font-family"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>


    <xsl:template match="@color[starts-with(., '0x')]">
        <xsl:attribute name="color"><xsl:value-of select="concat('#', substring-after(., '0x'))"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="@color[starts-with(., '#')]">
        <xsl:attribute name="color"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>


    <xsl:template match="@background-color">
        <xsl:attribute name="background-color"><xsl:value-of select="concat('#', substring-after(., '0x'))"/></xsl:attribute>
    </xsl:template>


    <xsl:template match="@border">
        <xsl:attribute name="border"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    
    
    
    <xsl:template match="@font-family">
        <xsl:attribute name="font-family"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>


    <xsl:template match="@block"/>
    
    
    <xsl:template match="table">
        <fo:table-and-caption>
            <fo:table>
                <fo:table-body>
                    <xsl:apply-templates />
                </fo:table-body>
            </fo:table>
        </fo:table-and-caption>
    </xsl:template>
    <xsl:template match="row">
        <fo:table-row>
            <xsl:apply-templates />
        </fo:table-row>
    </xsl:template>
    <xsl:template match="col">
        <fo:table-cell>
            <xsl:apply-templates />
        </fo:table-cell>
    </xsl:template>



    <xsl:template match="img">
        <fo:external-graphic>
            <xsl:copy-of select="@src | *"/>
        </fo:external-graphic>
    </xsl:template>
    
    <xsl:template match="resource" priority="1">
        <rr:resource-id-to-url>
            <xsl:copy-of select="@*"/>
        </rr:resource-id-to-url>
    </xsl:template>
    
    
    <xsl:template match="@*"/>


    <xsl:template match="text()" priority="1">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>
