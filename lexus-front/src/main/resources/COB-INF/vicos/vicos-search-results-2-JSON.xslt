<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:util="java:java.util.UUID"
    exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Process a vicos search query result to a JSON response.</xd:p>
        </xd:desc>
    </xd:doc>

    <!--
        {
        "id": "Mon Feb 07 15:37:08 CET 2011",
        "result": {"searchResult":         [
        {
        "startLetter": "",
        "total": 86,
        "lexicon":                 {
        "description": null,
        "name": "Demo_rossell  lexicon "
        },
        "count": 25,
        "lexicalEntries": [                {
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5Y2Y=",
        "listView": {"value": "All types called same name: friends, we don't eat them: can be called if canoe is\r\nabout to sink, special spells to bring them to help."}
        }],
        "startPage": 0
        },
        {
        "startLetter": "",
        "total": 86,
        "lexicon":                 {
        "description": "Uses Standard Format markers as defined in _Making Dictionaries: A guide to lexicography and the Multi-Dictionary Formatter_. David F. Coward, Charles E. Grimes, and Mark Pedrotti. Waxhaw, NC: SIL, 1998. (Version 2.0) ",
        "name": "Marquesan lexicon"
        },
        "count": 25,
        "lexicalEntries":                 [
        ...
    -->


    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/lexus:search-with-query/lexus:result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/lexus:search-with-query/lexus:result[@success = 'true']">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>


    <xsl:template match="lexus:result">
        <object key="result">
            <array key="entries">
                <xsl:apply-templates select="search-results/lexicon/lexical-entry">
                    <xsl:with-param name="dcSchemaRef" select="search-results/query//datacategory/@schema-ref"/>
                </xsl:apply-templates>
            </array>
        </object>
    </xsl:template>

    <xsl:template match="lexical-entry">
        <xsl:param name="dcSchemaRef"/>
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <array key="word"><xsl:apply-templates select=".//data[@schema-ref eq $dcSchemaRef]"/></array>
            <string key="type">lexicalEntryInstance</string>            
        </object>
    </xsl:template>
    
    <xsl:template match="data">
        <string><xsl:value-of select="value"/></string>
    </xsl:template>
    
</xsl:stylesheet>
