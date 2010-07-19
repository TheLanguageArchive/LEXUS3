<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="users-collection"/>

    <xsl:template match="/">
        <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>                        
                <xsl:call-template name="users"/>
                
                declare function lexus:getUsers() as node() {
                    element result {lexus:users(collection('<xsl:value-of select="$users-collection"/>')/user)}
                };
                
                let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                return
                    if (collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId and number(accesslevel) = 30])
                        then lexus:getUsers()
                        else element exception {attribute id {"LEX002"}, element message {"Permission denied, user is not an administrator."}}
            </lexus:text>
        </lexus:query>
    </xsl:template>

</xsl:stylesheet>
