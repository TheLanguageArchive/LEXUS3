<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Run a query.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="json-query-to-lexus-query-format.xslt"/>
    <!-- 
        
        <REQUEST:=    {
        "parameters": {"query":         {
        "name": "Fish",
        "id": "MmM5MDkwYTIyMTBiYWJmNDAxMjEzOTc5MzhlMjcxY2E=",
        "type": "query",
        "children":             [
        {
        "name": "Demo_rossell  lexicon ",
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTcyZDU5ZGQ=",
        "type": "lexicon",
        "children":                     [
        {
        "name": "d",
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5YzU=",
        "children": [                            {
        "name": "dt",
        "id": "MmM5MDkwYTIwYWQ2YmYyZTAxMGFmNTFmZTZkNTU5Y2I=",
        "children": [                            
        ...
        
        Return the search results.
    -->

    <xsl:template match="json">
        <lexus:search>
            <xsl:apply-templates select="parameters/query" mode="json-query"/>
            <xsl:apply-templates select="parameters/refiner"/>
        </lexus:search>
    </xsl:template>
    
    <xsl:template match="refiner/position">
        <startPage><xsl:value-of select="."/></startPage>
    </xsl:template>
    
</xsl:stylesheet>
