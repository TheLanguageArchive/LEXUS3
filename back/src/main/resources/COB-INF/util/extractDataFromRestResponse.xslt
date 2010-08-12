<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:jax-rx="http://jax-rx.sourceforge.net"
    version="2.0">

    <xsl:import href="identity.xslt"/>
    <xsl:import href="encodeXML.xslt"/>

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
        Raise an error if there's a REST error.
    -->
    <xsl:template match="rest:response[rest:status/@code != '200']">
        <xsl:message terminate="yes">
            <xsl:apply-templates select="." mode="encoded"/>
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

    <xsl:template match="jax-rx:results[not(jax-rx:result)]">
        <empty-rest-result because="it must be an updating expression"/>
    </xsl:template>

    <xsl:template match="jax-rx:results">
        <xsl:choose>
            <xsl:when test="count(jax-rx:result) &gt; 1">
                <result>
                    <xsl:apply-templates select="jax-rx:result"/>
                </result>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="jax-rx:result"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="jax-rx:result">
        <xsl:copy-of select="*"/>
    </xsl:template>

</xsl:stylesheet>
