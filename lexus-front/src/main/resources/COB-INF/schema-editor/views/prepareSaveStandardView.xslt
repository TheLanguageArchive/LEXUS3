<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:util="java:java.util.UUID" version="2.0">

    <xsl:param name="standardView" select="''"/>
    <xsl:param name="lexiconId" select="''"/>
    <xsl:param name="viewId" select="''"/>

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="standardViews">
            <lexus:save-standard-view lexicon="{$lexiconId}">
                <xsl:copy-of select="."/>
            </lexus:save-standard-view>
            <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
