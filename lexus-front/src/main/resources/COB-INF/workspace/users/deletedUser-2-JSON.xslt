<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" exclude-result-prefixes="#all" version="2.0">

    <!-- 
        Just return success or failure and a empty result/userProfile element,
        on the client side the users are reloaded anyway!
        -->

    <xsl:template match="/">
        <object>
            <xsl:if test="/data/lexus:delete-user/lexus:result[@success eq 'true']">
                <xsl:apply-templates select="/data/lexus:delete-user"/>
            </xsl:if>
            <object key="status">
                <string key="success">
                    <xsl:choose>
                        <xsl:when test="/data/lexus:delete-user/lexus:result[@success eq 'true']"
                            >true</xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                </string>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="lexus:delete-user">
        <object key="result">
            <object key="userProfile">
            </object>
        </object>
    </xsl:template>

</xsl:stylesheet>