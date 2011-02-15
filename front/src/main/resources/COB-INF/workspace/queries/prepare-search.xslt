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
        <lexus:search-with-query>
            <xsl:apply-templates select="parameters/query"/>
            <xsl:apply-templates select="parameters/refiner"/>
        </lexus:search-with-query>
    </xsl:template>

    <!--
        Process the query element from the expression.
        Expression are always like this:
        <query>
            <lexicon>
                <datacategory>
                    <datacategory>
                        ...
                    ...
                <datacategory>*
            <lexicon>+
        <query>
    -->
    <xsl:template match="query">
        <xsl:copy>
            <xsl:attribute name="id" select="id"/>
            <xsl:copy-of select="name | description"/>
            <expression>
                <xsl:apply-templates select="children/children" mode="lexicon"/>
            </expression>
        </xsl:copy>
    </xsl:template>

    <!--
        Process a lexicon element from the expression.
    -->
    <xsl:template match="children" mode="lexicon">
        <lexicon id="{id}" name="{name}">
            <xsl:apply-templates select="children/children"/>
        </lexicon>
    </xsl:template>

    <!--
        Process a datacategory element from the expression.
        -->
    <xsl:template match="children">
        <datacategory id="{id}" name="{name}" value="{value}" condition="{condition}"
            negation="{negation}">
            <xsl:apply-templates select="children/children"/>
        </datacategory>
    </xsl:template>


    <!--
        The refiner allows for pagination and startLetter selection.
    -->
    <xsl:template match="refiner">
        <refiner>
            <xsl:copy-of select="node()"/>
        </refiner>
    </xsl:template>
</xsl:stylesheet>
