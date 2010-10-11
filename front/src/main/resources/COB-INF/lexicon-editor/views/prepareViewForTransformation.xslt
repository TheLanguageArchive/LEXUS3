<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="/"><lexus:display>
        <xsl:choose>
            <xsl:when test="/data/view">
                <xsl:apply-templates select="/data/view"/>
            </xsl:when>
            <xsl:otherwise>
                <view><show><text value="Please create a list view in the Schema Editor">Please create a list view in the Schema Editor</text></show></view>
            </xsl:otherwise>
        </xsl:choose>
        </lexus:display>
    </xsl:template>
    
    <xsl:template match="view">
            <xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>
