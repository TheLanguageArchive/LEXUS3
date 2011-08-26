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
    
    <xsl:template match="lexus:save-lexical-entries">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
                <lexus:query>
                
                <!--             
                    Save or create multiple lexical entries into a lexicon                
                  -->
                <lexus:text>
                    
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                    <xsl:call-template name="declare-namespace"/>
                    <xsl:call-template name="permissions"/>
                    
                    let $userId := '<xsl:value-of select="@user"/>'
                    let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
                    let $request := <xsl:apply-templates select="." mode="encoded"/>
                    let $lexiconId:= $request/@lexicon
                    let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                    return 
                        if (lexus:canWrite($lexus/meta, $user))
                            then                            
                                 <xquery:insert-as-last-into>
                                     <xquery:node>$request/lexical-entry</xquery:node>
                                     <xquery:into>$lexus/lexicon</xquery:into>
                                 </xquery:insert-as-last-into> 
                            else ()
                </lexus:text>
                </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
