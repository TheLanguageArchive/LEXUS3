<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:archive="http://nl.mpi.lexus/archive"
    exclude-result-prefixes="#all" version="2.0">


    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/archive:get-object/archive:object"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/archive:get-object/archive:object">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="archive:get-object/archive:object">
        <object key="result">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="url">
                <xsl:value-of select="@url"/>
            </string>
            <string key="metadataURL">
                <xsl:value-of select="@metadataURL"/>
            </string>
            <string key="format">
                <xsl:value-of select="@format"/>
            </string>
            <string key="archiveHandle">
                <xsl:value-of select="@archiveHandle"/>
            </string>
        </object>
    </xsl:template>

    <xsl:template match="@* | node()"/>

</xsl:stylesheet>
