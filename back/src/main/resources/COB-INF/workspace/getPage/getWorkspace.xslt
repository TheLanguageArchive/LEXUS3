<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="endpoint"/>
    <xsl:param name="dbpath"/>

    <xsl:template match="/">
        <rest:request target="{$endpoint}{$dbpath}/lexica" method="POST">
            <rest:header name="Content-Type" value="text/xml; charset=UTF-8"/>
            <rest:body>
                <query xmlns="http://exist.sourceforge.net/NS/exist">
                    <text>
                        <xsl:call-template name="declare-namespace"/>                        
                        <xsl:call-template name="users"/>
                        
                        let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                        let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                        let $lexi := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexus[meta/users/user/@ref = $user-id]
                        let $lexica := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexicon[@id = $lexi/@id]
                        let $users := lexus:users(collection('<xsl:value-of select="$dbpath"/>/users')/user[@id = distinct-values($lexi/meta/users/user/@ref)])
                        
                        return element result
                                    {
                                        $users,
                                        element lexica {
                                            for $lexicon in $lexica
                                            order by $lexi[@id eq $lexicon/@id]/meta/name
                                                return element lexicon
                                                    {$lexicon/@*,
                                                    $lexi[@id eq $lexicon/@id]/meta,
                                                    element size {count($lexicon//lexical-entry)}}
                                        },
                                        $user
                                    }
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
