<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

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
        <object><xsl:apply-templates select="/data/lexus:get-saved-lexicon/lexus:result/result"/></object>
    </xsl:template>
    
    <xsl:template match="result">
        <object key="result"><xsl:apply-templates /></object>
    </xsl:template>
    
    <xsl:template match="lexicon">
        <xsl:variable name="userId" select="/data/user/@id"/>
        <object key="lexicon">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="../lexus/meta/name"/>
            </string>
            <string key="description">
                <xsl:value-of select="../lexus/meta/description"/>
            </string>
            <string key="note">
                <xsl:value-of select="../lexus/meta/note"/>
            </string>
            <xsl:choose>
                <xsl:when test="../lexus/meta/owner[@ref eq $userId]">
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
                    test="../lexus/meta/users/user[@ref = $userId][permissions/write eq 'true']">
                    <true key="writable"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="writable"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <array key="readers">
                <xsl:apply-templates
                    select="../lexus/meta/users/user[permissions/read eq 'true']"/>
            </array>
            
            <array key="writers">
                <xsl:apply-templates
                    select="../lexus/meta/users/user[permissions/write eq 'true']"/>
            </array>
            
        </object>
        
    </xsl:template>
    
    <xsl:template match="user | users"/>
        
    <xsl:template match="user[@ref]">
        <xsl:variable name="id" select="@ref"/>
        <object>
            <string key="id">
                <xsl:value-of select="$id"/>
            </string>
            <string key="name">
                <xsl:value-of select="/data/lexus:get-saved-lexicon/lexus:result/users/user[@id eq $id]/name"/>
            </string>
            <number key="accesslevel">
                <xsl:value-of select="/data/lexus:get-saved-lexicon/lexus:result/users/user[@id eq $id]/accesslevel"/>
            </number>
            <xsl:choose>
                <xsl:when test="number(/data/lexus:get-saved-lexicon/lexus:result/users/user[@id=$id]/accesslevel) eq 30">
                    <true key="administrator"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="administrator"/>
                </xsl:otherwise>
            </xsl:choose>
        </object>
    </xsl:template>
    
    <xsl:template match="@* | node()"/>
        
    
</xsl:stylesheet>
