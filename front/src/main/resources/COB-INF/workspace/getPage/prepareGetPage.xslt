<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        <data>
            <json xmlns:json="http://apache.org/cocoon/json/1.0">
                <id>AF836C97-5C1A-3DA6-00A2-3E4F31CCE5F4</id>
                <lexicon>1</lexicon>
            </json>
            <user>...</user>
        </data>
        {
        "id": "C7913F51-2842-A189-35D6-F37BCBD08D08",
        "requester": "LexiconBrowser862",
        "parameters":         {
        "id": "MmM5MDkwYTIxZjhlYTJkMzAxMjA2YmViODlmMTdhMDY=",
        "lexicon": "MmM5MDkwYTIxZjhlYTJkMzAxMjA2YWVkMmM4Njc2Nzk="
        }
        
    -->
    <xsl:include href="../../util/identity.xslt"/>
    
    <xsl:template match="json">
        <lexus:get-page><xsl:apply-templates select="parameters/*"/></lexus:get-page>
    </xsl:template>

</xsl:stylesheet>
