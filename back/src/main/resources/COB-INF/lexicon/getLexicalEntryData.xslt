<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">
    <!--
        
        Input is:
        <data>
        <get-lexical-entry>
        <lexicon>1</lexicon>
        <id>25</id>
        </get-lexical-entry>
        <user>...</user>
        </data>
        
        Generate the following information from the database:
        
        <lexical-entry id="uuid:d99c60dd-f316-4919-b18e-0e50556c45ec" schema-id="uuid:9e1dbc3c-55d1-4ba2-96b8-391f779a16ab">
            <component id="uuid:dac9139b-17cb-4c02-be63-bb6977b12775" schema-id="uuid:6b9f1ff4-6349-4c08-96ad-d04d29533813"/>
            <component id="uuid:6fa1e63a-8c07-46cf-bacc-f3ebe37fa6e4" schema-id="uuid:c27cd277-9852-4fd8-94bb-7909e25fdd8c">
            ....
        </lexical-entry>
    -->
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>

    <xsl:template match="/">
        <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/> 
                
                let $data := <xsl:apply-templates select="/data/get-lexical-entry" mode="encoded"/>
                let $lexiconId := $data/lexicon
                let $id := $data/id
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                let $lexicalEntry := collection('<xsl:value-of select="$lexica-collection"/>')/lexicon[@id eq $lexiconId]/lexical-entry[@id eq $id]
                
                return element result {
                    $lexicalEntry,
                    $lexus/meta/schema
                }
            </lexus:text>
        </lexus:query>
    </xsl:template>

</xsl:stylesheet>
