<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:save-query">
        <xsl:copy>
            <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>                        
                
                (:
                    Save a workspace query.
                    :)
                declare updating function lexus:updateQuery($query as node(), $user as node()) {
                    (
                        if ($user/workspace/queries/query[@id eq $query/@id]) 
                        then replace node $user/workspace/queries/query[@id eq $query/@id] with $query
                        else insert node $query into $user/workspace/queries
                    )
                };
                
                (:
                    Save a lexicon filter.
                    :)
                declare updating function lexus:updateFilter($query as node(), $lexicon as node()) {
                (
                    if (empty($lexicon/meta/queries))
                        then insert node element queries { $query } into $lexicon/meta
                        else
                            if ($lexicon/meta/queries/query[@id eq $query/@id]) 
                                then replace node $lexicon/meta/queries/query[@id eq $query/@id] with $query
                                else insert node $query into $lexicon/meta/queries
                
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
