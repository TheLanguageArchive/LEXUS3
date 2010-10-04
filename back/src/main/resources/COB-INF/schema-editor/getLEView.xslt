<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" xmlns:util="java:java.util.UUID" 
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:get-leview">
        <lexus:query>
            
            <!--             
                Get listView.
              -->
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
                <xsl:call-template name="view-permissions"/>
                <xsl:call-template name="log"/>
                
                let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>       
                let $id := '<xsl:value-of select="@lexical-entry"/>'
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus/lexicon/lexical-entry[@id eq $id]/ancestor::lexus
                
                return
                    if (lexus:canReadViews($lexus/meta, $user))
                        then 
                            let $leView := $lexus/meta/views/@lexicalEntryView
                            return $lexus/meta/views/view[@id eq $leView]
                        else ()
            </lexus:text>
        </lexus:query>
    </xsl:template>
    
</xsl:stylesheet>
