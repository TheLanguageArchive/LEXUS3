<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:rr="http://nl.mpi.lexus/resource-resolver" 
    xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:include href="identity.xslt"/>
    
    <xsl:template match="rr:resource-id-to-url">
        <xsl:value-of select="rr:remote"/>
    </xsl:template>
    
</xsl:stylesheet>
