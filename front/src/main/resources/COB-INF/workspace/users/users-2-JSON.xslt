<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <!-- 
        JSON source to mimic:
        {
        "id": "Tue Feb 16 16:13:09 CET 2010",
        "result":         {
        "users":             [
        {
        "id": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNlYzgwMTAwMDE=",
        "accesslevel": 10,
        "administrator": false,
        "name": "adarsh",
        "account": "adarsh",
        "password": ""
        },
        {
        "id": "MmM5MDkwYzEwOWZkZWRkMDAxMDlmZTNhNTg5MTAwMTE=",
        "accesslevel": 10,
        "administrator": false,
        "name": "jacrin",
        "account": "jacrin",
        "password": ""
        },
-->
    <xsl:template match="/">
        <object>
            <xsl:apply-templates/>
        </object>
    </xsl:template>
    
    <xsl:template match="lexus:*">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="lexus:result/result">
        <object key="result">
            <xsl:apply-templates select="users"/>
        </object>
    </xsl:template>

    <xsl:template match="users">
        <array key="users">
            <xsl:apply-templates/>
        </array>
    </xsl:template>

    <xsl:template match="user">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="name"/>
            </string>
            <number key="accesslevel">
                <xsl:value-of select="accesslevel"/>
            </number>
            <string key="administrator">
                <xsl:value-of select="administrator"/>
            </string>
            <string key="account">
                <xsl:value-of select="account"/>
            </string>
        </object>
    </xsl:template>

</xsl:stylesheet>
