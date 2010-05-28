<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="id"/>
    <xsl:param name="name"/>
    <xsl:param name="account"/>
    <xsl:param name="accesslevel"/>

    <xsl:template match="/user">
        <xsl:copy>
            <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="name">
        <xsl:copy><xsl:value-of select="$name"/></xsl:copy>
    </xsl:template>
    
    <xsl:template match="account">
        <xsl:copy><xsl:value-of select="$account"/></xsl:copy>
    </xsl:template>
    
    <xsl:template match="accesslevel">
        <xsl:copy><xsl:value-of select="$accesslevel"/></xsl:copy>
    </xsl:template>
</xsl:stylesheet>
