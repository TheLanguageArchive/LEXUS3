<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="endpoint"/>
    <xsl:param name="dbpath"/>

    <xsl:template match="lexus:get-page">
        <rest:request target="{$endpoint}{$dbpath}/lexica" method="POST">
            <rest:header name="Content-Type" value="text/xml; charset=UTF-8"/>
            <rest:body>
                <query xmlns="http://exist.sourceforge.net/NS/exist">
                    <text>
                        <xsl:call-template name="declare-namespace"/>                        
                        <xsl:call-template name="users"/>                        
                        <xsl:call-template name="user-permissions"/>                      
                        <xsl:call-template name="lexica"/>
                        
                        let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                        let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                        let $lexi := if (lexus:isAdministrator($user))
                                     then collection('<xsl:value-of select="$dbpath"/>/lexica')/lexus
                                     else collection('<xsl:value-of select="$dbpath"/>/lexica')/lexus[meta/users/user/@ref = $user-id]
                        let $users := lexus:users(collection('<xsl:value-of select="$dbpath"/>/users')/user[@id = distinct-values($lexi/meta/users/user/@ref)])
                        
                        return element result
                                    {
                                        $users,
                                        lexus:lexica2($lexi),
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
