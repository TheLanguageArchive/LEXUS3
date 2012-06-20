<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    
    <xsl:param name="chunk-size" as="xs:integer" select="1000"/>
    
    <xsl:template match="lexus:update-lexicon-for-updated-schema">
        <xsl:call-template name="initiate">
            <xsl:with-param name="url" select="concat('cocoon:/updateChunkOfLexiconForUpdatedSchema/', /data/user/@id, '/', @id)"/>
            <xsl:with-param name="start" select="1"/>
            <xsl:with-param name="max" select=".//nr-of-lexical-entries"/>
        </xsl:call-template>
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template name="initiate">
        <xsl:param name="url" as="xs:string"/>
        <xsl:param name="start" as="xs:integer"/>
        <xsl:param name="max" as="xs:integer"/>

        <xsl:if test="$start lt $max">
            <include src="{$url}/{$start}/{$chunk-size}"
                xmlns="http://apache.org/cocoon/include/1.0"/>
            <xsl:if test="($start + $chunk-size) lt $max">
                <xsl:call-template name="initiate">
                    <xsl:with-param name="url" select="$url"/>
                    <xsl:with-param name="start" select="$start + $chunk-size"/>
                    <xsl:with-param name="max" select="$max"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
