<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Generate the index.html page. May include a message, about unsuccessful login for
                instance. Messages are referred to by number using the $msg parameter. Messages are
                stored in the index.xml file.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:param name="msg" select="'0'"/>


    <!--
        Hide or show the <div id="msg"/> element.
        The javascript function looks like this:
        function displayMessage() {
            var msg = document.getElementById("msg");
            msg.style.display = "]]><display-msg/><![CDATA[";
        }
    -->
    <xsl:template match="display-msg">
        <xsl:choose>
            <xsl:when test="$msg eq '0' or $msg eq ''">
                <xsl:text>none</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>block</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
        Output a message using a msg number.
        -->
    <xsl:template match="div[@class eq 'msg']">
        <xsl:if test="$msg ne '0'">
            <xsl:copy>
                <xsl:apply-templates select="@*"/>
                <xsl:value-of select="//msgs/msg[@id eq $msg]"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--
        Skip the messages in the output HTML.
    -->
    <xsl:template match="msgs"/>


    <!--
        Copy everything else verbatim.
        -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>
