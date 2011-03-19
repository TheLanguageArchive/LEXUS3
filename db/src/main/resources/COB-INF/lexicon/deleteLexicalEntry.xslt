<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>

    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:delete-lexical-entry">
        <xsl:copy>
            <xsl:apply-templates select="*"/>
            <lexus:query>

                <!--             
                Save or create a Lexical Entry.                
              -->
                <lexus:text>
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                    <xsl:call-template name="declare-namespace"/>
                    <xsl:call-template name="permissions"/>
                    
                    (: replace the lexical entry in the db :)
                    declare updating function lexus:deleteLexicalEntry($lexicalEntry as node()*) {
                        if (not(empty($lexicalEntry))) then delete node $lexicalEntry else ()
                    };
                    
                    let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                    let $request := <xsl:apply-templates select="/data/lexus:delete-lexical-entry" mode="encoded"/>
                    let $lexiconId:= $request/@lexicon
                    let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                    let $lexicalEntry := $lexus/lexicon/lexical-entry[@id eq $request/@id]
                    return if (lexus:canWrite($lexus/meta, $user))
                        then lexus:deleteLexicalEntry($lexicalEntry)
                        else ()
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
