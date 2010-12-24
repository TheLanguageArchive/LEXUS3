<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="lexus:result"/>
    </xsl:template>

    <!-- 
        Copy the error.
    -->
    <xsl:template match="lexus:result[@success = 'false']">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="lexus:result[@success = 'true']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="user"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="user">
        <xsl:copy>
            <xsl:copy-of select="@* | name | account | accesslevel"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
