<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <object>
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="result">
        <object key="result">
            <string key="id">
                <xsl:value-of select="id"/>
            </string>
            <string key="tmpFile">
                <xsl:value-of select="tmpFile"/>
            </string>
            <string key="Filename">
                <xsl:value-of select="Filename"/>
            </string>
            <string key="mimeType">
                <xsl:value-of select="mimeType"/>
            </string>
            <string key="Filedata">
                <xsl:value-of select="Filedata"/>
            </string>
        </object>
    </xsl:template>
</xsl:stylesheet>
