<?xml version="1.0" encoding="UTF-8"?>
<!--
   Remove components without actual content, e.g. just empty data-categories
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="component">
        <!-- marker is component with content so copy it -->
        <xsl:if test=".//data-category[@value]">
            <xsl:copy>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="node()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
