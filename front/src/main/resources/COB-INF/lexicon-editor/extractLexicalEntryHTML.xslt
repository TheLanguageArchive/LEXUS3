<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:template match="/">
        <xsl:copy-of select="/data/lexus:display/lexical-entry/xhtml:html"/>
    </xsl:template>

</xsl:stylesheet>
