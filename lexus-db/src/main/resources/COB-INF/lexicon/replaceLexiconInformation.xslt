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
    
    <xsl:template match="lexus:replace-lexicon-information">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
                <lexus:query>
                
                <!--             
                    Replace lexicon information in a newly imported lexicon.                
                  -->
                <lexus:text>
                    
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                    <xsl:call-template name="declare-namespace"/>
                    <xsl:call-template name="permissions"/>
                    
                    (: replace the name, description and note :)
                    <xquery:declare-updating-function/> lexus:updateLexiconInformation($lexus, $lexicon-information as node()) {
                        (
                            <xquery:replace>
                                <xquery:node>$lexus/meta/name</xquery:node>
                                <xquery:with>if ($lexicon-information/name ne '')
                                				then $lexicon-information/name
                                				else (element name {"UnamedLexicon!"})</xquery:with>
                            </xquery:replace>
                        ,
                            <xquery:replace>
                                <xquery:node>$lexus/meta/description</xquery:node>
                                <xquery:with>$lexicon-information/desc</xquery:with>
                            </xquery:replace>
                        ,
                            <xquery:replace>
                                <xquery:node>$lexus/meta/note</xquery:node>
                                <xquery:with>$lexicon-information/note</xquery:with>
                            </xquery:replace>
                        )
                    };
                    
                    let $userId := '<xsl:value-of select="@user"/>'
                    let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id = $userId]
                    let $request := <xsl:apply-templates select="." mode="encoded"/>
                    let $lexiconId:= $request/@lexicon
                    let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $lexiconId]
                    return 
                        if (lexus:canWrite($lexus/meta, $user))
                            then lexus:updateLexiconInformation($lexus, $request/lexicon-information) 
                            else ()
                </lexus:text>
                </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
