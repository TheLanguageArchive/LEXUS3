<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:save-lexicon">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            
            <!--(: 
            
            User permissions are nodes:
            permissions/lexicon/read
            permissions/lexicon/write
            permissions/lexicon/write-moderated
            permissions/schema/read
            permissions/schema/write
            permissions/schema/write-moderated
            permissions/moderator
            Anything other than a node with content "true" means "no permission"
            
            :)-->
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>                        
                <xsl:call-template name="users"/>
                <xsl:call-template name="permissions"/>
                
                declare updating function lexus:updateLexicon($newData as node(), $lexus as node()) {
                    (
                        delete node $lexus/meta/name,
                        insert node $newData/meta/name into $lexus/meta,
                        delete node $lexus/meta/description,
                        insert node $newData/meta/description into $lexus/meta,
                        delete node $lexus/meta/note,
                        insert node $newData/meta/note into $lexus/meta,
                        delete node $lexus/meta/users,
                        insert node $newData/meta/users into $lexus/meta
                    )                    
                };

                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                let $newData := <xsl:apply-templates select="lexus" mode="encoded"/>
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $newData/id]
                return if (lexus:canWrite($lexus/meta, $user))
                    then lexus:updateLexicon($newData, $lexus)
                    else ()
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
