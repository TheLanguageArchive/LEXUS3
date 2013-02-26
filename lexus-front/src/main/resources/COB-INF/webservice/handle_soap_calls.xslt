<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
    xmlns:impl="http://ws.service.lexicon.mpi.nl"
    xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="#all"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 28, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Process SOAP input to a cinclude call to handle the call.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="/">
        <xsl:apply-templates select="//SOAP-ENV:Body/*"/>
    </xsl:template>

    <xsl:template match="impl:login">
        <cinclude:includexml ignoreErrors="false">
            <cinclude:src>cocoon:/login.xml</cinclude:src>
            <cinclude:configuration>
                <cinclude:parameter>
                    <cinclude:name>method</cinclude:name>
                    <cinclude:value>POST</cinclude:value>
                </cinclude:parameter>
            </cinclude:configuration>
            <cinclude:parameters>
                <xsl:apply-templates select="*" mode="parameters"/>
            </cinclude:parameters>
        </cinclude:includexml>
    </xsl:template>
    
    <xsl:template match="impl:getResources">
        <cinclude:include src="cocoon:/getResources.xml"/>
    </xsl:template>

    <xsl:template match="impl:getResource">
        <cinclude:include src="cocoon:/getResource.xml/{a_resourceIdentifier}"/>
    </xsl:template>
    
    <xsl:template match="impl:getResourceStructure">
        <cinclude:include src="cocoon:/getResourceStructure.xml/{a_resourceID}"/>
    </xsl:template>
    
    <xsl:template match="impl:getDataCategories">
        <cinclude:include src="cocoon:/getDataCategories.xml/{a_resourceID}"/>
    </xsl:template>
    
    <xsl:template match="impl:search">
        <cinclude:include src="cocoon:/search.xml/{a_startPage}/{a_pageSize}/{normalize-space(a_queryString)}"/>
    </xsl:template>
    
    <xsl:template match="impl:getHTMLView">
        <cinclude:include src="cocoon:/getHTMLView.xml/{a_entryID}"/>
    </xsl:template>
    
    
    <xsl:template match="node()" mode="parameters">
        <cinclude:parameter>
            <cinclude:name>
                <xsl:value-of select="local-name()"/>
            </cinclude:name>
            <cinclude:value>
                <xsl:value-of select="."/>
            </cinclude:value>
        </cinclude:parameter>
    </xsl:template>

</xsl:stylesheet>
