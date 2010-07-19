<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" 
    version="2.0">
    
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>

    <xsl:template match="lexus:get-schema">
        <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/> 
                <xsl:call-template name="lexicon"/>
                
                let $id := '<xsl:value-of select="/data/lexus:get-schema/id"/>'
                let $lexicon := collection('<xsl:value-of select="$lexica-collection"/>')/lexicon[@id = $id]
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $id]
                let $schema := $lexus/meta/schema
                
                return element result { $schema, lexus:lexicon($lexicon, $lexus) }
            </lexus:text>
        </lexus:query>
    </xsl:template>

</xsl:stylesheet>
