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
                    
                    <!--(: 
                    
                    User permissions are nodes:
                    permissions/lexicon/read
                    permissions/lexicon/write
                    permissions/lexicon/write-moderated
                    permissions/schema/read
                    permissions/schema/write
                    permissions/schema/write-moderated
                    permissions/moderator
                    Anything other than a node with content "true" means "no permission"
                    
                    :)-->
                    <text>
                        
                        <xsl:call-template name="declare-namespace"/>                        
                        <xsl:call-template name="users"/>
                        
                        declare function lexus:updateLexicon($newData as node(), $lexus as node(), $lexicon as node()) as node() {
                            let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                        
                            let $dummy := (
                                update delete $lexicon/lexicon-information/feat[@name eq 'name'],
                                update insert element feat { attribute name {'name'}, $newData/name/text()} into $lexicon/lexicon-information,
                                update delete $lexicon/lexicon-information/feat[@name eq 'description'],
                                update insert element feat {attribute name {'description'}, $newData/description/text()} into $lexicon/lexicon-information,
                                update delete $lexicon/lexicon-information/feat[@name eq 'note'],
                                update insert element feat { attribute name {'note'}, $newData/note/text()} into $lexicon/lexicon-information,
                                update replace $lexus/meta/users with $newData/meta/users
                            )
                            
                            let $users := lexus:users(collection('<xsl:value-of select="$dbpath"/>/users')/user[@id = distinct-values($lexus/meta/users/user/@ref)])
                        
                            return element result
                            {
                                $users,
                                element lexicon
                                    {$lexicon/@*,
                                    $lexicon/lexicon-information,
                                    $lexus/meta,
                                    element size {count($lexicon/lexical-entry)}},
                                $user
                            }
                        };

                        let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                        let $newData := <xsl:apply-templates select="/data/lexicon" mode="encoded"/>
                        let $lexus := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexus[@id eq $newData/id]
                        let $lexicon := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexicon[@id eq $newData/id]
                        return if ($lexus/meta/users/user[@ref = $userId]/permissions/write eq "true")
                            then lexus:updateLexicon($newData, $lexus, $lexicon)
                            else element exception {attribute id {"LEX001"}, element message {concat("Permission denied, user '<xsl:value-of select="/data/user/name"/>' ('<xsl:value-of select="/data/user/account"/>', ",$userId, ") does not have write permission on lexicon '", $lexicon/lexicon-information/feat[@name='name'], "' (", $lexicon/@id)}}
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>
    
</xsl:stylesheet>
