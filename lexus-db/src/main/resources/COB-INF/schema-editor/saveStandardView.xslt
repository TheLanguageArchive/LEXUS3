<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:util="java:java.util.UUID" 
    xmlns:xquery="xquery-dialect"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:save-standard-view">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            
            <!--             
                Create a view.
              -->
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
                <xsl:call-template name="view-permissions"/>
                <xsl:call-template name="log"/>
                
                (: create the view in the db :)
                <xquery:declare-updating-function/> lexus:saveStandardViews($standardViews as node(), $lexus as node()) {
                    (if (empty($lexus/meta/views/@listView))
                        then
                            <xquery:insert-into>
                                <xquery:node>$standardViews/@listView</xquery:node>
                                <xquery:into>$lexus/meta/views</xquery:into>
                            </xquery:insert-into>
                        else
                            <xquery:replace>
                                <xquery:node>$lexus/meta/views/@listView</xquery:node>
                                <xquery:with>$standardViews/@listView</xquery:with>
                            </xquery:replace>
                        ,
                     if (empty($lexus/meta/views/@lexicalEntryView))
                         then
                            <xquery:insert-into>
                                <xquery:node>$standardViews/@lexicalEntryView</xquery:node>
                                <xquery:into>$lexus/meta/views</xquery:into>
                            </xquery:insert-into>
                        else
                            <xquery:replace>
                                <xquery:node>$lexus/meta/views/@lexicalEntryView</xquery:node>
                                <xquery:with>$standardViews/@lexicalEntryView</xquery:with>
                            </xquery:replace>
                    )
                };
                

                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                let $request := <xsl:apply-templates select="." mode="encoded"/>
                
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $request/@lexicon]
                return
                    if (lexus:canCreateView($lexus/meta, $user))
                        then lexus:saveStandardViews($request/standardViews, $lexus)
                        else ()
            </lexus:text>
        </lexus:query></xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
