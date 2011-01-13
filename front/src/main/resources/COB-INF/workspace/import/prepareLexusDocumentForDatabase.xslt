<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 7, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p/>
            <xd:p>Prepare the XML for sending it to the database backend.</xd:p>
        </xd:desc>
    </xd:doc>


    <!--
        Surround the lexus:lexus document with a lexus:import-lexicon element.
        Strip all the lexus: namespaces.
        -->
    <xsl:template match="/">
        <lexus:create-lexicon>
            <xsl:apply-templates select="*"/>
        </lexus:create-lexicon>
    </xsl:template>

    <xsl:template match="lexus:*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
