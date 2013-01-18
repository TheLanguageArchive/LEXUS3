<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    <xsl:include href="../util/sort-order.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:update-lexicon-for-updated-schema">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="sort-order">
                    <xsl:with-param name="sortorders" select=".//sortorder"/>
                </xsl:call-template>
                
                let $userId := '<xsl:value-of select="@user-id"/>'
                let $lexicon-id := '<xsl:value-of select="@lexicon"/>'
                return lexus:sort-order-processSchemaChanged($lexicon-id, $userId)
            </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
