<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    version="2.0">

    <xsl:param name="id" select="''"/>

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="zip:archive">
        <xsl:copy>
            <lexus:get-document-and-schema id="{$id}"/>
            <xsl:apply-templates/>
        </xsl:copy>

    </xsl:template>

</xsl:stylesheet>
