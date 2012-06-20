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
            <xd:p>Return the data category elements as a string in a soap response.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!--
        Get data categories.
        
        Like so:
        <?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
        <lexicon xmlns="http://www.mpi.nl/lexus" xmlns:dcr="http://www.isocat.org/ns/dcr" version="1.0">
        <datacategory id="MmM5MDkwYTIxNDNmMWFlMjAxMTQ2ZWU0ODkwODIwYTc=">
        <name>Word</name>
        <description/>
        <adminInfo/>
        <min>1</min>
        <max/>
        </datacategory>
        <datacategory id="MmM5MDkwYTIxNDNmMWFlMjAxMTQ2ZWU0ODkwODIwYTk=">
        <name>Translation</name>
        <description/>
        <adminInfo/>
        <min>1</min>
        <max/>
        </datacategory>
    -->
    <xsl:include href="../util/encodeXML_4WS.xslt"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <soapenv:Body>
                <ns1:getDataCategoriesResponse
                    soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
                    xmlns:ns1="http://service.lexicon.mpi.nl">
                    <getDataCategoriesReturn xsi:type="soapenc:string"
                        xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/">
                        <xsl:apply-templates select="/data/lexus:get-schema/lexus:result/result/lexicon/meta"/>
                    </getDataCategoriesReturn>
                </ns1:getDataCategoriesResponse>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
                    
    <xsl:template match="meta">
        &lt;lexicon xmlns=&quot;http://www.mpi.nl/lexus&quot; version=&quot;1.0&quot;&gt; xmlns:dcr=&quot;http://www.isocat.org/ns/dcr&quot; id=&quot;<xsl:value-of select="@id"/>&quot;&gt;
        <xsl:apply-templates select="schema//container[@type eq 'data']"/>
        &lt;/lexicon&gt;
    </xsl:template>
    
    <xsl:template match="container[@type eq 'data']">
        &lt;datacategory id="<xsl:value-of select="@id"/>"&gt;
        &lt;name><xsl:value-of select="@name"/>&lt;/name&gt;
        &lt;description&gt;<xsl:value-of select="@description"/>&lt;/description&gt;
        &lt;admin-info&gt;<xsl:value-of select="@admin-info"/>&lt;/admin-info&gt;
        &lt;mandatory><xsl:value-of select="@mandatory"/>&lt;/mandatory&gt;
        &lt;multiple&gt;<xsl:value-of select="@multiple"/>&lt;/multiple&gt;
        &lt;/datacategory&gt;
    </xsl:template>
</xsl:stylesheet>
