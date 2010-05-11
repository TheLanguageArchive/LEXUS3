<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

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
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="/result">
        <object key="result">
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="/result/users"/>


    <xsl:template match="@* | node()"/>
        
    
</xsl:stylesheet>
