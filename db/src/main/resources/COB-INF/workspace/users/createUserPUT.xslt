<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>

    <xsl:param name="endpoint"/>
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:create-user">
        <xsl:copy>
            <xsl:variable name="docName" select="substring-after(user/@id, 'uuid:')"/>

            <xsl:choose>
                <xsl:when test="$docName ne ''">
                    <rest:request target="{concat($endpoint, $users-collection, '/', $docName)}"
                        method="PUT">
                        <rest:header name="Content-Type" value="text/xml; charset=UTF-8"/>
                        <rest:body>
                            <xsl:copy-of select="user"/>
                        </rest:body>
                    </rest:request>
                </xsl:when>
                <xsl:otherwise>
                    <lexus:error id="EMPT001"
                        message="Cannot create user document without documentname (=user id)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
