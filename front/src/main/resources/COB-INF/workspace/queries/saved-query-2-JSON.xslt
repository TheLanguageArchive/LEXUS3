<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:util="java:java.util.UUID"
    exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Saved a query written as JSON response.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:include href="../../util/identity.xslt"/>


    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/query"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/lexus:save-query/lexus:result[@success = 'true']">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>
    
    <!--
        query is the top level query element.
    -->
    <xsl:template match="query">
        <object key="result">
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
                <array key="children">
                    <xsl:apply-templates select="datacategory"/>
                </array>
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
            <string key="caseSensitive">
                <xsl:value-of select="@caseSensitive"/>
            </string>
            <array key="children">
                <xsl:apply-templates select="datacategory"/>
            </array>
        </object>
    </xsl:template>
    
</xsl:stylesheet>
