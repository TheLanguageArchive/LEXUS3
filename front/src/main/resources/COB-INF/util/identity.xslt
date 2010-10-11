<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <!-- Identity transform -->
    <xsl:template match="@* | text()" mode="remove_namespaces" priority="1">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="node()" mode="remove_namespaces">
        <xsl:element name="{local-name()}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="@* | node()" mode="remove_namespaces"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
