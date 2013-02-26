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
                
                (: delete user document from the db :)
                <xsl:variable name="docName" select="concat('users/', substring-after(user/@id, 'uuid:'), '.xml')"/>
                <xquery:declare-updating-function/> lexus:deleteUser() {
                
                    <xquery:delete>
                        <xquery:collection><xsl:value-of select="$users-collection"/></xquery:collection>
                        <xquery:path><xsl:value-of select="$docName"/></xquery:path>
                    </xquery:delete>
                };
                let $requestUser := <xsl:apply-templates select="../user" mode="encoded"/>
                                
                return 
                    if (lexus:canUpdateOrCreateUser($requestUser))
                        then lexus:deleteUser()
                        else ()
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>