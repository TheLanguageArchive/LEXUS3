<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <!-- 
        JSON to produce:
        
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
        },
        {
        "id": "MmM5MDkwYTIyNDI5YzhhNTAxMjQyZTJjOWM3NzAwMGY=",
        "todos": [],
        "description": "Leuke beschrijving zeg: ?????????",
        "administrator": false,
        "writable": true,
        "name": "??????? ??????? ???????? ????? ??????? ??????? ?????????",
        "type": "myLexicon",
        "note": null
        },
        {
        "id": "MmM5MDkwYzMyNjIzMGViZDAxMjYyN2ZiMTE4YzAwYjQ=",
        "todos": [],
        "description": "??????? ??????? ??????? ???????? ???????? ???????? ????",
        "administrator": false,
        "writable": true,
        "name": "???? ???????????????? ???? ????",
        "type": "myLexicon",
        "note": null
        },
        {
        "id": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxODQ3ODAwYzY=",
        "todos": [],
        "description": "Uses Standard Format markers as defined in          \r\r_Making Dictionaries:\r\rA guide to lexicography and\r\rthe Multi-Dictionary Formatter_.\r\rDavid F. Coward, Charles E. Grimes, and\r\rMark Pedrotti.\r\rWaxhaw, NC: SIL, 1998. (Version 2.0)",
        "administrator": false,
        "writable": true,
        "name": "???????? ???????????????? ???????? ",
        "type": "myLexicon",
        "note": null
        },
        {
        "id": "MmM5MDkwYTIyMjk4MTNhMzAxMjJlZjYxMzRmNTA2NmU=",
        "todos": [],
        "description": "demo lexicon",
        "administrator": false,
        "writable": true,
        "name": "?????????????????.????????????",
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
        }
        ],
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
        {
        "min": 0,
        "adminInfo": null,
        "id": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2ViYjAwMGU=",
        "max": null,
        "description": "help to structure",
        "name": "homonym number dummy valueGroup",
        "parent": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2ViYTAwMGM=",
        "type": "component",
        "note": null
        }            ]
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
    
    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="result"/>
            <object key="status">
                <string key="success">
                    <xsl:choose>
                        <xsl:when test="result/results">true</xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                </string>
            </object>
        </object>
    </xsl:template>
    
    <xsl:template match="result">
        <object key="result">
            <xsl:apply-templates />
        </object>
    </xsl:template>
    
    <xsl:template match="results">
        <object key="myResult">
            <number key="total"><xsl:value-of select="count(lexical-entries/lexical-entry)"/></number>
            <xsl:apply-templates />
        </object>
    </xsl:template>
    
    <xsl:template match="startLetter">        
        <string key="startLetter"><xsl:value-of select="startLetter"/></string>
    </xsl:template>
    
    <xsl:template match="lexicon">
        <xsl:variable name="userId" select="/result/user/@id"/>
        <object key="lexicon">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="lexicon-information/feat[@name = 'name']"/>
            </string>
            <string key="description">
                <xsl:value-of select="lexicon-information/feat[@name = 'description']"/>
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
                <xsl:when
                    test="meta/users/user[@ref = $userId][permissions/write eq 'true']">
                    <true key="writable"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="writable"/>
                </xsl:otherwise>
            </xsl:choose>            
        </object>        
    </xsl:template>
    
    <xsl:template match="lexical-entries">
        <number key="count"><xsl:value-of select="count(lexical-entry)"/></number>
        <array key="lexicalEntries"><xsl:apply-templates select="lexical-entry"/></array>
    </xsl:template>
    
    <xsl:template match="lexical-entry">
        <object></object>
    </xsl:template>
    
    <xsl:template match="@* | node()"/>

</xsl:stylesheet>
