<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

    <!-- 
        Extract data from the eXist response.
    -->
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="//exception">
                <xsl:message terminate="yes">
                    <xsl:copy-of select="//exception"/>
                </xsl:message>
            </xsl:when>
            <xsl:when test="//exist:result">
                <xsl:copy-of select="//exist:result/*"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    <exception>unknown error during call to eXist backend</exception>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
