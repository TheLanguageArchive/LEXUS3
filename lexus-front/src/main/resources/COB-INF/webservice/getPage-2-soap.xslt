<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
    xmlns:impl="http://www.mpi.nl/lexus/webservice/"
    xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 28, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Return all the lexica (getPage.xml) as a string in a soap response.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="/">
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
         <soapenv:Body>
            <getResourcesResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
               <getResourcesReturn xsi:type="soapenc:string" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/">
                    &lt;resources xmlns=&quot;http://www.mpi.nl/lexus&quot; version=&quot;1.0&quot;&gt;
                        <xsl:apply-templates select="/data/lexus:get-page/lexus:result/result/lexica/lexicon"/>
                    &lt;/resources&gt;
				</getResourcesReturn>
            </getResourcesResponse>
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
    &lt;/lexicon&gt;    
</xsl:template>
</xsl:stylesheet>
