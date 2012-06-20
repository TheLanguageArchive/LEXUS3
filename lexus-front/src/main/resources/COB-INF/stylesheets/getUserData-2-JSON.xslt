<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- 
        JSON to produce:
        {
        "id": "Thu Jun 10 08:16:00 CEST 2010",
        "result":         {
        "id": "MmM5MDkwYTIyMjk4MTNiOTAxMjJkZjQ0MDNiNTAwMDg=",
        "accesslevel": 10,
        "administrator": false,
        "name": "Huib Verweij"
        },
        "requester": "LexiconBrowser657",
        "status":         {
        "message": "At your service",
        "duration": "2",
        "insync": true,
        "success": true
        },
        "requestId": "BAF7F05D-A4EF-65B9-4AE5-2080351ED62B"
        }
    -->

    <xsl:template match="/">
        <object>
            <object key="result">
                <xsl:apply-templates select="user"/>
            </object>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="user">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="user">        
        <string key="id">
            <xsl:value-of select="@id"/>
        </string>
        <string key="name">
            <xsl:value-of select="name"/>
        </string>
        <number key="accesslevel">
            <xsl:value-of select="accesslevel"/>
        </number>
        <xsl:choose>
            <xsl:when test="number(accesslevel) eq 30">
                <true key="administrator"/>
            </xsl:when>
            <xsl:otherwise>
                <false key="administrator"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
