<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
    xmlns:impl="http://www.mpi.nl/lexus/webservice/"
    xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 28, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Return the lexicon as a string in a soap response.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="../util/encodeXML_4WS.xslt"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <soapenv:Body>
                <ns1:getResourceResponse
                    soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
                    xmlns:ns1="http://service.lexicon.mpi.nl">
                    <getResourceReturn xsi:type="soapenc:string"
                        xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/">
                        <xsl:apply-templates select="/data/lexus:get-document-and-schema/lexus:result/docAndSortorders/lexus/lexicon"/>
                    </getResourceReturn>
                </ns1:getResourceResponse>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
                    
    <xsl:template match="lexicon">
        &lt;lexicon id=&quot;<xsl:value-of select="@id"/>&quot;&gt;
        &lt;lexiconInformation&gt;
        &lt;name&gt;<xsl:value-of select="meta/name"/>&lt;/name&gt;
        &lt;description&gt;<xsl:value-of select="meta/description"/>&lt;/description&gt;
        &lt;note&gt;<xsl:value-of select="meta/note"/>&lt;/note&gt;
        &lt;/lexiconInformation&gt;
        <xsl:apply-templates select="*" mode="encoded"/>
        &lt;/lexicon&gt;
    </xsl:template>
</xsl:stylesheet>
