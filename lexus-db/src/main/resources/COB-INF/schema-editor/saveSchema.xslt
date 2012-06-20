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
    
    <xsl:template match="lexus:save-schema">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            
            <!--             
                Save a schema.                
              -->
            <lexus:text>
                
                (: <xsl:value-of select="base-uri(document(''))"/> :)
                                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
                <xsl:call-template name="schema-permissions"/>
                
                (: replace the schema in the db :)
                <xquery:declare-updating-function/> lexus:updateSchema($newSchema as node(), $lexus as node()) {
                    <xquery:replace>
                        <xquery:node>collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $lexus/@id]/meta/schema</xquery:node>
                        <xquery:with>$newSchema</xquery:with>
                    </xquery:replace>
                };
                

                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                let $request := <xsl:apply-templates select="/data/lexus:save-schema" mode="encoded"/>
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $request/@id]
                return
                    if (lexus:canUpdateSchema($lexus/meta, $user))
                        then lexus:updateSchema($request/schema, $lexus)
                        else ()
            </lexus:text>
        </lexus:query></xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
