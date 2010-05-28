<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

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
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="/result">
        <object key="result">
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="/result/users"/>

    <xsl:template match="/result/lexica">
        <array key="myLexica">
            <xsl:apply-templates/>
        </array>
    </xsl:template>

    <xsl:template match="lexicon">
        <xsl:variable name="userId" select="/result/user/@id"/>
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="meta/name"/>
            </string>
            <string key="description">
                <xsl:value-of select="meta/description"/>
            </string>
            <string key="note">
                <xsl:value-of select="meta/note"/>
            </string>
            <xsl:choose>
                <xsl:when test="meta/owner[@ref eq $userId]">
                    <false key="shared"/>
                </xsl:when>
                <xsl:otherwise>
                    <true key="shared"/>
                </xsl:otherwise>
            </xsl:choose>
            <number key="size">
                <xsl:value-of select="size"/>
            </number>
            <xsl:choose>
                <xsl:when
                    test="meta/users/user[@ref = $userId][permissions/write eq 'true']">
                    <true key="writable"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="writable"/>
                </xsl:otherwise>
            </xsl:choose>

            <array key="readers">
                <xsl:apply-templates
                    select="meta/users/user[permissions/read eq 'true']"/>
            </array>

            <array key="writers">
                <xsl:apply-templates
                    select="meta/users/user[permissions/write eq 'true']"/>
            </array>

        </object>

    </xsl:template>


    <xsl:template match="user[@ref]">
        <xsl:variable name="id" select="@ref"/>
        <object>
            <string key="id">
                <xsl:value-of select="$id"/>
            </string>
            <string key="name">
                <xsl:value-of select="//result/users/user[@id eq $id]/name"/>
            </string>
            <number key="accesslevel">
                <xsl:value-of select="//result/users/user[@id eq $id]/accesslevel"/>
            </number>
            <xsl:choose>
                <xsl:when test="number(//result/users/user[@id=$id]/accesslevel) eq 30">
                    <true key="administrator"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="administrator"/>
                </xsl:otherwise>
            </xsl:choose>
        </object>
    </xsl:template>


    <xsl:template match="/result/user">
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
