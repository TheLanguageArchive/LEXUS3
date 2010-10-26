<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:util="java:java.util.UUID" 
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:delete-lexicon">
        <lexus:query>
            
            <!--             
                Delete a view.
              -->
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
                <xsl:call-template name="lexicon-permissions"/>
                <xsl:call-template name="log"/>
                
                (: create the view in the db :)
                declare updating function lexus:deleteLexicon($lexus as node()) {
                    delete node $lexus
                };
                
                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                let $id := '<xsl:value-of select="lexicon/@id"/>'
                let $lexus := fn:subsequence(collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $id], 1, 1)
                return 
                    if (lexus:canDeleteLexicon($lexus/meta, $user))
                        then lexus:deleteLexicon($lexus)
                        else ()
            </lexus:text>
        </lexus:query>
    </xsl:template>
    
</xsl:stylesheet>
