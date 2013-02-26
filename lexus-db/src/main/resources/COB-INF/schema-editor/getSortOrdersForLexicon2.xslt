<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    <xsl:param name="user-id"/>
    <xsl:param name="lexicon-id"/>
    
    <xsl:template match="lexus:update-lexicon-for-updated-schema">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <lexus:query>
                <lexus:text>
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                    <xsl:call-template name="declare-namespace"/>
                    
                    let $userId := '<xsl:value-of select="@user-id"/>'
                    let $sortorder-ids := distinct-values(collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = '<xsl:value-of select="@lexicon"/>']/meta/schema//container/@sort-order)
                    return collection('<xsl:value-of select="$users-collection"/>')/user[@id = $userId]/workspace/sortorders/sortorder[@id = $sortorder-ids]
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
