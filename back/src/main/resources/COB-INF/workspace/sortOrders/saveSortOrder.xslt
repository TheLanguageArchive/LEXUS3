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
                        
                        declare function lexus:updateSortOrder($sortOrder as node(), $user as node()) as node() {
                            let $dummy := (
                            if ($user/workspace/sortorders/sortorder[@id eq $sortOrder/@id]) 
                                then update replace $user/workspace/sortorders/sortorder[@id eq $sortOrder/@id] with $sortOrder
                                else update insert $sortOrder into $user/workspace/sortorders
                            )
                            return element result { $sortOrder, $user }
                        };

                        let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                        let $sortOrder := <xsl:apply-templates select="/data/sortorder" mode="encoded"/>
                        let $user := collection('<xsl:value-of select="$dbpath"/>/users')/user[@id eq $userId]
                        return lexus:updateSortOrder($sortOrder, $user)
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>
    
</xsl:stylesheet>
