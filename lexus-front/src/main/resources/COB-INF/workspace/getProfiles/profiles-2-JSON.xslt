<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <!-- 
        JSON source to mimic:
        {
        "id": "Thu Apr 29 15:27:13 CEST 2010",
        "result": {"profiles":         [
        {
        "id": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNlYzgwMzAwMDI=",
        "accesslevel": 10,
        "administrator": false,
        "name": "adarsh"
        },
        {
        "id": "MmM5MDkwYzEwOWZkZWRkMDAxMDlmZTNhNTg5MTAwMTI=",
        "accesslevel": 10,
        "administrator": false,
        "name": "jacrin"
        },
        ....
        ]},
"requester": "Workspace58",
"status":         {
"message": "At your service",
"duration": "4831",
"insync": true,
"success": true
},
"requestId": "5CE497D2-6078-EEEF-1295-BCCE4D0A4397"
}
-->

    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="lexus:result/result"/>
        </object>
    </xsl:template>

    <xsl:template match="lexus:result/result">
        <object key="result">
            <xsl:apply-templates select="users"/>
        </object>
    </xsl:template>

    <xsl:template match="users">
        <array key="profiles">
            <xsl:apply-templates select="user"/>
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
            <string key="accesslevel">
                <xsl:value-of select="accesslevel"/>
            </string>
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
