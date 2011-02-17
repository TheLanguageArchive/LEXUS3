<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:jax-rx="http://jax-rx.sourceforge.net"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:import href="identity.xslt"/>
    <xsl:import href="encodeXML.xslt"/>



    <!-- HTTP PUT a new file to the server. -->
    <xsl:template match="rest:response[rest:status/@code = '201']" priority="1">
        <lexus:result success="true">
            <lexus:message>
                <xsl:value-of select="rest:body"/>
            </lexus:message>
        </lexus:result>
    </xsl:template>
    <!-- 
        Raise an error if there's a REST error.
    -->
    <xsl:template match="rest:response[not(starts-with(rest:status/@code, '2'))]" priority="1">
        <lexus:result success="false">
            <lexus:message>
                <xsl:apply-templates select="." mode="encoded"/>
            </lexus:message>
        </lexus:result>
    </xsl:template>


    <!-- 
        Skip the rest:* stuff.
        -->
    <xsl:template match="rest:response">
        <xsl:apply-templates select="rest:body/*"/>
    </xsl:template>

    <!-- 
        Extract data from the eXist response.
        Throw an exception when an exception element is found in the stream.
    -->
    <xsl:template match="exception">
        <lexus:result success="false">
            <lexus:message>
                <xsl:copy-of select="//exception"/>
            </lexus:message>
        </lexus:result>
    </xsl:template>
    
    <xsl:template match="exist:result">
        <lexus:result success="true"><xsl:copy-of select="*"/></lexus:result>
    </xsl:template>

    <!-- 
        Extract data from the BaseX response.
    -->
    <xsl:template match="jax-rx:results[not(jax-rx:result)]">
        <lexus:result success="true" />
    </xsl:template>

    <xsl:template match="jax-rx:results">
        <lexus:result success="true">
            <xsl:apply-templates select="jax-rx:result"/>
        </lexus:result>
    </xsl:template>
    
    <xsl:template match="jax-rx:result">
        <xsl:copy-of select="*"/>
    </xsl:template>

</xsl:stylesheet>