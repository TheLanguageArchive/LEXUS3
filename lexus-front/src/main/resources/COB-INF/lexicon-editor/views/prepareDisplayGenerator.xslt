<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="/data">
        <xsl:copy>
            <xsl:copy-of select="@* | node()"/>
            <display:lexicon id="{lexus:search/lexus:result/result/results/lexicon/@id}" view="list-view">
                <xsl:apply-templates select="lexus:search/lexus:result/result/results/lexical-entries"/>
            </display:lexicon>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
