<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" 
    xmlns:xquery="xquery-dialect"
    version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:delete-query">
        <xsl:copy>
            <lexus:query>
                <lexus:text>
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                    <xsl:call-template name="declare-namespace"/>
                    <xsl:call-template name="permissions"/>                        
                    
                    (:
                        Delete a workspace query given an id and a user node.
                    :)
                    <xquery:declare-updating-function/> lexus:deleteQuery($queryId as xs:string, $user as node()) {
                        <xquery:delete>
                            <xquery:node>$user/workspace/queries/query[@id eq $queryId]</xquery:node>
                        </xquery:delete>                
                    };
                    
                    (:
                        Delete a lexicon filter given an id and a lexus node.
                    :)
                    <xquery:declare-updating-function/> lexus:deleteFilter($queryId as xs:string, $lexus as node()) {
                        <xquery:delete>
                            <xquery:node>$lexus/meta/queries/query[@id eq $queryId]</xquery:node>
                        </xquery:delete>
                    };
                    
                    let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                    let $queryId := '<xsl:value-of select="id"/>'
                    let $lexiconId := '<xsl:value-of select="lexicon"/>'
                    let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
                    return
                        if ($lexiconId ne '')
                            then let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                                return if (lexus:canWrite($lexus/meta, $user))
                                        then lexus:deleteFilter($queryId, $lexus)
                                        else ()
                            else lexus:deleteQuery($queryId, $user)
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
