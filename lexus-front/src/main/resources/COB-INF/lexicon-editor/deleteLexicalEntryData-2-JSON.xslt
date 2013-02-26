<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">

    <!-- 
        JSON to produce:
        
        {
        "id": "Tue Nov 16 15:52:36 CET 2010",
        "result": {"id": "MmM5MDkwYTIyNDI5YzhhNTAxMjQyZTJkZTViMTAwMmU="},
        "requester": "LexiconBrowser792",
        "status":         {
        "message": "At your service",
        "duration": "411",
        "insync": true,
        "success": true
        },
        "requestId": "306552D4-3C90-5B17-3D13-552C4FC2AD7E"
        }
        
        <object xmlns:lexus="http://www.mpi.nl/lexus" xmlns:rr="http://nl.mpi.lexus/resource-resolver" xmlns:xhtml="http://www.w3.org/1999/xhtml">
            <object key="result">
                <string key="id">uuid:d11f9f0f-7530-4453-b5ff-28c8cfb13761</string>
            </object>
            <object key="status">
                <true key="success"/>
            </object>
        </object>
        
    -->

    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/lexus:delete-lexical-entry/lexus:result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/lexus:delete-lexical-entry/lexus:result[@success = 'true']">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="lexus:delete-lexical-entry/lexus:result">
        <object key="result">
            <string key="id">
                <xsl:value-of select="/data/json/parameters/lexicalEntry/id"/>
            </string>
        </object>
    </xsl:template>

    <xsl:template match="@* | node()"/>

</xsl:stylesheet>
