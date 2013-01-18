<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:param name="view" select="'list-view'"/>
    
    <xsl:template match="/data">
        <xsl:copy>
            <xsl:copy-of select="@* | node()"/>
            <display:lexicon id="{lexus:get-lexical-entry/lexus:result/result/@lexicon}" view="{$view}">
                <xsl:apply-templates select="lexus:get-lexical-entry/lexus:result/result/lexical-entry"/>
            </display:lexicon>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
