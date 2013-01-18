<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        <data>
        <lexus:get-document-and-schema id="..."/>
        <user>...</user>
        </data>
        
        Generate the following information from the database:
        
        <lexicon id="...">
            <lexical-entry>
            <container id="uuid:dac9139b-17cb-4c02-be63-bb6977b12775" schema-id="uuid:6b9f1ff4-6349-4c08-96ad-d04d29533813"/>
            <container id="uuid:6fa1e63a-8c07-46cf-bacc-f3ebe37fa6e4" schema-id="uuid:c27cd277-9852-4fd8-94bb-7909e25fdd8c"/>
            </lexical-entry>
        </lexicon>
        <schema id="...">
        </schema>
    -->
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:get-document-and-schema">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
                <lexus:text>
                    <xsl:call-template name="declare-namespace"/> 
                    <xsl:call-template name="permissions"/> 
                    let $lexiconId := '<xsl:value-of select="@id"/>'
                    let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                    let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                    let $sortOrders := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $user/@id]/workspace/sortorders
                    return if (lexus:canRead($lexus/meta, $user)) then element docAndSortorders {$lexus, $sortOrders} else ()
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
