<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:util="java:java.util.UUID" 
    xmlns:xquery="xquery-dialect"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:delete-lexicon">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            
            <!--             
                Delete a lexicon.
              -->
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
                <xsl:call-template name="lexicon-permissions"/>
                <xsl:call-template name="log"/>
                
                (: delete lexicon document from the db :)
                
                <xsl:variable name="docName" select="concat('lexica/', substring-after(lexicon/@id, 'uuid:'), '_lexus.xml')"/>
                <xquery:declare-updating-function/> lexus:deleteLexicon() {
                    <xquery:delete>
                        <xquery:collection><xsl:value-of select="$lexica-collection"/></xquery:collection>
                        <xquery:path><xsl:value-of select="$docName"/></xquery:path>
                    </xquery:delete>
                };
                
                <xquery:declare-updating-function/> lexus:removeShared($lexus as node() , $user as node()) {
                        <xquery:delete>
                        	<xquery:node>$lexus/meta/users/user[@ref = $user/@id]</xquery:node>
                        </xquery:delete>
                };
                
                let $user := <xsl:apply-templates select="/data/user | /result/user" mode="encoded"/>
                let $id := '<xsl:value-of select="lexicon/@id"/>'
                let $lexus := fn:subsequence(collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $id], 1, 1)
                return 
                    if (lexus:canDeleteLexicon($lexus/meta, $user))
                        then lexus:deleteLexicon()
                        else ( lexus:removeShared($lexus, $user))
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
