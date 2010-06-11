<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

    <xsl:include href="../../stylesheets/lexicon.xslt"/>
    
    <!-- 
        JSON source to mimic:

{
"id": "Thu Feb 11 12:33:41 CET 2010",
"result":         {
"sessionId": "C7A918AF76EDB2D643E6DA56292D1A15",
"VICOS": "http://localhost:8080/mpi/vicos",
"myLexica":             [
{
"shared": false,
"id": "MmM5MDkwYTIyNDI5YzhhNTAxMjQyZTJjOWM3NzAwMGY=",
"description": "azazaza",
"administrator": false,
"writable": true,
"name": "azazaz",
"note": null,
"size": 3,
"readers": [                    {
"id": "MmM5MDkwYTIyMjk4MTNiOTAxMjJkZjQ0MDNiNTAwMDg=",
"accesslevel": 10,
"administrator": false,
"name": "Huib Verweij"
}],
"writers": [                    {
"id": "MmM5MDkwYTIyMjk4MTNiOTAxMjJkZjQ0MDNiNTAwMDg=",
"accesslevel": 10,
"administrator": false,
"name": "Huib Verweij"
}]
}
-->
    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/result"/>
        </object>
    </xsl:template>

    <xsl:template match="/data/result">
        <object key="result">
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="/data/result/users"/>

    <xsl:template match="/data/result/lexica">
        <array key="myLexica">
            <xsl:apply-templates/>
        </array>
    </xsl:template>

    <xsl:template match="/data/result/user">
        <object key="user">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="name"/>
            </string>
            <number key="accesslevel">
                <xsl:value-of select="accesslevel"/>
            </number>
            <xsl:choose>
                <xsl:when test="number(accesslevel) eq 30">
                    <true key="administrator"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="administrator"/>
                </xsl:otherwise>
            </xsl:choose>
        </object>
    </xsl:template>

    <xsl:template match="@* | node()"/>
        
    
</xsl:stylesheet>
