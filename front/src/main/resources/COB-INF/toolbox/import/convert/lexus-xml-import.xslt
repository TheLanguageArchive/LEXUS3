<?xml version="1.0" encoding="UTF-8"?>
<!--
    Create a tree representation of the .typ file as parsed by Chaperon.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mpi="http://www.mpi.nl/lat/lexus"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lat/lexus" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="lexicon">
        <doc>
            <xsl:apply-templates select="lexical-entry"/>
        </doc>
    </xsl:template>

    <xsl:template match="lexical-entry">
        <row>
            <xsl:apply-templates/>
        </row>
    </xsl:template>

    <!-- Handle markers one at a time. When an marker has children,
         calculate children first (by applying templates to the next marker),
         include them in the component and check if the next unprocessed
         marker is a sibling.
         If the marker is just a datacategory, include it and also
         check if the next unprocessed marker is a sibling.
         -->
    <xsl:template match="component">
        <xsl:element name="{@name}">
            <xsl:value-of select="@value"/>
        </xsl:element>
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <xsl:template match="data-category">
        <xsl:element name="{@name}">
            <xsl:value-of select="@value"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
