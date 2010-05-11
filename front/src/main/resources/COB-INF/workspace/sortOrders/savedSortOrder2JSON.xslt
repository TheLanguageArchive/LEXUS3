<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- 

    original app's JSON to mimic (but leave out stuff that's unnecessary, like "fill"):
    {
    "id": "Mon Apr 26 17:01:27 CEST 2010",
    "result": {"sortOrder":         {
    "id": "MmM5MDk5YjEyODNhYTFlNzAxMjgzYWEzMTlkOTAwMDE=",
    "description": "qwqwqwqwqwqw",
    "fill": "abcdefghijklmnopqrstuvwxyz",
    "name": "qwqwqwqwqw",
    "data":             [
    {
    "startLetter": "a",
    "characters": "a"
    },
    {
    "startLetter": "b",
    "characters": "b"
    },
    {
    "startLetter": "c",
    "characters": "c"
    }
    ]
    }},
    "requester": "workspace",
    "status":         {
    "message": "At your service",
    "duration": "17",
    "insync": true,
    "success": true
    },
    "requestId": "A65D6F11-3379-0004-BBA9-3AA319CA9FCA"
    }
-->

    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="result"/>
            <object key="status">
                <string key="success">
                    <xsl:choose>
                        <xsl:when test="result/sortorder">true</xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                </string>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="result">
        <object key="result">
            <object key="sortOrder">
                <xsl:apply-templates select="sortorder/@* | sortorder/*"/>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="@id">
        <string key="id">
            <xsl:value-of select="."/>
        </string>
    </xsl:template>

    <xsl:template match="name|description">
        <string key="{local-name(.)}">
            <xsl:value-of select="."/>
        </string>
    </xsl:template>

    <xsl:template match="mappings">
        <array key="data">
            <xsl:apply-templates select="mapping"/>
        </array>
    </xsl:template>

    <xsl:template match="mapping">
        <object>
            <string key="startLetter">
                <xsl:value-of select="to"/>
            </string>
            <string key="characters">
                <xsl:value-of select="from"/>
            </string>
        </object>
    </xsl:template>
</xsl:stylesheet>
