<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:display="http://www.mpi.nl/lexus/display/1.0" exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 7, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Process search results</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="lexus:result[@success eq 'true']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="search-results/lexicon">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <display:lexicon id="@id" view="list-view">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*"/>
            </display:lexicon>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
