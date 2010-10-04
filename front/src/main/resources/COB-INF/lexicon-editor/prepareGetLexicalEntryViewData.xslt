<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    version="2.0">
    <!--
        
        Input is:
        <data>
            <h:request>...</h:request>
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
    <xsl:include href="../util/identity.xslt"/>
    
    <xsl:template match="h:request">
        <lexus:get-lexical-entry id="{h:requestParameters/h:parameter[@name = 'id']/h:value}"/>
    </xsl:template>

</xsl:stylesheet>
