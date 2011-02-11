<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="endpoint"/>
    <xsl:param name="lexica-collection"/>


    <xsl:template match="lexus:create-lexicon">
        <rest:request target="{concat($endpoint, $lexica-collection, '/', substring-after(lexus/@id, 'uuid:'))}" method="PUT">
            <rest:header name="Content-Type" value="text/xml; charset=UTF-8"/>
            <rest:body>
                <xsl:copy-of select="lexus"/>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
