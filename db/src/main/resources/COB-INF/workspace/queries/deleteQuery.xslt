<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:delete-query">
        <xsl:copy>
            <lexus:query>
                <lexus:text>
                    <xsl:call-template name="declare-namespace"/>
                    
                    declare updating function lexus:deleteQuery($queryId as node(), $user as node()) {
                    (
                        delete node $user/workspace/queries/query[@id eq $queryId]
                    )
                    };
                    
                    let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                    let $queryId := <xsl:apply-templates select="id" mode="encoded"/>
                    let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
                    return lexus:deleteQuery($queryId, $user)
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
