<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <!-- 
        If the sort order will be saved, we'll need to give it back to the JSON client. WHY?!, this needs a fix later on. Anyway.
        We'll duplicate the sort order here so we can return it to the client later on if everything went allright.
        -->

    <xsl:template match="lexus:save-sortorder">
        <xsl:copy-of select="."/>
        <xsl:element name="lexus:saved-sortorder" namespace="http://www.mpi.nl/lexus">
            <xsl:copy-of select="@*|node()"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
