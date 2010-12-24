<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" 
    version="2.0">

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

    <!-- 
            Transform this:
            <schema>
            <container id="uuid:67a9c4d1-7fb1-4c4a-b3a8-c67a494e449a" description="The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry" name="Lexicon" mandatory="true" multiple="false" type="lexicon">
            <container id="uuid:ef64b80b-5aad-4392-9265-296000ccd87b" description="Contains administrative information and other general attributes" name="Lexicon Information" type="lexicon-information" mandatory="true" multiple="false"/>
            <container id="uuid:9e1dbc3c-55d1-4ba2-96b8-391f779a16ab" description="Represents a word, a multi-word expression, or an affix in a given language" name="lexical-entry" mandatory="true" multiple="true" type="lexical-entry">
            <container id="uuid:6b9f1ff4-6349-4c08-96ad-d04d29533813" description="Represents one lexical variant of the written or spoken form of the lexical entry" name="Form" mandatory="true" multiple="false" type="form"/>
            <container id="uuid:c27cd277-9852-4fd8-94bb-7909e25fdd8c" description="Contains attributes that describe meanings of a lexical entry" name="Sense" mandatory="true" multiple="false" type="sense"/>
            </container>
            </container>
            </schema>
            to this:
            "mySchema":             [
            {
            "min": 0,
            "max": null,
            "sortOrder": null,
            "parent": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2VjNDAwNDA=",
            "DCRReference": "xe",
            "type": "data category",
            "id": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2VjNDAwNDI=",
            "adminInfo": null,
            "valuedomain": [],
            "description": "This provides the English translation of the example sentence given in the \\xv field.",
            "DCR": "user defined",
            "name": "Example free trans. (E)",
            "note": null
            },
        -->
    <xsl:template match="schema">
        <!--        <object key="schema">-->
        <xsl:apply-templates select="container"/>
        <!--        </object>-->
    </xsl:template>

    <!-- 
            {
            "min": 1,
            "adminInfo": "to be filled out ",
            "id": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDc2ZDAwMDY=",
            "max": 1,
            "description": null,
            "name": "lexicon",
            "parent": null,
            "type": "Lexicon",
            "note": null
            }
        -->
    <xsl:template match="container[@type='lexicon']" priority="10">
        <object key="schema">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <number key="min">1</number>
            <number key="max">1</number>
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="type">Lexicon</string>
            <string key="name">lexicon</string>
            <null key="parent"/>
            <string key="note"/>
            <xsl:if test="container">
                <array key="children">
                    <xsl:apply-templates select="container"/>
                </array>
            </xsl:if>
        </object>
    </xsl:template>

    <!-- 
            {
            "min": 1,
            "adminInfo": null,
            "id": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDdhMzAwMGU=",
            "max": 1,
            "description": null,
            "name": "lexiconInformation",
            "parent": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDc2ZDAwMDY=",
            "type": "component",
            "note": null
            }
        -->
    <!--<xsl:template match="container[@type='lexicon-information']" priority="10">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <number key="min">1</number>
            <number key="max">1</number>
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="type">component</string>
            <string key="name">lexiconInformation</string>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="note"/>
            <xsl:if test="container">
                <array key="children">
                <xsl:apply-templates select="container"/>
                </array>
            </xsl:if>
        </object>
    </xsl:template>-->

    <!-- 
            {
            "min": 0,
            "adminInfo": null,
            "id": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDc2ZTAwMDg=",
            "max": null,
            "description": null,
            "name": "lexicalEntry",
            "parent": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDc2ZDAwMDY=",
            "type": "LexicalEntry",
            "note": null
            }-->
    <xsl:template match="container[@type='lexical-entry']" priority="10">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <number key="min">1</number>
            <null key="max"/>
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="type">LexicalEntry</string>
            <string key="name">lexicalEntry</string>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="note"/>
            <xsl:if test="container">
                <array key="children">
                    <xsl:apply-templates select="container"/>
                </array>
            </xsl:if>
        </object>
    </xsl:template>

    <!-- 
            {
            "min": 0,
            "max": null,
            "sortOrder": null,
            "parent": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2VjNDAwNDA=",
            "DCRReference": "xe",
            "type": "data category",
            "id": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2VjNDAwNDI=",
            "adminInfo": null,
            "valuedomain": [],
            "description": "This provides the English translation of the example sentence given in the \\xv field.",
            "DCR": "user defined",
            "name": "Example free trans. (E)",
            "note": null
            }
        -->
    <xsl:template match="container[@type eq 'data']" priority="10">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <xsl:choose>
                <xsl:when test="@sort-order">
                    <object key="sortOrder">
                        <string key="id">
                            <xsl:value-of select="@sort-order"/>
                        </string>
                    </object>
                </xsl:when>
                <xsl:otherwise>
                    <null key="sortOrder"/>
                </xsl:otherwise>
            </xsl:choose>
            <number key="min">
                <xsl:choose>
                    <xsl:when test="@mandatory eq 'true'">
                        <xsl:text>1</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </number>
            <xsl:choose>
                <xsl:when test="@multiple eq 'false'">
                    <number key="max">
                        <xsl:text>1</xsl:text>
                    </number>
                </xsl:when>
                <xsl:otherwise>
                    <null key="max"/>
                </xsl:otherwise>
            </xsl:choose>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="type">data category</string>
            <string key="name">
                <xsl:value-of select="@name"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="DCR">
                <xsl:choose>
                    <xsl:when test="@registry eq 'ISO-12620'">
                        <xsl:text>12620</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@registry"/>
                    </xsl:otherwise>
                </xsl:choose>
            </string>
            <string key="DCRReference">
                <xsl:value-of select="@reference"/>
            </string>
            <!--            <xsl:call-template name="sort-order"><xsl:with-param name="sort-order" select="@sort-order"/></xsl:call-template>-->
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
            <array key="valuedomain">
                <xsl:apply-templates select="valuedomain/domainvalue"/>
            </array>
        </object>
    </xsl:template>

    <xsl:template match="domainvalue">
        <object>
            <string key="value">
                <xsl:value-of select="."/>
            </string>
        </object>
    </xsl:template>

    <xsl:template match="container[container]" priority="1">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <number key="min">
                <xsl:choose>
                    <xsl:when test="@mandatory eq 'true'">
                        <xsl:text>1</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </number>
            <xsl:choose>
                <xsl:when test="@multiple eq 'false'">
                    <number key="max">
                        <xsl:text>1</xsl:text>
                    </number>
                </xsl:when>
                <xsl:otherwise>
                    <null key="max"/>
                </xsl:otherwise>
            </xsl:choose>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="type">component</string>
            <string key="name">
                <xsl:value-of select="@name"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="DCR">
                <xsl:choose>
                    <xsl:when test="@registry eq 'ISO-12620'">
                        <xsl:text>12620</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@registry"/>
                    </xsl:otherwise>
                </xsl:choose>
            </string>
            <string key="DCRReference">
                <xsl:value-of select="@reference"/>
            </string>
            <string key="sortOrder">
                <xsl:value-of select="@sortOrder"/>
            </string>
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
            <array key="children">
                <xsl:apply-templates select="container"/>
            </array>

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

    <xsl:template name="sort-order">
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
    </xsl:template>

    <xsl:template match="@* | node()"/>


</xsl:stylesheet>
