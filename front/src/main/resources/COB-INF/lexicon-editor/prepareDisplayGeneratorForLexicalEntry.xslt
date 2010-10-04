<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="/data">
        <xsl:copy>
            <xsl:copy-of select="@* | node()"/>
            <lexus:display>
                <xsl:apply-templates select="result/lexical-entry"/>
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
