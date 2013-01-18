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

    <xsl:template match="lexus:save-query">
        <xsl:copy>
            <lexus:query>
                <lexus:text>
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>                        
                
                (:
                    Save a workspace query.
                    :)
                <xquery:declare-updating-function/> lexus:updateQuery($query as node(), $user as node()) {
                    (
                        if ($user/workspace/queries/query[@id eq $query/@id])                        
                            then
                                <xquery:replace>
                                    <xquery:node>$user/workspace/queries/query[@id eq $query/@id]</xquery:node>
                                    <xquery:with>$query</xquery:with>
                                </xquery:replace>                
                            else                
                                <xquery:insert-into>
                                    <xquery:node>$query</xquery:node>
                                    <xquery:into>$user/workspace/queries</xquery:into>
                                </xquery:insert-into>
                    )
                };
                
                (:
                    Save a lexicon filter.
                    :)
                <xquery:declare-updating-function/> lexus:updateFilter($query as node(), $lexicon as node()) {
                (
                    if (empty($lexicon/meta/queries))
                        then
                            <xquery:insert-into>
                                <xquery:node>element queries { $query }</xquery:node>
                                <xquery:into>$lexicon/meta</xquery:into>
                            </xquery:insert-into>
                        else
                            if ($lexicon/meta/queries/query[@id eq $query/@id]) 
                                then 
                                    <xquery:replace>
                                        <xquery:node>$lexicon/meta/queries/query[@id eq $query/@id]</xquery:node>
                                        <xquery:with>$query</xquery:with>
                                    </xquery:replace>
                                else
                                    <xquery:insert-into>
                                        <xquery:node>$query</xquery:node>
                                        <xquery:into>$lexicon/meta/queries</xquery:into>
                                    </xquery:insert-into>
                
                )
                };

                let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                let $query := <xsl:apply-templates select="query" mode="encoded"/>
                let $lexiconId := '<xsl:value-of select="lexicon"/>'
                let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
                return
                    if ($lexiconId ne '')
                    then let $lexicon := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                         return if (lexus:canWrite($lexicon/meta, $user))
                            then lexus:updateFilter($query, $lexicon)
                            else ()
                    else lexus:updateQuery($query, $user)
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
