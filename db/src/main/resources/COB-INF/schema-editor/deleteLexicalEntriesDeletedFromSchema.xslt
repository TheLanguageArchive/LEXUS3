<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xquery="xquery-dialect"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    <xsl:include href="../util/sort-order.xslt"/>

    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>

    <!--
        Collect all ids in the new schema into a variable.
        -->
    <xsl:variable name="newIds" select="distinct-values(/data/lexus:update-lexicon-for-updated-schema/schema//container/@id)"/>
    
    <xsl:template match="lexus:delete-lexical-entries-deleted-from-schema">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            
            
            <!--
                Delete any datacategories and containers from the lexicon that are no longer
                present in the schema.
                -->
            <lexus:query>
                <lexus:text>
                    
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                    
                    <xsl:call-template name="declare-namespace"/>
                    let $lexiconId := '<xsl:value-of select="@lexicon"/>'
                    return (
                    <xsl:for-each select="../lexus:get-schema/lexus:result[@success eq 'true']/result/schema//container[empty(index-of($newIds,@id))]">
                        <xsl:text>(: delete node </xsl:text><xsl:value-of select="current()/@name"/><xsl:text> :)</xsl:text>
                        <xquery:delete>
                            <xquery:node>collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]/lexicon//container[@schema-ref eq '<xsl:value-of select="current()/@id"/>']</xquery:node>
                        </xquery:delete>
                        <xsl:text>, </xsl:text>
                        <xquery:delete>
                            <xquery:node>collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]/lexicon//data[@schema-ref eq '<xsl:value-of select="current()/@id"/>']</xquery:node>
                        </xquery:delete>
                        <xsl:if test="position() ne last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    )</lexus:text>
            </lexus:query>
            
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
