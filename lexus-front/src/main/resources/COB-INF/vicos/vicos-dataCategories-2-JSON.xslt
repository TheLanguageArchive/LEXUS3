<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 25, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> andmor</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/lexus:get-datacategories/lexus:result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/lexus:get-datacategories/lexus:result[@success = 'true']">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>

    <xsl:template match="lexus:get-datacategories/lexus:result">
        <object key="result">
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="dataCategories">
        <array key="dataCategories">
            <xsl:apply-templates/>
        </array>
    </xsl:template>

    <xsl:template match="container[@type eq 'data']" priority="10">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <xsl:choose>
                <xsl:when test="exists(@sort-order)">
                    <string key="sortOrder">
                        <xsl:for-each select="/data//sortorders/sortorder[@id = current()/@sort-order]/mappings/mapping/to">
                            <xsl:if test="string-length(./text()) gt 1"><xsl:text>[</xsl:text></xsl:if><xsl:value-of select="./text()"/><xsl:if test="string-length(./text()) gt 1"><xsl:text>]</xsl:text></xsl:if><xsl:text>(</xsl:text><xsl:value-of select="../from/text()"/><xsl:text>)</xsl:text>
                        </xsl:for-each>
                    </string>
                </xsl:when>
                <xsl:otherwise>
                    <string key="sortOrder">abcdefghijklmnopqrstuvwxyz</string>
                </xsl:otherwise>
            </xsl:choose>
            <number key="min">
                <xsl:choose>
                    <xsl:when test="@mandatory eq 'true'">
                        <xsl:text>1</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </number>
            <xsl:choose>
                <xsl:when test="@multiple eq 'false'">
                    <number key="max">
                        <xsl:text>1</xsl:text>
                    </number>
                </xsl:when>
                <xsl:otherwise>
                    <null key="max"/>
                </xsl:otherwise>
            </xsl:choose>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="type">data category</string>
            <string key="name">
                <xsl:value-of select="@name"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="DCR">
                <xsl:choose>
                    <xsl:when test="@registry eq 'ISO-12620'">
                        <xsl:text>12620</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@registry"/>
                    </xsl:otherwise>
                </xsl:choose>
            </string>
            <string key="DCRReference">
                <xsl:value-of select="@reference"/>
            </string>
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
            <string key="note">
                <xsl:value-of select="@note"/>
            </string>
            <array key="valuedomain">
                <xsl:apply-templates select="valuedomain/domainvalue"/>
            </array>
        </object>
    </xsl:template>

    <xsl:template match="@* | node()"/>


</xsl:stylesheet>
