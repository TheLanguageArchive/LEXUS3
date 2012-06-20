<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//display:lexicon/lexical-entry/xhtml:html"/>
    </xsl:template>
    
    <xsl:template match="xhtml:*">
        <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
