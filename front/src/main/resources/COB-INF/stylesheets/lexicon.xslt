<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <xsl:template match="lexicon" priority="1">
        <xsl:variable name="userId" select="/data/user/@id"/>
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
                    test="meta/users/user[@ref eq $userId][permissions/write eq 'true']">
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
    
    
</xsl:stylesheet>
