<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:util="java:java.util.UUID" 
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <!--
        Process lexus:save-view element.
        Find the right lexicon either by lexiconId or viewId and check if the user
        has permission to create or update a view.
        If everything's ok, create or update the view.
        -->
    <xsl:template match="lexus:save-view">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
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
                        then insert node element views {
                              attribute listView {$newView/@id},
                              attribute lexicalEntryView {},
                              $newView
                            } into $lexus/meta
                        else if (empty($lexus/meta/views/view[@id eq $newView/@id]))
                            then insert node $newView into $lexus/meta/views
                            else replace node $lexus/meta/views/view[@id eq $newView/@id] with $newView                    
                };
                
                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                let $request := <xsl:apply-templates select="." mode="encoded"/>
                (: 
                    For an existing view, get the lexus node by looking up the view and finding the lexus ancestor node.
                    For a new view, there is only the lexiconId so that is used.
                :)
                let $lexus :=
                    if (not($request/@lexicon))
                        then collection('<xsl:value-of select="$lexica-collection"/>')/lexus/meta/views/view[@id eq $request/view/@id]/ancestor::lexus
                        else collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $request/@lexicon]
                return
                    if (lexus:canCreateView($lexus/meta, $user))
                        then lexus:createView($request/view, $lexus)
                        else ()
            </lexus:text>
        </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
