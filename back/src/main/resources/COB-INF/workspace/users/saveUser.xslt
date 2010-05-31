<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:json="http://apache.org/cocoon/json/1.0" version="2.0">

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
                        <xsl:call-template name="permissions"/>
                        
                        declare function lexus:updateUser($existingUser as node(), $newData as node()) as node() {
                            let $dummy := (
                                update replace $existingUser/account with $newData/account,
                                update replace $existingUser/name with $newData/name,
                                update replace $existingUser/password with $newData/password
                            )
                        
                            return $existingUser
                        };
                        
                        declare function lexus:createUser($newData as node()) as node() {
                            let $newUser := element user {attribute id {$newData/id}, $newData/*[local-name() ne 'id']}
                            let $docName := concat(substring-after($newUser/@id, 'uuid:'),'.xml')
                            let $userSave := xmldb:store('<xsl:value-of select="$dbpath"/>/users', $docName, $newUser)
                            
                            return $newUser
                        };
                        
                        declare function lexus:updateOrCreateUser($newData as node()) as node() {
                            let $existingUser := collection('<xsl:value-of select="$dbpath"/>/users')/user[@id eq $newData/id]
                            return
                                if ($existingUser)
                                    then lexus:updateUser($existingUser, $newData)
                                    else lexus:createUser($newData)
                         };
                         
                        let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                        let $newData := <xsl:apply-templates select="/data/save-user" mode="encoded"/>
                        return
                            if (lexus:canUpdateOrCreateUser($user))
                                then element result {lexus:updateOrCreateUser($newData), $user}
                                else element exception {
                                    attribute id {"LEX001"},
                                    element message {concat("Permission denied, user '<xsl:value-of select="/data/user/name"/>' ('<xsl:value-of select="/data/user/account"/>', ",
                                        <xsl:value-of select="/data/user/@id"/>, ") does not have sufficient rights")}
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
