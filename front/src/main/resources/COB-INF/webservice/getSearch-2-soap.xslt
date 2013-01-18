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
    
    <xsl:include href="../util/encodeXML.xslt"/>

<!--
    <?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
    <Results xmlns="http://www.mpi.nl/lexus" xmlns:dcr="http://www.isocat.org/ns/dcr" version="1.0">
    <lexicon id="...">
    <lexical-entry id="MGNiZjQzZWUtNGFkNS00NzJmLTk3NmItY2U1Y2U5NDUxMmJk" schema-ref="MmM5MDkwYTIxMzRlZTUzZDAxMTM2Mzc5MzFmZDA2N2Q=">
    <container id="NjE0ZjJmOTktYTdhOC00M2VjLTgzODYtYjNlNjUwNzI1ZTVl" name="lexemeGroup" schema-ref="MmM5MDkwYTIxMzRlZTUzZDAxMTM2Mzc5MzFmZDA2N2Y=">
    <data id="NmVhNmMyMzQtZmU0MC00YTUwLTk2MjAtMDM0YjhlNjU0NDU1" name="lexeme" schema-ref="MmM5MDkwYTIxMzRlZTUzZDAxMTM2Mzc5MzIwMTA2YmQ=">
    <value>'n:ee</value>
    </data>
    <data id="OTBhYjQzZjgtYzBkNC00MjhiLTlmOTMtOTAyYzBhNmM1ODNl" name="date" schema-ref="MmM5MDkwYTIxMzRlZTUzZDAxMTM2Mzc5MzIwMTA2Yzc=">
    <value>19/Feb/2007</value>
    </data>
    <container id="NzJmZDU0ZWEtYmQ3NS00YmUzLTk2OTMtZTlhNzk1Mjc5OGJk" name="descriptionGroup" schema-ref="MmM5MDkwYTIxMzRlZTUzZDAxMTM2Mzc5MzFmZDA2ODE=">
    <data id="MzBhYWNiOWMtMzQ0YS00MDE5LTgzNzUtYTBhOTA3ODYyOGJl" name="description" schema-ref="MmM5MDkwYTIxMzRlZTUzZDAxMTM2Mzc5MzIwMDA2Yjk=">
    <value>smell something</value>
    </data>
    <container id="ZTZjZDZlNGMtMGQ2Mi00MjY1LTg2NGItZDkwMTVjZTRmMjcx" name="example sentenceGroup" schema-ref="MmM5MDkwYTIxMzRlZTUzZDAxMTM2Mzc5MzFmZTA2ODk=">
    <data id="MGRjMmQwMjctNmZlYy00YTRlLWI2YWEtMzkxMWYxMjY0ZjAw" name="example sentence" schema-ref="MmM5MDkwYTIxMzRlZTUzZDAxMTM2Mzc5MzFmZTA2OGQ=">
    <value>Ghalyu ngê tuu dê 'n:ee</value>
    </data>
    </container>
    </container>
    </container>
    </lexical-entry>
    ...
    </lexicon>
    ...
    </Results>
    
    -->
    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <soapenv:Body>
                <ns1:getSearchResponse
                    soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
                    xmlns:ns1="http://service.lexicon.mpi.nl">
                    <searchReturn xsi:type="soapenc:string"
                        xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"> &lt;?xml
                        version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;
                            <xsl:apply-templates select="/data/lexus:search-with-query/lexus:result/search-results"/>
                    </searchReturn>
                </ns1:getSearchResponse>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
                    
    <xsl:template match="search-results">
        &lt;Results&gt;
        <xsl:apply-templates select="lexicon" mode="encoded"/>
        &lt;/Results&gt;
    </xsl:template>

</xsl:stylesheet>
