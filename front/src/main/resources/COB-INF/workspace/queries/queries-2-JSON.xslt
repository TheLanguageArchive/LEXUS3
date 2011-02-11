<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- 

    original app's JSON to mimic (but leave out stuff that's unnecessary, like "fill"):
    {
    "id": "Mon Apr 26 17:24:59 CEST 2010",
    "result": {"queries":         [
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
    ]},
    "requester": "Workspace58",
    "status":         {
    "message": "At your service",
    "duration": "222",
    "insync": true,
    "success": true
    },
    "requestId": "A25F1CD8-79FB-172C-71D4-3AB8A4F82348"
    }
    
-->

    <xsl:template match="/">
        <object>
            <object key="result">
                <xsl:apply-templates select="*"/>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="queries">
        <array key="queries">
            <xsl:apply-templates select="*"/>
        </array>
    </xsl:template>

    <!--
        query is the top level query element.
        -->
    <xsl:template match="query">
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
