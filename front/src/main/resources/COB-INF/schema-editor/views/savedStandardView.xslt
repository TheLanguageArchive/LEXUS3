<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:util="java:java.util.UUID" version="2.0">

    <xsl:param name="lexicon" select="''"/>

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="/">
        <xsl:copy-of select="/data/lexus:save-standard-view/lexus:result/view"/>
    </xsl:template>

</xsl:stylesheet>
