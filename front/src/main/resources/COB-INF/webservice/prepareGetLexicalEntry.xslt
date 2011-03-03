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
            <xd:p>Prepare to get a lexicon (documentAndSchema.xml) from the db module.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="a_entryID" select="''"/>

    <xsl:template match="/">
        <data>
            <lexus:get-lexical-entry>
            <lexicon/>
            <id>
                <xsl:value-of select="$a_entryID"/>
            </id>
        </lexus:get-lexical-entry>
            <xsl:copy-of select="user"/>
        </data>
    </xsl:template>

</xsl:stylesheet>
