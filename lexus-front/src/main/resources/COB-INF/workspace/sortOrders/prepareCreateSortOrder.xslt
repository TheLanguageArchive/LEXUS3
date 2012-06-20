<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <!-- 

    original app's JSON to mimic (but leave out stuff that's unnecessary, like "fill"):
    {
    "id": "EACB869B-B032-F91F-3565-263BEFDC4D73",
    "requester": "workspace",
    "parameters":         {
    "data": null,
    "name": "sortorder name",
    "description": "sortorder description"
    }
-->

    <xsl:template match="/data">
        <xsl:copy>
            <xsl:apply-templates select="json/parameters"/>
            <xsl:copy-of select="user"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="parameters">
        <sortorder id="{id}">
            <xsl:copy-of select="name, description"/>
            <mappings>
            </mappings>
        </sortorder>
    </xsl:template>

</xsl:stylesheet>
