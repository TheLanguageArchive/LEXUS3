<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" xmlns:util="java:java.util.UUID" 
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:save-view">
        <lexus:query>
            
            <!--             
                Create a view.
              -->
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="view-permissions"/>
                <xsl:call-template name="log"/>
                
                (: create the view in the db :)
                declare updating function lexus:createView($newView as node(), $lexus as node()) {
                    (:
                      Create views element if it does not exist.
                      Otherwise, create view if it does not exist.
                      Otherwise, replace the view.
                      :)
                    if (empty($lexus/meta/views))
                        then insert node element views {$newView} into $lexus/meta
                        else if (empty($lexus/meta/views/view[@id eq $newView/@id]))
                            then insert node $newView into $lexus/meta/views
                            else replace node $lexus/meta/views/view[@id eq $newView/@id] with $newView                    
                };
                

                let $userId := '<xsl:value-of select="/data/user/@id"/>'       
                let $request := <xsl:apply-templates select="." mode="encoded"/>
                (: 
                    For an existing view, get the lexus node by looking up the view and finding the lexus ancestor node.
                    For a new view, there is only the lexiconId so that is used.
                :)
                let $lexus :=
                    if ($request/view/@id)
                        then collection('<xsl:value-of select="$lexica-collection"/>')/lexus/meta/views/view[@id eq $request/view/@id]/ancestor::lexus
                        else collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $request/@lexicon]
                return
                    if (lexus:canCreateView($lexus/meta, $userId))
                        then lexus:createView($request/view, $lexus)
                        else ()
            </lexus:text>
        </lexus:query>
    </xsl:template>
    
</xsl:stylesheet>
