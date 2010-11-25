<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:display="http://www.mpi.nl/lexus/display/1.0" exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Lexical entry</title>
                <link rel="stylesheet" href="default.css" type="text/css"/>
                <link rel="stylesheet" href="lexical-entry.css" type="text/css"/>
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
        <xsl:apply-templates/>
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
        <xsl:copy>
            <xsl:attribute name="style">
                <xsl:apply-templates select="@*"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@color">
        <xsl:text>color:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="@fontFamily">
        <xsl:text>font-family:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="@fontSize">
        <xsl:text>font-size:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
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
