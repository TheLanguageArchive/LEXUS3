<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" 
    version="2.0">
    
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>

    <xsl:template match="lexus:get-schema">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/> 
                <xsl:call-template name="lexicon"/>
                
                let $id := '<xsl:value-of select="id"/>'
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $id]
                let $schema := $lexus/meta/schema
                
                return element result { $schema, lexus:lexicon($lexus) }
            </lexus:text>
        </lexus:query></xsl:copy>
    </xsl:template>

</xsl:stylesheet>
