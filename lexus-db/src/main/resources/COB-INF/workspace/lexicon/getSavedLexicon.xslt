<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:get-saved-lexicon">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="users"/>
                
                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                let $userId := '<xsl:value-of select="/data/user/@id"/>'
                let $lexiconId := '<xsl:value-of select="@id"/>'
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $lexiconId]
                let $users := lexus:users(collection('<xsl:value-of select="$users-collection"/>')/user[@id = distinct-values($lexus/meta/users/user/@ref)])
                return element result
                {
                    $users,
                    element lexicon {
                        $lexus/lexicon/@*,
                        element meta {$lexus/meta/*[local-name() ne 'schema']},
                        element size {count($lexus/lexicon/lexical-entry)}
                    }
                }
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
