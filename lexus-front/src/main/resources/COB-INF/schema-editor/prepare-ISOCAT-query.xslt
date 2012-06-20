<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:import href="../util/identity.xslt"/>
    
    <xsl:param name="endpoint"/>

    <xsl:template match="/">
        <xsl:apply-templates select="data/json"/>    
    </xsl:template>
    
    <xsl:template match="json">    
        <xsl:variable name="url">
            <xsl:value-of select="$endpoint"/>
            <xsl:text>?keywords=</xsl:text>
            <xsl:value-of select="encode-for-uri(parameters/keywords)"/>
            <xsl:text>&amp;fields=</xsl:text>
            <xsl:value-of select="encode-for-uri(parameters/fields)"/>
            <xsl:text>&amp;match=like&amp;scope-public&amp;mode=domains</xsl:text>
        </xsl:variable>
        <rest:request target="{$url}" method="GET">
<!--            <rest:header name="Content-Type" value="application/query+xml; charset=UTF-8"/>-->
            <rest:header name="Accept" value="application/dcif+xml; charset=UTF-8"/>
            <rest:body>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
