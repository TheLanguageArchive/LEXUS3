<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:get-page">
        <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>                        
                <xsl:call-template name="users"/>                        
                <xsl:call-template name="user-permissions"/>                      
                <xsl:call-template name="lexica"/>
                
                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                let $lexi := if (lexus:isAdministrator($user))
                            then collection('<xsl:value-of select="$lexica-collection"/>')/lexus
                            else collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user/@ref = $user-id]
                let $users := lexus:users(collection('<xsl:value-of select="$users-collection"/>')/user[@id = distinct-values($lexi/meta/users/user/@ref)])
                
                return element result
                           {
                               $users,
                               lexus:lexica2($lexi),
                               $user
                           }
            </lexus:text>
        </lexus:query>
    </xsl:template>

</xsl:stylesheet>
