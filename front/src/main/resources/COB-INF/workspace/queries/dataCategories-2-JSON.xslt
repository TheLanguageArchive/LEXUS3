<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 31, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="../../stylesheets/schema.xslt"/>
    
    <!--
        JSON to generate:
        
        {
        "id": "Mon Jan 31 10:31:49 CET 2011",
        "result": {"dataCategories":         [
        {
        "min": "1",
        "adminInfo": null,
        "id": "MmM5MDkwYTIxMmQ2N2UzNjAxMTJmNmE2OTAwNTA2Zjc=",
        "valuedomain": [],
        "max": null,
        "sortOrder": "abcdefghijklmnopqrstuvwxyz",
        "DCR": "a",
        "description": null,
        "name": "a",
        "type": "data category"
        },
        {
        "min": "1",
        "adminInfo": null,
        "id": "MmM5MDkwYTIxMmQ2N2UzNjAxMTJmNmE2OTAwMjA2NGY=",
        "valuedomain": [],
        "max": null,
        "sortOrder": "abcdefghijklmnopqrstuvwxyz",
        "DCR": "an",
        "description": "Used to reference an antonym of the lexeme, but using the \\lf (lexical function) field for this is better practice.",
        "name": "Antonym",
        "type": "data category"
        },
        
    -->
    <xsl:include href="../../stylesheets/lexicon.xslt"/>

    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/lexus:get-datacategories/lexus:result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/lexus:get-datacategories/lexus:result[@success = 'true']">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="lexus:get-datacategories/lexus:result">
        <object key="result">
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="dataCategories">
        <array key="dataCategories">
            <xsl:apply-templates/>
        </array>
    </xsl:template>

    <xsl:template match="@* | node()"/>


</xsl:stylesheet>
