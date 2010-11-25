<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    <xsl:include href="../../util/sort-order.xslt"/>
    
    <xsl:param name="users-collection"/>
    <xsl:param name="lexica-collection"/>
    
    <xsl:template match="lexus:update-sort-keys">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="sort-order"/>

                let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                let $sortOrderId := '<xsl:value-of select="sortorder/@id"/>'
                return lexus:sort-order-processAllData($sortOrderId, $userId)
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
