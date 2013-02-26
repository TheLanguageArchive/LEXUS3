<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:archive="http://nl.mpi.lexus/archive"
    exclude-result-prefixes="xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 3, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Prepare to get object from the archive</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:template match="json">
        <archive:get-object id="{parameters/id}"/>
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>