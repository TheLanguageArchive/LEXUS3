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
        <xsl:variable name="admin">
            <xsl:apply-templates select="/login" mode="admin"/>
        </xsl:variable>
        
        <rest:request target="{$endpoint}{$dbpath}/" method="POST">
            <rest:header name="Content-Type" value="text/xml; charset=UTF-8"/>
            <rest:body>
                <query xmlns="http://exist.sourceforge.net/NS/exist">
                    <text>
                        <xsl:call-template name="declare-namespace"/>
                        
                        let $user := collection('<xsl:value-of select="$dbpath"/>/users')/user[account eq '<xsl:value-of select="/login/account"/>'][password eq '<xsl:value-of select="/login/password"/>']
                        return
                            if ($user)
                            then
                                $user
                            else
                                let $noUsers := empty(collection('<xsl:value-of select="$dbpath"/>/users')/user)
                                return if ($noUsers)
                                    then 
                                        if (xmldb:create-collection('/db', 'lexus/users') ne '' and xmldb:create-collection('/db', 'lexus/lexica') ne '' )
                                            then 
                                                let $admin := <xsl:apply-templates select="$admin" mode="encoded"/>
                                                let $adminSave := xmldb:store('<xsl:value-of select="$dbpath"/>/users', concat($admin/account, '.xml'), $admin)
                                                return $admin
                                            else  
                                                element exception {attribute id {"LEX502"},
                                                    element message {"Administrator not created because collection /db/lexica could not be created."}
                                                }
                                    else 
                                        element exception {attribute id {"LEX501"},
                                            element message {"Administrator not created because at least one user exists."}
                                        }
                        
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>
    
    <xsl:template match="login" mode="admin">
        <user id="1">
            <name>Administrator</name>
            <account>
                <xsl:value-of select="username"/>
            </account>
            <password>
                <xsl:value-of select="password"/>
            </password>
            <accesslevel>30</accesslevel>
            <workspace>
                <queries> </queries>
                <sortorders/>
            </workspace>
        </user>
    </xsl:template>
</xsl:stylesheet>
