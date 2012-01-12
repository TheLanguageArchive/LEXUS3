<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:util="java:java.util.UUID" 
    xmlns:xquery="xquery-dialect"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:delete-user">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            
            <!--             
                Delete an user.
              -->
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
                <xsl:call-template name="user-permissions"/>
                <xsl:call-template name="log"/>
                
                (: create the view in the db :)
                <xquery:declare-updating-function/> lexus:deleteUser($user as node()) {
                
                    <xquery:delete>
                        <xquery:node>$user</xquery:node>
                    </xquery:delete>
                };
                let $requestUser := <xsl:apply-templates select="../user" mode="encoded"/>
                let $id := '<xsl:value-of select="user/@id"/>'
                let $user := fn:subsequence(collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $id], 1, 1)
                                
                return 
                    if (lexus:canUpdateOrCreateUser($requestUser))
                        then lexus:deleteUser($user)
                        else ()
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>