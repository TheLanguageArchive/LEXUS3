<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="/data">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <lexus:display>
                <xsl:apply-templates select="lexus:search/result/results/lexical-entries"/>
            </lexus:display>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="lexical-entry">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <display:lexical-entry>
                <xsl:apply-templates select="*"/>
            </display:lexical-entry>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
