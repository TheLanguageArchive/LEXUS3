<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>

    <xsl:param name="endpoint"/>
    <xsl:param name="lexica-collection"/>


    <xsl:template match="lexus:create-lexicon">
        <xsl:variable name="docName" select="concat(substring-after(lexus/@id, 'uuid:'), '.xml')"/>

        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="$docName ne ''">
                    <rest:request target="{concat($endpoint, $lexica-collection, '/', $docName)}"
                        method="PUT">
                        <rest:header name="Content-Type" value="application/xml"/>
                        <rest:body>
                            <xsl:copy-of select="lexus" copy-namespaces="no"/>
                        </rest:body>
                    </rest:request>
                </xsl:when>
                <xsl:otherwise>
                    <lexus:error id="EMPT002"
                        message="Cannot create lexicon document without documentname (=lexicon id)"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
