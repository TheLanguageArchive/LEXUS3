<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>

    <xsl:param name="users-collection"/>

    <xsl:template match="/">
        <xsl:variable name="admin">
            <xsl:apply-templates select="/login" mode="admin"/>
        </xsl:variable>
        
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>
                
                let $user := collection('<xsl:value-of select="$users-collection"/>')/user[account = '<xsl:value-of select="/login/username"/>'][password = '<xsl:value-of select="/login/password"/>']
                return 
                	if (not(empty($user)))
                       then $user
                    else element lexus:exception {attribute id {"LEX006"}, element lexus:message {"Account not found."}}
       
                       </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>  
</xsl:stylesheet>
