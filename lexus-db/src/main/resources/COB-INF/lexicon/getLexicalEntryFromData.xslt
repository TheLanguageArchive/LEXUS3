<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>

    <xsl:template match="lexus:get-entry-from-data">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
                <lexus:text>
                    
                    let $id := '<xsl:value-of select="/data/lexus:get-entry-from-data/id"/>'
                    let $user-id := '<xsl:value-of select="/data/lexus:get-entry-from-data/user"/>'
                    let $lexica := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user/@ref = $user-id]
                    let $entry := $lexica/lexicon/lexical-entry[.//data/@id = $id]
                    
                    return $entry
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>