<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:util="java:java.util.UUID"
    exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> March 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Delete a query.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="../../util/identity.xslt"/>
    
    <xsl:template match="json">
        <xsl:copy-of select="."/>
        <lexus:delete-query>
            <xsl:copy-of select="parameters/query/id"/>
            <xsl:copy-of select="parameters/lexicon"/>
        </lexus:delete-query>
    </xsl:template>
    
</xsl:stylesheet>
