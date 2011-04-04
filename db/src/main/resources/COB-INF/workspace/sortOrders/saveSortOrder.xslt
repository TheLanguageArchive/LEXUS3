<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>

    <xsl:param name="users-collection"/>

    <!-- 
        Create an XQuery that saves the sort order.
        Also create an lexus:update-sort-keys element for sorting lexica later on.
        -->
    <xsl:template match="lexus:save-sortorder">
        <xsl:element name="update-sort-keys" namespace="http://www.mpi.nl/lexus">
            <xsl:copy-of select="sortorder"/>
        </xsl:element>

        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
                <lexus:text>
                    <xsl:call-template name="declare-namespace"/>
                    declare updating function lexus:updateSortOrder($sortOrder as node(), $user as node()) {
                        if ($user/workspace/sortorders/sortorder[@id eq $sortOrder/@id])
                            then replace node $user/workspace/sortorders/sortorder[@id eq $sortOrder/@id] with $sortOrder
                            else insert node $sortOrder into $user/workspace/sortorders
                    };
                    
                    let $userId := '<xsl:value-of select="/data/user/@id"/>'
                    let $sortOrder := <xsl:apply-templates select="sortorder" mode="encoded"/>
                    let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
                    return lexus:updateSortOrder($sortOrder, $user)
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
