<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        <data>
        <lexus:search>
        <lexicon>1</lexicon>
        <refiner>
        <startLetter/>
        <pageSize>25</pageSize>
        <startPage>0</startPage>
        </refiner>
        </lexus:search>
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
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:search">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
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
                   let $startLetter := data($search/refiner/startLetter)
                   let $searchTerm := data($search/refiner/searchTerm)
                   let $pageSize := number($search/refiner/pageSize)
                   let $startPage := number($search//refiner/startPage)
                   let $lexi := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user/@ref = $user-id]
                   let $listView := $lexus/meta/views/view[@id eq $lexus/meta/views/@listView]
                   let $firstDataCategoryId := ($listView//data[@type eq 'data category'])[1]/@id
                   
                   let $sortOrderDCs := for $le in $lexus/lexicon/lexical-entry return ($le//data[@schema-ref eq $firstDataCategoryId])[1]
                   let $sLValues := for $sodc in $sortOrderDCs return substring($sodc/value, 1, 1)
                   let $startLetters := for $sl in distinct-values($sLValues) return element startLetter { $sl }
                   let $lexicalEntries := if ($startLetter ne '') 
                        then for $sodc in $sortOrderDCs return if (substring($sodc/value, 1, 1) eq $startLetter) then $sodc/ancestor::lexical-entry else ()
                        else for $l in $lexus/lexicon/lexical-entry let $d := $l//data[@sort-key] order by $d[1]/@sort-key return $l
                   let $searchedLexicalEntries := if ($searchTerm eq '')
                        then $lexicalEntries
                        else for $l in $lexicalEntries return if ($l//value[text() contains text {concat('.*', $searchTerm, '.*')} using wildcards]) then $l else ()
                   let $schema := $lexus/meta/schema
                   let $users := lexus:users(collection('<xsl:value-of select="$users-collection"/>')/user[@id = distinct-values($lexus/meta/users/user/@ref)])
                   
                   return element result {
                       element results {
                           element startLetter { $startLetter },
                           lexus:lexicon($lexus),
                           element lexical-entries { subsequence($searchedLexicalEntries,($startPage * $pageSize), $pageSize) },
                           element startPage { $startPage },
                           element searchTerm { $searchTerm },
                           element count { count($searchedLexicalEntries) },
                           element pageSize {$pageSize}
                       },                                        
                       lexus:lexica($lexi),
                       element startLetters { $startLetters },
                       element queries { },
                       $schema,
                       $users
                   }
               </lexus:text>
          </lexus:query>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
