<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xquery="xquery-dialect"
    version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:re-order-lexicon">
        <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>                        
                
                (:
                    Order the container and data elements in the lexical-entry/container by schema-order.
                :)
                declare function lexus:orderNodes($le as node()*, $schema as node()*) as node()* {
                (
                    for $sd in $schema[@type eq 'data'] return $le[@schema-ref eq $sd/@id],
                    for $sc in $schema[not(@type)] 
                        let $containers := $le[@schema-ref eq $sc/@id]
                        return
                            for $lc in $containers 
                                return element container {$lc/@*, lexus:orderNodes($lc/*, $sc/*)}
                )
                };
                
                (:
                Return a lexical-entry with ordered container and data elements.
                :)
                declare function lexus:orderLE($le as node(), $schema as node()*) as node() {
                    element lexical-entry {
                        $le/@*, lexus:orderNodes($le/*, $schema)
                    }    
                };
                
                (: replace the lexical entry with an ordered one :)
                <xquery:declare-updating-function/> lexus:updateLE($le as node(), $schema as node()*) {
                    <xquery:replace>
                        <xquery:node>$le</xquery:node>
                        <xquery:with>lexus:orderLE($le, $schema)</xquery:with>
                    </xquery:replace>
                };
                
                (: process all lexical entries in a lexicon :)
                <xquery:declare-updating-function/> lexus:updateLexicon($lexus as node()) {
                    let $schema := $lexus/meta/schema//container[@type eq 'lexical-entry']/*
                    for $le in $lexus/lexicon/lexical-entry
                        return lexus:updateLE($le, $schema)
                };
                
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq '<xsl:value-of select="@id"/>']
                return lexus:updateLexicon($lexus)
                
            </lexus:text>
        </lexus:query>
    </xsl:template>

</xsl:stylesheet>
