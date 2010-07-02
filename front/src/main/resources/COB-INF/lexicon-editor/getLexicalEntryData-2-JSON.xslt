<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- 
        JSON to produce:
        
        {
        "id": "Tue Jun 01 14:28:16 CEST 2010",
        "result": {"lexicalEntry":         {
        "id": "MmM5MDkwYTIxZjhlYTJkMzAxMjA2YmViODlmMTdhMDY=",
        "children":             [
        {
        "id": "MmM5MDkwYTIxZjhlYTJkMzAxMjA2YmViODlmNDdhYzg=",
        "value": "To be specified",
        "schemaElementId": "MmM5MDkwYTIxZjhlYTJkMzAxMjA2YjE3ZTY5MTc2YTY=",
        "label": "partOFSpeech",
        "notes": null
        }        ],
        "schemaElementId": "MmM5MDkwYTIxZjhlYTJkMzAxMjA2YWVkMmM4Njc2NmQ=",
        "label": "lexicalEntry",
        "notes": null,
        "listView": {"value": "To be specified"},
        "entryView": "entryLayout.htm?id=MmM5MDkwYTIxZjhlYTJkMzAxMjA2YmViODlmMTdhMDY="
        }},
        "requester": "LexiconBrowser862",
        "status":         {
        "message": "At your service",
        "duration": "975",
        "insync": true,
        "success": true
        },
        "requestId": "C7913F51-2842-A189-35D6-F37BCBD08D08"
        }
    -->

    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="result/lexical-entry">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="result">
        <object key="result">
            <xsl:apply-templates select="lexical-entry"/>
        </object>
    </xsl:template>

    <xsl:template match="lexical-entry">
        <object key="lexicalEntry">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="schemaId">
                <xsl:value-of select="@schema-id"/>
            </string>
            <xsl:if test="component">
                <array key="children"><xsl:apply-templates select="component"/></array>
            </xsl:if>
            <string key="label"><xsl:value-of select="/result/schema//component[@id = current()/@schema-id]/@name"/></string>
        </object>
        <xsl:apply-templates select="schema"/>
    </xsl:template>

    <xsl:template match="component">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="schemaId">
                <xsl:value-of select="@schema-id"/>
            </string>
            <xsl:if test="component">
                <array key="children"><xsl:apply-templates select="component"/></array>
            </xsl:if>
            <string key="label"><xsl:value-of select="/result/schema//component[@id = current()/@schema-id]"/></string>
        </object>
    </xsl:template>

    <xsl:template match="@* | node()"/>

</xsl:stylesheet>
