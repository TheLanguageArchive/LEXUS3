<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>"Deleted a query" written as JSON response.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:include href="../../util/identity.xslt"/>


    <xsl:template match="/">
        <object>
            <object key="result">
                <xsl:if test="data/lexus:delete-query/lexus:result[@success eq 'true']">
                    <string key="id">
                        <xsl:value-of select="data/json/parameters/query/id"/>
                    </string>
                </xsl:if>
            </object>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/lexus:delete-query/lexus:result[@success eq 'true']">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>

</xsl:stylesheet>
