<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

    <xsl:import href="identity.xslt"/>
    <!-- 
        Extract data from the eXist response.
        Throw an exception when an exception element is found in the stream.
    -->
    <xsl:template match="exception">
        <xsl:message terminate="yes">
            <xsl:copy-of select="//exception"/>
        </xsl:message>
    </xsl:template>
    
    <!-- 
        Skip the rest:* stuff.
        -->
    <xsl:template match="rest:response">
        <xsl:apply-templates select="rest:body/*"/>
    </xsl:template>
    
    <xsl:template match="exist:result">
        <xsl:copy-of select="*"/>
    </xsl:template>

</xsl:stylesheet>
