<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:get-datacategories">
        <xsl:copy>
            <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
                
                let $lexiconId := '<xsl:value-of select="id"/>'
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $lexiconId]
                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                return
                    if (lexus:canRead($lexus/meta, $user))
                        then element dataCategories {
                            $lexus/meta//schema//container[@type = 'data']
                        }
                        else element exception {attribute id {"LEX002"}, element message {concat("Permission denied, user '",$user/name,"' ('",$user/account,"', ", $user/@id, ") does not have read permission on lexicon '", $lexus/meta/name, "' (", $lexus/@id)}} 
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
