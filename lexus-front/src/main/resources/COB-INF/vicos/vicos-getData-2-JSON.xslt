<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:util="java:java.util.UUID"
    exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Process a vicos search query result to a JSON response.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="../util/encodeXML.xslt"/>

    <!--
        
        Transform this:
        /data/...
        <lexus:get-listview xmlns:lexus="http://www.mpi.nl/lexus" xmlns:h="http://apache.org/cocoon/request/2.0" lexicon="uuid:2c9090a2134ee53d01136379321006d3">
            <lexus:result success="true">
                <view xmlns:jax-rx="http://jax-rx.sourceforge.net" xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0" type="dsl_view" isBranch="true" name="Print template" description="This view has been derived from a view in Lexus 2.0" id="uuid:9a014c73-1610-4652-a6e2-ac0c25e68e83">
                    <style isBranch="false"/>
            ...
        <display:lexicon...
            <lexical-entry xmlns:jax-rx="http://jax-rx.sourceforge.net" xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0" xmlns:h="http://apache.org/cocoon/request/2.0" id="uuid:1f89ed5f-19e2-4330-8f57-2a436d52e62d" schema-ref="uuid:2c9090a2134ee53d0113637931fd067d">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <head>
                        <title>Lexical entry</title>
        ...
        
        Make it look something like this:
        
        {"id":"Tue Feb 22 15:25:22 CET 2011",
        "result":{"entry":"\n<span><span id=\"NmU1ZjBkMzYtYmRkNy00ODMwLTljNWQtOWYwMTY3NjY2MDQ5\">a dnyaa<\/span><\/span>\n",
        "lius":[{"id":"NmU1ZjBkMzYtYmRkNy00ODMwLTljNWQtOWYwMTY3NjY2MDQ5","value":"a dnyaa","schemaElementId":"MmM5MDkwYTIxMzRlZTUzZDAxMTM2Mzc5MzIwMTA2YmQ=",
        "label":"lexeme","notes":null}]},
        "requester":"",
        "status":{"message":"At your service","duration":"158","insync":true,"success":true},"requestId":""}
    -->


    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/lexus:get-data/lexus:result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/lexus:get-data/lexus:result[@success = 'true']">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="lexus:result">
        
            <xsl:apply-templates select="result/data"/>
        
    </xsl:template>
    
    <xsl:template match="data">
        <object key="result">
            <string key="id"><xsl:value-of select="@id"/></string>
            <string key="value"><xsl:value-of select="value"/></string>
            <string key="schemaElementId"><xsl:value-of select="@schema-ref"/></string>
            <string key="label"><xsl:value-of select="@name"/></string>
            <string key="notes"></string>
        </object>
    </xsl:template>
    
</xsl:stylesheet>
