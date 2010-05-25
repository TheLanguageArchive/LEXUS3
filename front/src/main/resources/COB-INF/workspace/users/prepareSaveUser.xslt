<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="data">
        <xsl:copy>
            <xsl:apply-templates select="json"/>
            <xsl:copy-of select="user"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="json">
        <user>
            <xsl:apply-templates select="parameters/*"/>
        </user>
    </xsl:template>

</xsl:stylesheet>
