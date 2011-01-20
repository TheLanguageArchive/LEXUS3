<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:dcr="http://www.isocat.org/ns/dcr"
    xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/" xmlns:ex="http://apache.org/cocoon/exception/1.0"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="#all" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 15, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p/>
            <xd:p>Report the status of the import, succes or failure.</xd:p>
        </xd:desc>
    </xd:doc>


    <!--
        If success eq 'true' (and there really really really were no errors), report success, otherwise failure.
    -->
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="lexus:result[@success eq 'true'] and not(//ex:exception-report)">
                <xsl:apply-templates select="lexus:result"/>
            </xsl:when>
            <xsl:otherwise>
                <result xmlns:lexus="http://www.mpi.nl/lexus" success="false">
                    <message><xsl:apply-templates select="//ex:exception-report"/></message>
                </result>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ex:exception-report">        
        <xsl:value-of select="ex:message"/> at line <xsl:value-of select="ex:location/@line"/> column <xsl:value-of select="ex:location/@column"/>.
    </xsl:template>

    <xsl:template match="lexus:*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
