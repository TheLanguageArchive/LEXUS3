<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="/page">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="text">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="div[@type eq 'dsl_show']">
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

    <xsl:template match="@font-size">
        <xsl:attribute name="font-size"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>

    <xsl:template match="@background-color">
        <xsl:attribute name="background-color"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>

    <xsl:template match="@border">
        <xsl:attribute name="border"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    
    
    <xsl:template match="@font-family">
        <xsl:attribute name="font-family"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>

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

    <xsl:template match="@*"/>


    <xsl:template match="text()" priority="1">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>
