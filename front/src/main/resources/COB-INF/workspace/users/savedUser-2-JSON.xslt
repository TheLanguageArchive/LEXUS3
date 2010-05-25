<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

    <!-- 
        JSON source to mimic:
        {
        "id": "Mon Feb 15 11:05:27 CET 2010",
        "result": {"lexicon":         {
        "shared": false,
        "id": "MmM5MDkwYTIxMmQ2N2UzNjAxMTJmNmEyMGNkYjdhZWM=",
        "description": "Standard Format markers defined in _Making Dictionaries: A guide to lexicography and the Multi-Dictionary Formatter_. David F. Coward, Charles E. Grimes, and Mark R. Pedrotti. Waxhaw, NC: SIL, 1998. (2nd edition) ",
        "administrator": false,
        "writable": true,
        "name": "test-tua.",
        "note": null,
        "size": 75,
        "readers": [            {
        "id": "MmM5MDkwYTIxMDBiNWZkYjAxMTAxMGM3NzYzNzAwMDc=",
        "accesslevel": 10,
        "administrator": false,
        "name": "marquesan"
        }],
        "writers": [            {
        "id": "MmM5MDkwYTIxMDBiNWZkYjAxMTAxMGM3NzYzNzAwMDc=",
        "accesslevel": 10,
        "administrator": false,
        "name": "marquesan"
        }]
        }},
        "requester": "Workspace9174",
        "status":         {
        "message": "At your service",
        "duration": "20",
        "insync": true,
        "success": true
        },
        "requestId": "EDCB71FE-5D9E-797F-42F2-D116F299FB86"
        }
    -->
    
    <xsl:template match="/">
        <object><xsl:apply-templates /></object>
    </xsl:template>
    
    <xsl:template match="result">
        <object key="result"><xsl:apply-templates /></object>
    </xsl:template>
    
    <xsl:template match="user">
        <xsl:variable name="userId" select="/result/user/@id"/>
        <object key="user">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="name"/>
            </string>            
        </object>
        
    </xsl:template>
    
    <xsl:template match="@* | node()"/>
    
</xsl:stylesheet>
