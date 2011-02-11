<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        <data>
        <lexus:create-lexical-entry lexicon="..."/>
        <user>...</user>
        </data>
        
        Just return the schema. The front can transform it to JSON.
        
        -->
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>

    <xsl:template match="lexus:create-lexical-entry">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
                <lexus:text>
                    <xsl:call-template name="declare-namespace"/>                        
                    <xsl:call-template name="permissions"/>                        
                    <xsl:call-template name="users"/>
                    
                    let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                    let $lexiconId := '<xsl:value-of select="@lexicon"/>'
                    let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                    return
                        if (lexus:canWrite($lexus/meta, $user))
                            then element result { attribute lexicon { $lexiconId}, $lexus/meta/schema }
                            else element exception {attribute id {"LEX001"}, element message {concat("Permission denied, user '",$user/name,"' ('",$user/account,"', ", $user/@id, ") does not have write permission on lexicon '", $lexus/meta/name, "' (", $lexus/@id)}} 
                </lexus:text>
        </lexus:query></xsl:copy>
    </xsl:template>

</xsl:stylesheet>
