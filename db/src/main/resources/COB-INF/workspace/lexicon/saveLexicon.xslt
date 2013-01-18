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
                
                <xquery:declare-updating-function/> lexus:updateLexicon($newData as node(), $lexus as node()) {
                    (
                        <xquery:delete><xquery:node>$lexus/meta/name</xquery:node></xquery:delete>,
                        <xquery:insert-into>
                            <xquery:node>$newData/meta/name</xquery:node>
                            <xquery:into>$lexus/meta</xquery:into>
                        </xquery:insert-into>,
                        <xquery:delete><xquery:node>$lexus/meta/description</xquery:node></xquery:delete>,
                        <xquery:insert-into>
                            <xquery:node>$newData/meta/description</xquery:node>
                            <xquery:into>$lexus/meta</xquery:into>
                        </xquery:insert-into>,
                        <xquery:delete><xquery:node>$lexus/meta/note</xquery:node></xquery:delete>,
                        <xquery:insert-into>
                            <xquery:node>$newData/meta/note</xquery:node>
                            <xquery:into>$lexus/meta</xquery:into>
                        </xquery:insert-into>,
                        <xquery:delete><xquery:node>$lexus/meta/users</xquery:node></xquery:delete>,
                        <xquery:insert-into>
                            <xquery:node>$newData/meta/users</xquery:node>
                            <xquery:into>$lexus/meta</xquery:into>
                        </xquery:insert-into>
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
