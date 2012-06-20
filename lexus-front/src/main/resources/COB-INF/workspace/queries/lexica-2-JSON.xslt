<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../stylesheets/lexicon.xslt"/>

    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/lexus:get-page/lexus:result/result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/lexus:get-page/lexus:result[@success = 'true']">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="lexus:get-page/lexus:result/result">
        <object key="result">
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="lexus:get-page/lexus:result/result/users"/>

    <xsl:template match="lexus:get-page/lexus:result/result/lexica">
        <array key="lexica">
            <xsl:apply-templates/>
        </array>
    </xsl:template>

    <xsl:template match="lexus:get-page/lexus:result/result/user"/>

    <xsl:template match="@* | node()"/>


</xsl:stylesheet>
