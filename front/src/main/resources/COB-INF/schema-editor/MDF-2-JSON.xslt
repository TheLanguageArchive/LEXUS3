<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <!-- 
        Send MDF to client in JSON format.
        -->
    <xsl:template match="/">
        <object>
            <object key="result">
                <object key="status">
                    <xsl:choose>
                        <xsl:when test="lexiconSchema">
                            <true key="success"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <false key="success"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </object>
                <xsl:apply-templates/>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="lexiconSchema">
        
            <string key="name">MDF</string>
            <array key="dataCategories">
                <xsl:apply-templates/>
            </array>
        
    </xsl:template>


    <xsl:template match="container">
        <object>
            <string key="marker">
                <xsl:value-of select="@marker"/>
            </string>
            <string key="name">
                <xsl:value-of select="@nam"/>
            </string>
            <string key="description">
                <xsl:value-of select="@desc"/>
            </string>
        </object>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
