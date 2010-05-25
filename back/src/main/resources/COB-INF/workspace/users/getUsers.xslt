<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
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
                        
                        declare function lexus:getUsers() as node() {
                            element result {lexus:users(collection('<xsl:value-of select="$dbpath"/>/users')/user)}
                        };
                        
                        let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                        return
                            if (collection('<xsl:value-of select="$dbpath"/>/users')/user[@id eq $userId and number(accesslevel) = 30])
                                then lexus:getUsers()
                                else element exception {attribute id {"LEX002"}, element message {"Permission denied, user is not an administrator."}}
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
