<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:template match="/">
        <xsl:apply-templates select="/data/lexus:get-views/lexus:result/views"/>
    </xsl:template>

    <xsl:template match="views">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="view"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="view">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
