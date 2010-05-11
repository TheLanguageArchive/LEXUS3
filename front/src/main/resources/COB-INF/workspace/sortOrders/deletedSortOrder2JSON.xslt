<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- 

    original app's JSON to mimic (but leave out stuff that's unnecessary, like "fill"):
    
-->

    <xsl:template match="/">
        <object>
            <object key="result">
                <object key="status">
                    <string key="success">
                        <xsl:choose>
                            <xsl:when test="result">true</xsl:when>
                            <xsl:otherwise>false</xsl:otherwise>
                        </xsl:choose>
                    </string>
                </object>
            </object>
        </object>
    </xsl:template>
</xsl:stylesheet>
