<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <!-- Identity transform functions. -->
    
    <!-- Copy attributes, text and comments but remove any namespaces. -->
    <xsl:template match="@* | text() | comment()" mode="remove_namespaces" priority="1">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- Copy elements but remove any namespaces. -->
    <xsl:template match="node()" mode="remove_namespaces" priority="1">
        <xsl:element name="{local-name()}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="@* | node()" mode="remove_namespaces"/>
        </xsl:element>
    </xsl:template>


    <!-- Copy attributes, text and comments in mode use_namespace. -->
    <xsl:template match="@* | text() | comment()" mode="use_namespace" priority="1">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- Copy elements into namespace ns. -->
    <xsl:template match="node()" mode="use_namespace">
        <xsl:param name="ns" select="''"/>
        <xsl:element name="{local-name()}" namespace="{$ns}">
            <xsl:apply-templates select="@* | node()" mode="use_namespace">
                <xsl:with-param name="ns" select="$ns"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    
    <!--
        The real identity transform ;-).
        -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
