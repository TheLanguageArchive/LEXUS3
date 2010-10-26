<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>

    <xsl:template match="/">
        <lexus:query>
            
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
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>                        
                <xsl:call-template name="users"/>
                
                declare function lexus:updateLexicon($newData as node(), $lexus as node()) as node() {
                    let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                
                    let $dummy := (
                        update replace $lexus/meta/name with $newData/meta/name,
                        update replace $lexus/meta/description with $newData/meta/description,
                        update replace $lexus/meta/note with $newData/meta/note,
                        update replace $lexus/meta/users with $newData/meta/users
                    )
                    
                    let $users := lexus:users(collection('<xsl:value-of select="$users-collection"/>')/user[@id = distinct-values($lexus/meta/users/user/@ref)])
                
                    return element result
                    {
                        $users,
                        element lexicon
                            {$lexus/lexicon/@*,
                            $lexus/lexicon/lexicon-information,
                            element size {count($lexus/lexicon/lexical-entry)}},
                        $lexus,
                        $user
                    }
                };

                let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                let $newData := <xsl:apply-templates select="/data/lexus" mode="encoded"/>
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $newData/id]
                return if ($lexus/meta/users/user[@ref = $userId]/permissions/write eq "true")
                    then lexus:updateLexicon($newData, $lexus)
                    else element exception {attribute id {"LEX001"}, element message {concat("Permission denied, user '<xsl:value-of select="/data/user/name"/>' ('<xsl:value-of select="/data/user/account"/>', ",$userId, ") does not have write permission on lexicon '", $lexicon/lexicon-information/feat[@name='name'], "' (", $lexicon/@id)}}
            </lexus:text>
        </lexus:query>
    </xsl:template>
    
</xsl:stylesheet>
