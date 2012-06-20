<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" 
    version="2.0">

    <xsl:include href="../../stylesheets/schema.xslt"/>
    <!-- 
        JSON source to mimic:

 {
        "id": "Tue May 04 14:59:47 CEST 2010",
        "result":         {
            "lexus": null,
            "schema":             {
                "min": 1,
                "adminInfo": null,
                "id": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U4YTAwMDE=",
                "max": 1,
                "description": "The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry",
                "name": "lexicon",
                "parent": null,
                "type": "Lexicon",
                "note": null,
                "style": null,
                "children":                 [
                                        {
                        "min": 1,
                        "adminInfo": null,
                        "id": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U5MTAwMDk=",
                        "max": 1,
                        "description": "Contains administrative information and other general attributes",
                        "name": "lexiconInformation",
                        "parent": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U4YTAwMDE=",
                        "type": "component",
                        "note": null,
                        "style": null,
                        "children": []
                    },
                                        {
                        "min": 0,
                        "adminInfo": null,
                        "id": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U5MDAwMDM=",
                        "max": null,
                        "description": "Represents a word, a multi-word expression, or an affix in a given language",
                        "name": "lexicalEntry",
                        "parent": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U4YTAwMDE=",
                        "type": "LexicalEntry",
                        "note": null,
                        "style": null,
                        "children":                         [
                                                        {
                                "min": 1,
                                "adminInfo": null,
                                "id": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U5MDAwMDU=",
                                "max": null,
                                "description": "Represents one lexical variant of the written or spoken form of the lexical entry",
                                "name": "form",
                                "parent": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U5MDAwMDM=",
                                "type": "Form",
                                "note": null,
                                "style": null,
                                "sortOrder":                                     {
                                       "id": "MmM5MDkwYTIyMjk4MTNhMzAxMjJlZjc2YzM3OTA2Nzc=",
                                       "description": "azazaz",
                                       "fill": "?(b?)adcefghijklmnopqrstuvwxyz",
                                       "name": "azazaz",
                                       "data":                                         [
                                       {
                                       "startLetter": "?",
                                       "characters": "b?"
                                       },
                                       {
                                       "startLetter": "a",
                                       "characters": "a"
                                       },
                                       {
                                       "startLetter": "d",
                                       "characters": "d"
                                       },
                                       {
                                       "startLetter": "c",
                                       "characters": "c"
                                       },
                                       {
                                       "startLetter": "e",
                                       "characters": "e"
                                       },
                                       {
                                       "startLetter": "f",
                                       "characters": "f"
                                       },
                                       {
                                       "startLetter": "g",
                                       "characters": "g"
                                       },
                                       {
                                       "startLetter": "h",
                                       "characters": "h"
                                       },
                                       {
                                       "startLetter": "i",
                                       "characters": "i"
                                       },
                                       {
                                       "startLetter": "j",
                                       "characters": "j"
                                       },
                                       {
                                       "startLetter": "k",
                                       "characters": "k"
                                       },
                                       {
                                       "startLetter": "l",
                                       "characters": "l"
                                       },
                                       {
                                       "startLetter": "m",
                                       "characters": "m"
                                       },
                                       {
                                       "startLetter": "n",
                                       "characters": "n"
                                       },
                                       {
                                       "startLetter": "o",
                                       "characters": "o"
                                       },
                                       {
                                       "startLetter": "p",
                                       "characters": "p"
                                       },
                                       {
                                       "startLetter": "q",
                                       "characters": "q"
                                       },
                                       {
                                       "startLetter": "r",
                                       "characters": "r"
                                       },
                                       {
                                       "startLetter": "s",
                                       "characters": "s"
                                       },
                                       {
                                       "startLetter": "t",
                                       "characters": "t"
                                       },
                                       {
                                       "startLetter": "u",
                                       "characters": "u"
                                       },
                                       {
                                       "startLetter": "v",
                                       "characters": "v"
                                       },
                                       {
                                       "startLetter": "w",
                                       "characters": "w"
                                       },
                                       {
                                       "startLetter": "x",
                                       "characters": "x"
                                       },
                                       {
                                       "startLetter": "y",
                                       "characters": "y"
                                       },
                                       {
                                       "startLetter": "z",
                                       "characters": "z"
                                       }
                                ]
                                },
                                "children": []
                            },
                                                        {
                                "min": 0,
                                "adminInfo": null,
                                "id": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U5MTAwMDc=",
                                "max": null,
                                "description": "Contains attributes that describe meanings of a lexical entry",
                                "name": "sense",
                                "parent": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U5MDAwMDM=",
                                "type": "Sense",
                                "note": null,
                                "style": null,
                                "children": []
                            }
                        ]
                    }
                ]
            },
            "listView": [],
            "lexicon":             {
                "id": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2ViYTAwMGY=",
                "todos": [],
                "description": "asdf",
                "administrator": false,
                "writable": true,
                "name": "qwerty",
                "type": "myLexicon",
                "note": null
            },
            "sortOrders":             [
                                {
                    "id": "MmM5MDk5YjQyODI2MzQ3ZTAxMjgyNjNiZjBhNzAwMDE=",
                    "description": "descr",
                    "fill": "abcdefghijklmnopqrstuvwxyz",
                    "name": "nummer twee",
                    "data":                     [
                                                {
                            "startLetter": "a",
                            "characters": "a"
                        },
                    ]
                },
            ],
            "VICOS": "http://localhost:8080/mpi/vicos",
            "user":             {
                "id": "MmM5MDkwYTIyMjk4MTNiOTAxMjJkZjQ0MDNiNTAwMDg=",
                "accesslevel": 10,
                "administrator": false,
                "name": "Huib Verweij"
            }
        },
        "requester": "SchemaEditor672",
        "status":         {
            "message": "At your service",
            "duration": "392",
            "insync": true,
            "success": true
        },
        "requestId": "7E64393B-3C7B-8C4A-4865-636694A480A3"
    }
-->
    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/lexus:get-schema/lexus:result/result"/>
        </object>
    </xsl:template>

    <xsl:template match="lexus:result/result">
        <object key="result">
            <xsl:apply-templates/>
        </object>
    </xsl:template>


    <xsl:template match="lexicon">
        <xsl:variable name="userId" select="/data/user/@id"/>
        <object key="lexicon">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="meta/name"/>
            </string>
            <string key="description">
                <xsl:value-of select="meta/description"/>
            </string>
            <xsl:choose>
                <xsl:when test="meta/owner[@ref eq $userId]">
                    <false key="shared"/>
                </xsl:when>
                <xsl:otherwise>
                    <true key="shared"/>
                </xsl:otherwise>
            </xsl:choose>
            <number key="size">
                <xsl:value-of select="size"/>
            </number>
            <xsl:choose>
                <xsl:when test="meta/users/user[@ref = $userId][permissions/write eq 'true']">
                    <true key="writable"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="writable"/>
                </xsl:otherwise>
            </xsl:choose>
        </object>
    </xsl:template>

    <!--<xsl:template name="sort-order">
        <xsl:param name="sort-order"/>
        <xsl:choose>
            <xsl:when test="$sort-order != ''">
                <string key="sortOrder">
                    <xsl:value-of select="@sortOrder"/>
                </string>
            </xsl:when>
            <xsl:otherwise>
                <null key="sortOrder"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->

    <xsl:template match="@* | node()"/>


</xsl:stylesheet>
