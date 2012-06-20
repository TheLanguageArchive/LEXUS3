<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- 

    {"queries":         [
    {
    "id": "MmM5MDkwYTIyMjk4MTNhMzAxMjJlZmM1ZDEwZjA2ODM=",
    "description": "azazazazaz",
    "name": "Domdiedom",
    "children": [                {
    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ3ZmRjZTRhNDU=",
    "name": "???????? 89 ?? Yeli D'nye!",
    "children":                     [
    {
    "negation": true,
    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMzQ=",
    "condition": "is",
    "name": "alternative forms",
    "value": "azazaz",
    "children": [],
    "type": "data category"
    },
    {
    "negation": false,
    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMTY=",
    "condition": "is",
    "name": "CI",
    "value": "azaxzsxsx",
    "children": [],
    "type": "data category"
    }
    ],
    "type": "lexicon"
    }],
    "type": "query"
    },
    {
    "id": "MmM5MDkwYTIyMjk4MTNhMzAxMjJlZmI1Zjk2NzA2Nzg=",
    "description": "azazazazazazazazazazaz",
    "name": "azazazazazazazazazaz",
    "children":                 [
    {
    "id": "MmM5MDkwYTIyMjk4MTNhMzAxMjJlZjYxMzRmNTA2NmU=",
    "name": "?????????????????.????????????",
    "children": [                        {
    "negation": false,
    "id": "MmM5MDkwYTIyMjk4MTNhMzAxMjJlZmQyNzQxZjA2OTI=",
    "condition": "contains",
    "name": "domdiedom",
    "value": "1",
    "children": [],
    "type": "data category"
    }],
    "type": "lexicon"
    },
    {
    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ3ZmRjZTRhNDU=",
    "name": "???????? 89 ?? Yeli D'nye!",
    "children": [                        {
    "negation": false,
    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMmU=",
    "condition": "contains",
    "name": "description",
    "value": "bird",
    "children": [],
    "type": "data category"
    }],
    "type": "lexicon"
    }
    ],
    "type": "query"
    },
    {
    "id": "MmM5MDkwYTIyMjk4MTNhMzAxMjJlZmI4NThlYjA2N2M=",
    "description": "azaz",
    "name": "demo rossel lexicon",
    "children":                 [
    {
    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ3ZmRjZTRhNDU=",
    "name": "???????? 89 ?? Yeli D'nye!",
    "children": [                        {
    "negation": true,
    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMmU=",
    "condition": "contains",
    "name": "description",
    "value": "birdie",
    "children": [],
    "type": "data category"
    }],
    "type": "lexicon"
    },
    {
    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ3ZmRjZTRhNDU=",
    "name": "???????? 89 ?? Yeli D'nye!",
    "children": [                        {
    "negation": true,
    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMzY=",
    "condition": "contains",
    "name": "date",
    "value": "2009",
    "children": [],
    "type": "data category"
    }],
    "type": "lexicon"
    }
    ],
    "type": "query"
    }
    ]}
    
-->

    <xsl:template match="queries">
        <array key="queries">
            <xsl:apply-templates select="*" mode="queries"/>
        </array>
    </xsl:template>

    <!--
        query is the top level query element.
        -->
    <xsl:template match="query" mode="queries">
        <object>
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
            <xsl:apply-templates select="expression" mode="queries"/>
        </object>
    </xsl:template>

    <!--
        An expression is an array of lexicon children, just below the query element.
        -->
    <xsl:template match="expression" mode="queries">
        <array key="children">
            <xsl:apply-templates select="lexicon" mode="queries"/>
        </array>
    </xsl:template>

    <!--
        A lexicon element contains a sub-expression with DC elements from that lexicon.
        -->
    <xsl:template match="lexicon" mode="queries">
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
                    <xsl:apply-templates select="datacategory" mode="queries"/>
                </array>
            </xsl:if>
        </object>
    </xsl:template>
    
    <!--
        A datacategory element contains a single testcase for that datacategory, e.g.
        contains('foo') or does-not-start-with('bar').
        -->
    <xsl:template match="datacategory" mode="queries">
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
            <xsl:choose>
                <xsl:when test="@negation eq 'true'">
                    <true key="negation"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="negation"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="@caseSensitive eq 'true'">
                    <true key="caseSensitive"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="caseSensitive"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="datacategory">
                <array key="children">
                    <xsl:apply-templates select="datacategory" mode="queries"/>
                </array>
            </xsl:if>
        </object>
    </xsl:template>
</xsl:stylesheet>
