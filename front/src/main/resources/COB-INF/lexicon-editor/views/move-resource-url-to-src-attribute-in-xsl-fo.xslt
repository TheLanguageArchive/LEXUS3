<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:rr="http://nl.mpi.lexus/resource-resolver"
    xmlns:display="http://www.mpi.nl/lexus/display/1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="fo:external-graphic[starts-with(@src, 'resource:')]">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="src" select="concat('url(', rr:resource-id-to-url/rr:local, ')')"/>
            <!--            <xsl:attribute name="src" select="."/>-->
            <!--            <xsl:attribute name="src" select="concat('url(''', ., ''')')"/>-->
            <xsl:copy-of select="@*[local-name() ne 'src']"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
