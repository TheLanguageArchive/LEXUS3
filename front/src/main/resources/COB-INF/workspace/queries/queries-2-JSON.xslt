<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:include href="element-queries-2-JSON.xslt"/>
    <!-- 

    original app's JSON to mimic (but leave out stuff that's unnecessary, like "fill"):
    {
    "id": "Mon Apr 26 17:24:59 CEST 2010",
    "result": {"queries": [...
    ]},
    "requester": "Workspace58",
    "status":         {
    "message": "At your service",
    "duration": "222",
    "insync": true,
    "success": true
    },
    "requestId": "A25F1CD8-79FB-172C-71D4-3AB8A4F82348"
    }
    
-->

    <xsl:template match="/">
        <object>
            <object key="result">
                <xsl:apply-templates select="*"/>
            </object>
        </object>
    </xsl:template>
</xsl:stylesheet>
