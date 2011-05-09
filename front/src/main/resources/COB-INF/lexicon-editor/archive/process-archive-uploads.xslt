<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:archive="http://nl.mpi.lexus/archive"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="archive:get-object[archive:object]">
        <xsl:apply-templates select="archive:object"/>
    </xsl:template>
    <xsl:template match="archive:get-object"/>
    
    <xsl:template match="archive:object">        
        <resource archive="MPI" mimetype="{@format}" 
            value="{@archiveHandle}">
            <xsl:copy-of select="@archiveHandle | @metadataURL | @type"/>
            <url><xsl:value-of select="@url"/></url>
        </resource>
    </xsl:template>
</xsl:stylesheet>
