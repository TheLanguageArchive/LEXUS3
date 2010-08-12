<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">
    <!--
        
        Input is:
        <data>
        <search>
        <lexicon>1</lexicon>
        <refiner>
        <startLetter/>
        <pageSize>25</pageSize>
        <startPage>0</startPage>
        </refiner>
        </search>
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
    
    <xsl:param name="lexica-collection"/>

    <xsl:template match="lexus:search">
        <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>                        
                <xsl:call-template name="users"/>                       
                <xsl:call-template name="lexicon"/>                       
                <xsl:call-template name="lexica"/>
                
                let $search := <xsl:apply-templates select="/data/lexus:search" mode="encoded"/>
                let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                let $lexiconId := $search/lexicon
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                let $startLetter := $search/startLetter
                let $pageSize := number($search/refiner/pageSize)
                let $startPage := number($search//refiner/startPage)
                let $lexi := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user/@ref = $user-id]
                
                let $lexicalEntries := if ($startLetter ne '') 
                                           then $lexus/lexicon/lexical-entry (: [@start-letter eq $startLetter] :)
                                           else $lexus/lexicon/lexical-entry
                let $startLetters := distinct-values($lexicalEntries/@start-letter)
                let $schema := $lexus/meta/schema
                
                return element result {
                    element results {
                        element startLetter { $startLetter },
                        lexus:lexicon($lexus),
                        element lexical-entries { $lexicalEntries[position() gt ($startPage * $pageSize)][position() le (($startPage + 1) * $pageSize)] },
                        element startPage { $startPage },
                        element count { count($lexicalEntries) },
                        element pageSize {$pageSize}
                    },                                        
                    lexus:lexica3($lexi),
                    element startLetters { $startLetters },
                    element queries { },
                    element schema { $schema }
                }
            </lexus:text>
        </lexus:query>
    </xsl:template>

</xsl:stylesheet>
