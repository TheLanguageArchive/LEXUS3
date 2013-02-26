<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

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
                <xsl:choose>
                    <xsl:when test="data/lexus:save-schema/lexus:result[@success = 'true']">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object></object>
    </xsl:template>
    
    <xsl:template match="@* | node()"/>
        
    
</xsl:stylesheet>
