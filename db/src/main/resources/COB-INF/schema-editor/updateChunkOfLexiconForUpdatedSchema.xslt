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
    <xsl:param name="user-id"/>
    <xsl:param name="lexicon-id"/>
    <xsl:param name="start"/>
    <xsl:param name="chunk-size"/>
    
    <xsl:template match="lexus:update-lexicon-for-updated-schema">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            <lexus:text>
                (: <xsl:value-of select="$start"/>, <xsl:value-of select="$chunk-size"/> :)
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="sort-order"/>
                <xsl:call-template name="log"/>
                
                lexus:sort-order-processSchemaChanged('<xsl:value-of select="$lexicon-id"/>', '<xsl:value-of select="$user-id"/>', <xsl:value-of select="$start"/>, <xsl:value-of select="$chunk-size"/>)
            </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
