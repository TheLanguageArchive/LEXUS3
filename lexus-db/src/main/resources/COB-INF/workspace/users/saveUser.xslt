<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:xquery="xquery-dialect" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="users-collection"/>

    <xsl:template match="/">
        <xsl:copy>
            <lexus:query>
            	<lexus:text>
	                <xsl:call-template name="declare-namespace"/>                        
	                <xsl:call-template name="permissions"/>
	                
	                <xquery:declare-updating-function/> lexus:updateUser($existingUser as node(), $newData as node()){
	                        replace value of node $existingUser/account with $newData/account,
	                        replace value of node $existingUser/name with $newData/name,
	                        if(string-length(replace($newData/password,  ' ', '' )) > 0)
	                        	then replace value of node $existingUser/password with $newData/password
	                        	else (),
	                        if($existingUser/email)
	                        	then replace value of node $existingUser/email with $newData/email
	                        else 
	                        	(insert nodes $newData/email into $existingUser),
	                        replace value of node $existingUser/accesslevel with $newData/accesslevel
	                        
	                };
	                 
	                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
	                let $newData := <xsl:apply-templates select="/data/save-user" mode="encoded"/>
	                let $existingUser := collection('lexus')/user[@id = $newData/id]
	                return
	                    if (lexus:isAdministrator($user))
	                        then lexus:updateUser($existingUser, $newData)
	                        else ()
            	</lexus:text>
            </lexus:query>
    	</xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
