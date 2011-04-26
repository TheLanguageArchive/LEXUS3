<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" 
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0" 
    version="2.0">

    <xsl:include href="../util/encodeXML.xslt"/>
    
    
    <!-- 
        Send MDF to client in JSON format.
        -->
    <xsl:template match="/">
        <xsl:variable name="success" select="rest:response/rest:status[@code eq '200']"/>
        <object>
            <object key="result">
                <object key="status">
                    <xsl:choose>
                        <xsl:when test="$success">
                            <true key="success"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <false key="success"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </object>
                <string key="isocat">
                    <xsl:apply-templates select="rest:response/rest:body/*" mode="encoded"/>
                </string>
            </object>
        </object>
    </xsl:template>

</xsl:stylesheet>
