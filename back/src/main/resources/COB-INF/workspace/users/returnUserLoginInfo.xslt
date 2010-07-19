<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:template match="/exception">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="/user">
        <xsl:copy>
            <xsl:copy-of select="@* | name | account | accesslevel"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
