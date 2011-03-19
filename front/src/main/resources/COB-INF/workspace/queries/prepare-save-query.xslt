<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:util="java:java.util.UUID"
    exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Save a query or filter.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:include href="../../util/identity.xslt"/>

    <!-- 
        
        <REQUEST:=    {
        "parameters": {"query":         {
        "name": "Fish",
        "id": "MmM5MDkwYTIyMTBiYWJmNDAxMjEzOTc5MzhlMjcxY2E=",
        "type": "query",
        "children":             [
        {
        "name": "Demo_rossell  lexicon ",
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTcyZDU5ZGQ=",
        "type": "lexicon",
        "children":                     [
        {
        "name": "d",
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5YzU=",
        "children": [                            {
        "name": "dt",
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5Y2I=",
        "children": [                                {
        "name": "e",
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5Yzk=",
        "children": [],
        "mx_internal_uid": "6FF65B7E-2B44-8B88-3099-F5C6D3E84CF9",
        "value": "wswsws",
        "type": "data category",
        "negation": true,
        "condition": "contains"
        }],
        "mx_internal_uid": "9C34B38B-7771-8156-50C1-F5C69C028055",
        "value": "sxsxsxsx",
        "type": "data category",
        "negation": true,
        "condition": "contains"
        }],
        "mx_internal_uid": "4739E7FC-9A71-C978-116F-F5C647ADA2B1",
        "value": "fish",
        "type": "data category",
        "negation": false,
        "condition": "contains"
        },
        {
        "name": "d",
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5YzU=",
        "children": [],
        "mx_internal_uid": "821AD98B-02B2-FD2C-E1B0-F5C647ADB41F",
        "value": "azazazaz",
        "type": "data category",
        "negation": true,
        "condition": "is"
        }
        ],
        "mx_internal_uid": "2332254C-BA60-270F-A8C5-F5C64007CEAD"
        },
        {
        "name": "Marquesan lexicon",
        "id": "MmM5MDkwYTIxNjMzMjUzNDAxMTYzNDljMzYwMjAwNjA=",
        "type": "lexicon",
        "children": [                    {
        "name": "Definition (E)",
        "id": "MmM5MDkwYTIxNjMzMjUzNDAxMTYzNDk1MGM4NzAwMzE=",
        "children": [],
        "mx_internal_uid": "23087022-5B2C-46F9-5026-F5C651B2F2D4",
        "value": "fish",
        "type": "data category",
        "negation": false,
        "condition": "contains"
        }],
        "mx_internal_uid": "C3B53E6D-4FBD-7895-60B6-F5C64007C976"
        }
        ],
        "description": "",
        "mx_internal_uid": "2EEFDBE7-3260-D7E7-9253-F5C3D5A3012F"
        }},
        "id": "23F4CBD6-A9A0-3E1B-EEE6-F5C84BB964B9",
        "requester": "queryBuilder"
        }>
        2011-02-05 13:25:00,703 INFO [nl.mpi.lexicon.web.spring.controllers.search.query.json.SaveQuery] - <LexiconQuery with viewID=2c9090a20ad6bf2e010af51fe72d59dd>
        2011-02-05 13:25:00,711 INFO [nl.mpi.lexicon.web.spring.controllers.search.query.json.SaveQuery] - <LexiconQuery with viewID=2c9090a2163325340116349c36020060>
        2011-02-05 13:25:00,734 INFO [nl.mpi.lexicon.web.spring.controllers.search.query.json.SaveQuery] - <    {
        "id": "Sat Feb 05 13:25:00 CET 2011",
        "result":         {
        "id": "MmM5MDkwYTIyMTBiYWJmNDAxMjEzOTc5MzhlMjcxY2E=",
        "description": "",
        "name": "Fish",
        "children":             [
        {
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTcyZDU5ZGQ=",
        "name": "Demo_rossell  lexicon ",
        "children":                     [
        {
        "negation": false,
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5YzU=",
        "condition": "contains",
        "name": "d",
        "value": "fish",
        "children": [                            {
        "negation": true,
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5Y2I=",
        "condition": "contains",
        "name": "dt",
        "value": "sxsxsxsx",
        "children": [                                {
        "negation": true,
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5Yzk=",
        "condition": "contains",
        "name": "e",
        "value": "wswsws",
        "children": [],
        "type": "data category"
        }],
        "type": "data category"
        }],
        "type": "data category"
        },
        {
        "negation": true,
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5YzU=",
        "condition": "is",
        "name": "d",
        "value": "azazazaz",
        "children": [],
        "type": "data category"
        }
        ],
        "type": "lexicon"
        },
        {
        "id": "MmM5MDkwYTIxNjMzMjUzNDAxMTYzNDljMzYwMjAwNjA=",
        "name": "Marquesan lexicon",
        "children": [                    {
        "negation": false,
        "id": "MmM5MDkwYTIxNjMzMjUzNDAxMTYzNDk1MGM4NzAwMzE=",
        "condition": "contains",
        "name": "Definition (E)",
        "value": "fish",
        "children": [],
        "type": "data category"
        }],
        "type": "lexicon"
        }
        ],
        "type": "query"
        },
        "requester": "queryBuilder",
        "status":         {
        "message": "At your service",
        "duration": "42",
        "insync": true,
        "success": true
        },
        "requestId": "23F4CBD6-A9A0-3E1B-EEE6-F5C84BB964B9"
        }
        
        
    -->

    <xsl:template match="json">
        
        <xsl:variable name="id">
            <xsl:choose>
                <xsl:when test="parameters/query/id eq 'null' or parameters/query/id eq ''">
                    <xsl:value-of select="concat('uuid:',util:toString(util:randomUUID()))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="parameters/query/id"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <lexus:save-query>
            <!--
                If a lexicon id is present then it's a lexiconbrowser's filter, otherwise it's a workspace query.
                -->
            <xsl:copy-of select="parameters/lexicon"/>
            <xsl:apply-templates select="parameters/query">
                <xsl:with-param name="id" select="$id"/>
            </xsl:apply-templates>
        </lexus:save-query>
        <xsl:apply-templates select="parameters/query">
            <xsl:with-param name="id" select="$id"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Process the query element from the expression.
        Expression are always like this:
        <query>
            <lexicon>
                <datacategory>
                    <datacategory>
                        ...
                    ...
                <datacategory>*
            <lexicon>+
        <query>
    -->
    <xsl:template match="query">
        <xsl:param name="id"/>
        <xsl:copy>
            <xsl:attribute name="id" select="$id"/>
            <xsl:copy-of select="name | description"/>
            <expression>
                <xsl:apply-templates select="children/children" mode="lexicon"/>
            </expression>
        </xsl:copy>
    </xsl:template>

    <!--
        Process a lexicon element from the expression.
    -->
    <xsl:template match="children" mode="lexicon">
        <lexicon id="{id}" name="{name}">
            <xsl:apply-templates select="children/children"/>
        </lexicon>
    </xsl:template>
    
    <!--
        Process a datacategory element from the expression.
        -->
    <xsl:template match="children">
        <datacategory id="{id}" name="{name}" value="{value}" condition="{condition}" negation="{negation}">
            <xsl:apply-templates select="children/children"/>
        </datacategory>
    </xsl:template>
    
</xsl:stylesheet>
