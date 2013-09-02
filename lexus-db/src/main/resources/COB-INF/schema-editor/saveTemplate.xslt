<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xquery="xquery-dialect"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:save-template">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            
            <!--             
                Save the template info.                
              -->
            <lexus:text>
                
                (: <xsl:value-of select="base-uri(document(''))"/> :)
                                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
                <xsl:call-template name="template-permissions"/>
                
                (: replace the template in the db :)
                <xquery:declare-updating-function/> lexus:updateTemplate($newTemplate as node(), $lexus as node()) {
                    <xquery:replace>
                        <xquery:node>collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $lexus/@id]/meta/template</xquery:node>
                        <xquery:with>$newTemplate</xquery:with>
                    </xquery:replace>
                };
                

                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                let $request := <xsl:apply-templates select="/data/lexus:save-template" mode="encoded"/>
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $request/@id]
                return
                    if (lexus:canUpdateTemplate($lexus/meta, $user))
                        then lexus:updateTemplate($request/template, $lexus)
                        else ()
            </lexus:text>
        </lexus:query></xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
