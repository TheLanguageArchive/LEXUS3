<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0" xmlns:lexus="http://www.mpi.nl/lexus"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="json">
        <lexus:get-data-elements>
            <xsl:apply-templates select="parameters/ids/ids"/>
        </lexus:get-data-elements>
    </xsl:template>

    <xsl:template match="ids">
        <id>
            <xsl:value-of select="."/>
        </id>
    </xsl:template>
</xsl:stylesheet>
