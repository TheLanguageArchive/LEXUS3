<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="/data">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <display:lexicon id="{lexus:search/lexus:result/result/results/lexicon/@id}" view="list-view">
                <xsl:apply-templates select="lexus:search/lexus:result/result/results/lexical-entries"/>
            </display:lexicon>
        </xsl:copy>
    </xsl:template>

    <!-- 
        Copy only the lexicon (meta) info from the lexus:search element.
        -->
    <xsl:template match="lexus:search">
        <xsl:copy-of select="lexus:result/result/results/lexicon"/>
    </xsl:template>
        
    
</xsl:stylesheet>
