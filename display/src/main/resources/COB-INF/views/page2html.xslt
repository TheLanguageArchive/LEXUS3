<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    xmlns:rr="http://nl.mpi.lexus/resource-resolver" 
    exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="/">
        <xhtml:html>
            <xhtml:head>
                <xhtml:title>Lexical entry</xhtml:title>
                 <!--<link rel="stylesheet" href="default.css" type="text/css"/>
                <link rel="stylesheet" href="lexical-entry.css" type="text/css"/>--> 
                <xhtml:style type="text/css">&#32;<xsl:value-of select="/display:page/display:style"/></xhtml:style>
            </xhtml:head>
            <xhtml:body>
                <xhtml:div>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xhtml:div>
            </xhtml:body>
        </xhtml:html>
    </xsl:template>

    <xsl:template match="display:page">
        <xsl:apply-templates select="display:structure/*"/>
    </xsl:template>

    <xsl:template match="text">
        <xhtml:div xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text() | node()"/>
        </xhtml:div>
    </xsl:template>

    <xsl:template match="table">
        <xhtml:table xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xhtml:table>
    </xsl:template>
    <xsl:template match="row">
        <xhtml:tr xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xhtml:tr>
    </xsl:template>
    <xsl:template match="col">
        <xhtml:td xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xhtml:td>
    </xsl:template>

    <xsl:template match="@class | @colspan">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="div">
        <xhtml:div xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@dsl_class"/>
            <xsl:variable name="style"><xsl:apply-templates select="@*[local-name() ne 'dsl_class']"/></xsl:variable>
            <xsl:if test="$style ne '' or @style ne ''"><xsl:attribute name="style" select="concat(@style, $style)"/></xsl:if>            
            <xsl:apply-templates/>
        </xhtml:div>
    </xsl:template>

    <xsl:template match="@dsl_class">
        <xsl:attribute name="class" select="."/>
    </xsl:template>

    <xsl:template match="@color[not(../@localStyle) or ../@localStyle eq 'true']">
        <xsl:text>color:#</xsl:text>
        <xsl:value-of select="substring-after(., '0x')"/>
        <xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="@fontFamily[not(../@localStyle) or ../@localStyle eq 'true']">
        <xsl:text>font-family:'</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>';</xsl:text>
    </xsl:template>

    <xsl:template match="@fontSize[not(../@localStyle) or ../@localStyle eq 'true']">
        <xsl:if test="data(.) != '' and data(.) != 'null'">
            <xsl:text>font-size:</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>pt;</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="img">
        <xhtml:img>
            <xsl:copy-of select="@* | *"/>
        </xhtml:img>
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

    <xsl:template match="node()">
        <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
