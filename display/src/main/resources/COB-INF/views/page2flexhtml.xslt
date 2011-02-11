<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:display="http://www.mpi.nl/lexus/display/1.0" exclude-result-prefixes="#all" version="2.0">



    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Lexical entry</title>
                <style type="text/css"><xsl:value-of select="/display:page/display:style"/></style>
            </head>
            <body>
                <xsl:apply-templates select="@* | node()"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="display:page">
        <xsl:apply-templates select="display:structure/*"/>
    </xsl:template>

    <xsl:template match="text">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="table">
        &lt;table&gt;
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        &lt;/table&gt;
    </xsl:template>
    <xsl:template match="thead">
        &lt;head&gt;
            <xsl:apply-templates />
        &lt;/head&gt;
    </xsl:template>
    <xsl:template match="tbody">
        &lt;body&gt;
            <xsl:apply-templates />
        &lt;/body&gt;
    </xsl:template>
    <xsl:template match="tr">
        &lt;tr&gt;
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        &lt;/tr&gt;
    </xsl:template>
    <xsl:template match="td">
        &lt;td&gt;
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        &lt;/td&gt;
    </xsl:template>
    <xsl:template match="th">
        &lt;th&gt;
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        &lt;/th&gt;
    </xsl:template>
    
    <xsl:template match="@class | @colspan">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="div">
        &lt;font
            <xsl:apply-templates select="@*"/>&gt;
            <xsl:apply-templates/>
        &lt;/font&gt;
    </xsl:template>

    <xsl:template match="@dsl_class">
        <xsl:text>class=&apos;#</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&apos; </xsl:text>
    </xsl:template>
    
    <xsl:template match="@color[not(../@localStyle) or ../@localStyle eq 'true']">
        <!--<xsl:attribute name="color">
            <xsl:value-of select="."/>
        </xsl:attribute>-->
        
        <xsl:text>color=&apos;#</xsl:text>
        <xsl:value-of select="substring-after(., '0x')"/>
        <xsl:text>&apos; </xsl:text>
    </xsl:template>

    <xsl:template match="@fontFamily[not(../@localStyle) or ../@localStyle eq 'true']">
        <!--<xsl:attribute name="font-family">
            <xsl:value-of select="."/>
        </xsl:attribute>-->
        <xsl:text>face=&apos;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&apos; </xsl:text>
    </xsl:template>

    <xsl:template match="@fontSize[not(../@localStyle) or ../@localStyle eq 'true']">
        <!--<xsl:attribute name="font-size">
            <xsl:value-of select="."/>
        </xsl:attribute>-->
        <xsl:text>size=&apos;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&apos; </xsl:text>

    </xsl:template>

    <xsl:template match="text()" priority="1">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*"/>
    
    
</xsl:stylesheet>