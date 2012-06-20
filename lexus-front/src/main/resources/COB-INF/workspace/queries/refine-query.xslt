<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    <xsl:template match="@* | node()" priority="1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="expression" priority="2">
        <expression>
        <xsl:for-each-group select="lexicon" group-by="@id">
            <lexicon>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates select="current-group()/*"/>
            </lexicon>
        </xsl:for-each-group>   
        </expression>
    </xsl:template>   
</xsl:stylesheet>