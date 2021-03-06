<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
    xmlns:impl="http://www.mpi.nl/lexus/webservice/"
    xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:saxon="http://saxon.sf.net/"
    xmlns:lexus="http://www.mpi.nl/lexus" exclude-result-prefixes="#all" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> March 3, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Prepare to get search results from the db module.</xd:p>
        </xd:desc>
    </xd:doc>
    <!--
    <xsl:param name="protocol"/>
    <xsl:param name="port"/>
    <xsl:param name="path"/>-->

    <xsl:param name="a_startPage"/>
    <xsl:param name="a_pageSize"/>
    <xsl:param name="a_queryString"/>

    <xsl:template match="/">
        <data>
            <lexus:search>
                <xsl:copy-of select="saxon:parse($a_queryString)"/>
                <refiner>
                    <startLetter/>
                    <!-- AAM: the WS currently specifies 'a_startPage' parameter actually behaving as 'a_firstResult'. 
                    For now, and to assure backwards compatibility, we convert the supplied parameter to the an actual startPage.
                    In the future it will be desirable to change the WS clients so they send 'a_startPage' instead of 'a_firstResult' labeled as 'a_stratPage'.-->
                    <startPage>
                        <xsl:value-of select="number($a_startPage) div number($a_pageSize)"/>
                    </startPage>
                    <pageSize>
                        <xsl:value-of select="$a_pageSize"/>
                    </pageSize>
                </refiner>
            </lexus:search>
            <xsl:copy-of select="user"/>
        </data>
    </xsl:template>

</xsl:stylesheet>
