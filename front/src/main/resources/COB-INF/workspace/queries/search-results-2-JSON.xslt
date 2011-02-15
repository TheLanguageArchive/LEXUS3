<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:util="java:java.util.UUID"
    exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Saved a query written as JSON response.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>


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
            <xsl:apply-templates select="search-results/query"/>
            <array key="searchResult">
                <xsl:apply-templates select="search-results/lexicon" mode="results"/>
            </array>
        </object>
    </xsl:template>

    <!-- Process search results. -->
    <xsl:template match="lexicon" mode="results">
        <object>
            <!--
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
            }
        -->
            <string key="startLetter">
                <xsl:value-of select="//refiner/startLetter"/>
            </string>
            <number key="total"><xsl:value-of select="ancestor::search-results/@total"/></number>
            <number key="count">
                <xsl:value-of select="//refiner/count"/>
            </number>
            <number key="startPage">
                <xsl:value-of select="//refiner/position"/>
            </number>
            <object key="lexicon">
                <string key="description"/>
                <string key="name"><xsl:value-of select="@name"/></string>
                <string key="id"><xsl:value-of select="@id"/></string>
            </object>
            <array key="lexicalEntries">
                <xsl:apply-templates select=".//lexical-entry" mode="results"/>
            </array>
        </object>
    </xsl:template>


    <!--
        Process a lexical entry from the search results.
    -->
    <xsl:template match="lexical-entry" mode="results">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <object key="listView">
                <string key="value">
                    <xsl:value-of select="./xhtml:html/xhtml:body"/>
                    <!--<xsl:apply-templates select="./xhtml:html/xhtml:body/*" mode="encoded"/>-->
                </string>
            </object>
        </object>
    </xsl:template>


    <!--
        query is the top level query element.
    -->
    <xsl:template match="query">
        <object key="query">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="name"/>
            </string>
            <string key="description">
                <xsl:value-of select="description"/>
            </string>
            <string key="type">
                <xsl:text>query</xsl:text>
            </string>
            <xsl:apply-templates select="expression"/>
        </object>
    </xsl:template>

    <!--
        An expression is an array of lexicon children, just below the query element.
    -->
    <xsl:template match="expression">
        <array key="children">
            <xsl:apply-templates select="lexicon"/>
        </array>
    </xsl:template>

    <!--
        A lexicon element contains a sub-expression with DC elements from that lexicon.
    -->
    <xsl:template match="lexicon">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="@name"/>
            </string>
            <string key="type">
                <xsl:text>lexicon</xsl:text>
            </string>
            <xsl:if test="datacategory">
                <array key="children">
                    <xsl:apply-templates select="datacategory"/>
                </array>
            </xsl:if>
        </object>
    </xsl:template>

    <!--
        A datacategory element contains a single testcase for that datacategory, e.g.
        contains('foo') or does-not-start-with('bar').
    -->
    <xsl:template match="datacategory">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="@name"/>
            </string>
            <string key="type">
                <xsl:text>data category</xsl:text>
            </string>
            <string key="value">
                <xsl:value-of select="@value"/>
            </string>
            <string key="condition">
                <xsl:value-of select="@condition"/>
            </string>
            <string key="negation">
                <xsl:value-of select="@negation"/>
            </string>
            <xsl:if test="datacategory">
                <array key="children">
                    <xsl:apply-templates select="datacategory"/>
                </array>
            </xsl:if>
        </object>
    </xsl:template>

</xsl:stylesheet>
