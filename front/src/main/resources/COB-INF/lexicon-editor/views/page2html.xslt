<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:display="http://www.mpi.nl/lexus/display/1.0" exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Lexical entry</title>
                 <!--<link rel="stylesheet" href="default.css" type="text/css"/>
                <link rel="stylesheet" href="lexical-entry.css" type="text/css"/>--> 
                <style type="text/css">&#32;<xsl:value-of select="/display:page/display:style"/></style>
            </head>
            <body>
                <div>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="display:page">
        <xsl:apply-templates select="display:structure/*"/>
    </xsl:template>

    <xsl:template match="text">
        <div xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text() | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="table">
        <table xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <xsl:template match="row">
        <tr xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <xsl:template match="col">
        <td xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template match="@class | @colspan">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="div">
        <div xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@dsl_class"/>
            <xsl:variable name="style"><xsl:apply-templates select="@*[local-name() ne 'dsl_class']"/></xsl:variable>
            <xsl:if test="$style ne ''"><xsl:attribute name="style" select="$style"/></xsl:if>            
            <xsl:apply-templates/>
        </div>
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
