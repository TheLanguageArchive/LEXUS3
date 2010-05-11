<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0" version="2.0">
    <!--
        
        Input is:
        <data>
            <json xmlns:json="http://apache.org/cocoon/json/1.0">
                <id>AF836C97-5C1A-3DA6-00A2-3E4F31CCE5F4</id>
                <requester>LexiconBrowser793</requester>
                <parameters>
                <lexicon>1</lexicon>
                <refiner>
                <startLetter/>
                <pageSize>25</pageSize>
                <startPage>0</startPage>
                </refiner>
                </parameters>
            </json>
            <user>...</user>
        </data>
        
        Generate the following information from the database:
        
        {
        "id": "Tue Apr 27 08:24:25 CEST 2010",
        "result":         {
            "lexus": null,
            "myResult":             {
                "total": 2,
                "startLetter": "",
                "lexicon":                 {
                    "id": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxODQ3ODAwYzY=",
                    "todos": [],
                    "description": "Uses Standard Format markers as defined in          \r\r_Making Dictionaries:\r\rA guide to lexicography and\r\rthe Multi-Dictionary Formatter_.\r\rDavid F. Coward, Charles E. Grimes, and\r\rMark Pedrotti.\r\rWaxhaw, NC: SIL, 1998. (Version 2.0)",
                    "administrator": false,
                    "writable": true,
                    "name": "???????? ???????????????? ???????? ",
                    "type": "myLexicon",
                    "note": null,
                    "shared": false
                },
                "count": 25,
                "lexicalEntries":                 [
                                        {
                        "id": "NTEyYWFkNmMtODQxMy00YjAzLWE1YzctZDIxODNhYmFjMzQ3",
                        "listView": {"value": "'aekw kasdf asd???? ??????????????????????????????"},
                        "entryView": "entryLayout.htm?id=NTEyYWFkNmMtODQxMy00YjAzLWE1YzctZDIxODNhYmFjMzQ3"
                    },
                                        {
                        "id": "NWNiYTM5YTYtYzYyMi00ZDc4LTk2ZGMtNDE3OWZlZDU2NDA1",
                        "listView": {"value": "'anu"},
                        "entryView": "entryLayout.htm?id=NWNiYTM5YTYtYzYyMi00ZDc4LTk2ZGMtNDE3OWZlZDU2NDA1"
                    }
                ],
                "startPage": 0
            },
            "sessionID": "EC1B6CADFBADD462065268D1CC601736",
            "lexica":             [
                                {
                    "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ3ZmRjZTRhNDU=",
                    "todos": [],
                    "description": "???? ?????????????",
                    "administrator": false,
                    "writable": true,
                    "name": "???????? 89 ?? Yeli D'nye!",
                    "type": "myLexicon",
                    "note": null
                }
            ],
            "VICOS": "http://localhost:8080/mpi/vicos",
            "startLetters":             [
                                {
                    "values": "Aa",
                    "label": "a"
                },
                                {
                    "values": "Bb",
                    "label": "b"
                }            ],
            "queries": [],
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
            ]
        },
        "requester": "LexiconBrowser16395",
        "status":         {
            "message": "At your service",
            "duration": "7715",
            "insync": true,
            "success": true
        },
        "requestId": "5C5BFF7E-8E42-7605-6C75-3DF01974EED6"
    }
        -->
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="endpoint"/>
    <xsl:param name="dbpath"/>

    <xsl:template match="/">
        <rest:request target="{$endpoint}{$dbpath}/lexica" method="POST">
            <rest:header name="Content-Type" value="text/xml; charset=UTF-8"/>
            <rest:body>
                <query xmlns="http://exist.sourceforge.net/NS/exist">
                    <text>
                        <xsl:call-template name="declare-namespace"/>                        
                        <xsl:call-template name="users"/>
                        
                        let $json := <xsl:apply-templates select="/data/json" mode="encoded"/>
                        let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                        let $lexiconId := '<xsl:value-of select="/data/json/parameters/lexicon"/>'
                        let $lexicon := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexicon[@id = $lexiconId]
                        let $startLetter := '<xsl:value-of select="/data/json/parameters/startLetter"/>'
                        let $pageSize := number('<xsl:value-of select="/data/json/parameters/refiner/pageSize"/>')
                        let $startPage := number('<xsl:value-of select="/data/json/parameters/refiner/startPage"/>')
                        let $lexi := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexus[meta/users/user/@ref = $user-id]
                        let $lexica := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexicon[@id = $lexi/@id]
                        let $vicosURL := '<xsl:value-of select="/data/vicos/URL"/>'
                        
                        let $lexicalEntries := if ($startLetter ne '') 
                                                   then $lexicon/lexical-entry[@start-letter eq $startLetter]
                                                   else $lexicon/lexical-entry
                        let $startLetters := distinct-values($lexicalEntries/@start-letter)
                        let $queries := ()
                        let $schema := ()
                        
                        return element result
                                    {
                                        element results {
                                            element startLetter { $startLetter },
                                            element lexicon { $lexicon/@*, $lexicon/lexicon-information, 
                                            $lexi[@id eq $lexicon/@id]/meta },
                                            element lexical-entries { $lexicalEntries[position() gt ($startPage * $pageSize)][position() le (($startPage + 1) * $pageSize)] },
                                            element startPage { $startPage }
                                        },
                                        element lexica {
                                            for $lexicon in $lexica
                                                order by $lexicon/lexicon-information/feat[@name = "name"]
                                                return element lexicon
                                                    {$lexicon/@*,
                                                    $lexicon/lexicon-information,
                                                    $lexi[@id eq $lexicon/@id]/meta,
                                                    element size {count($lexicon/lexical-entry)}}
                                        },
                                        element startLetters { $startLetters },
                                        element queries { $queries },
                                        element schema { $schema }
                                    }
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
