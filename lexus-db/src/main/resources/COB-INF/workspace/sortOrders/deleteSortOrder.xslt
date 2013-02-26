<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" 
    xmlns:xquery="xquery-dialect"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:delete-sortorder">
        <xsl:copy>
            <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>                        
                
                <xquery:declare-updating-function/> lexus:deleteSortOrder($sortOrder as node(), $user as node()) {
                    <xquery:delete><xquery:node>$user/workspace/sortorders/sortorder[@id = $sortOrder/@id]</xquery:node></xquery:delete>
                };

                let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                let $sortOrder := <xsl:apply-templates select="sortorder" mode="encoded"/>
                let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id = $userId]
                return lexus:deleteSortOrder($sortOrder, $user)
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
