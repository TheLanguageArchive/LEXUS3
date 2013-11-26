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
	                        if($existingUser/shiblog)
	                        	then replace value of node $existingUser/shiblog with $newData/shiblog
	                        else	
	                        	(insert nodes $newData/shiblog into $existingUser),
	                        	
	                        replace value of node $existingUser/accesslevel with $newData/accesslevel
	                        
	                };
	                 
	                let $newData := <xsl:apply-templates select="/save-user" mode="encoded"/>
	                let $existingUser := collection('<xsl:value-of select="$users-collection" />')/user[@id = $newData/id]
	                return
	                     (db:output($existingUser), lexus:updateUser($existingUser, $newData))
	                      
            	</lexus:text>
            </lexus:query>
    	</xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
