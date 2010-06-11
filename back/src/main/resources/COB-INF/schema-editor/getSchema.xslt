<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0"
    version="2.0">
    
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="endpoint"/>
    <xsl:param name="dbpath"/>

    <xsl:template match="lexus:get-schema">
        <rest:request target="{$endpoint}{$dbpath}/lexica" method="POST">
            <rest:header name="Content-Type" value="text/xml; charset=UTF-8"/>
            <rest:body>
                <query xmlns="http://exist.sourceforge.net/NS/exist">
                    <text>
                        <xsl:call-template name="declare-namespace"/> 
                        <xsl:call-template name="lexicon"/>
                        
                        let $id := '<xsl:value-of select="/data/lexus:get-schema/id"/>'
                        let $lexicon := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexicon[@id = $id]
                        let $lexus := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexus[@id = $id]
                        let $schema := $lexus/meta/schema
                        
                        return element result { $schema, lexus:lexicon($lexicon, $lexus) }
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
