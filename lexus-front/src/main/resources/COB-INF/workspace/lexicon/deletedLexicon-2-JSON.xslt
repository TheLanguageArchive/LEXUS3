<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:template match="/">
        <object>
            <object key="result">
                <object key="status">
                    <string key="success">
                        <xsl:choose>
                            <xsl:when test="/data/lexus:delete-lexicon/lexus:result[@success='true']">true</xsl:when>
                            <xsl:otherwise>false</xsl:otherwise>
                        </xsl:choose>
                    </string>
                </object>
            </object>
        </object>
    </xsl:template>
    
</xsl:stylesheet>
