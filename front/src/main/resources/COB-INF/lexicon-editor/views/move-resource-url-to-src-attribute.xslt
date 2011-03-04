<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:rr="http://nl.mpi.lexus/resource-resolver" 
    xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    
    <xsl:template match="xhtml:img[starts-with(@src, 'resource:')]">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="src" select="."/>
            <xsl:copy-of select="@*[local-name() ne 'src']"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
