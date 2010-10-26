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
    
    <xsl:template match="lexus:update-lexica-for-updated-schema">
        <lexus:query>
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="sort-order"/>
                <xsl:call-template name="log"/>
                
                let $userId := '<xsl:value-of select="/data/user/@id"/>'       
                let $username := '<xsl:value-of select="/data/user/name"/>'       
                let $newSchema := <xsl:apply-templates select="/data/lexus:update-lexica-for-updated-schema" mode="encoded"/>
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $newSchema/@id]
                             (: let $dummy := lexus:log($lexus/@id, 'save-schema', $userId, $username, $newData/schema) :)
                return lexus:sort-order-processSchemaChanged($newSchema/@id, $userId)
            </lexus:text>
        </lexus:query>
    </xsl:template>
    
</xsl:stylesheet>
