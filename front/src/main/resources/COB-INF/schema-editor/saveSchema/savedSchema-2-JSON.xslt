<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

    <!-- 
        JSON source to mimic:
        {
            "status":         {
                "success": true
            }
        }
    -->
    
    <xsl:template match="/">
        <object>
            <object key="status">
                <string key="success">
                    <xsl:choose>
                        <xsl:when test="result/schema">true</xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                </string>
            </object></object>
    </xsl:template>
    
    <xsl:template match="@* | node()"/>
        
    
</xsl:stylesheet>
