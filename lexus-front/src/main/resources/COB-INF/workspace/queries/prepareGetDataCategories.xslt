<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        {
        "parameters":         {
        "name": "Aweti bird lexicon",
        "id": "MmM5MDkwYTIxMmQ2N2UzNjAxMTJmNmE2OTI5NTA3MTQ=",
        "type": "lexicon",
        "children": [],
        "mx_internal_uid": "5B0A4BC4-CB9C-B24C-3C64-DB69EE794989"
        },
        "id": "F670BBC2-635D-BCEF-7012-DB69EE9A084A",
        "requester": "QueryBuilder"
        }>
        
    -->
    <xsl:include href="../../util/identity.xslt"/>
    
    <xsl:template match="json">
        <lexus:get-datacategories><xsl:apply-templates select="parameters/*"/></lexus:get-datacategories>
    </xsl:template>

</xsl:stylesheet>
