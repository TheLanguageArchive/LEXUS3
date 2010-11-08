<?xml version="1.0" encoding="UTF-8"?>
<!--
    Create a tree representation of the .typ file as parsed by Chaperon.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <lexiconSchema>
            <xsl:apply-templates select="/parser:databaseType/parser:markerSet"/>
        </lexiconSchema>
    </xsl:template>
    <xsl:template match="parser:markerSet">
        <xsl:variable name="root" select="parser:attribute[@name eq 'mkrRecord']"/>
        <xsl:call-template name="create-tree">
            <xsl:with-param name="rootMarker" select="parser:marker[@name eq $root]"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="create-tree">
        <xsl:param name="rootMarker"/>

        <xsl:variable name="children"
            select="/parser:databaseType/parser:markerSet/parser:marker[parser:attribute[@name eq 'mkrOverThis']/text() eq $rootMarker/@name]"/>
        <xsl:choose>
            <xsl:when test="$children">
                <container marker="{$rootMarker/@name}"
                    nam="{$rootMarker/parser:attribute[@name eq 'nam']}"
                    desc="{$rootMarker/parser:attribute[@name eq 'desc']}"
                    lng="{$rootMarker/parser:attribute[@name eq 'lng']}">
                    <xsl:for-each select="$children">
                        <!--<a><xsl:copy-of select="."/></a>-->
                        <xsl:call-template name="create-tree">
                            <xsl:with-param name="rootMarker" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                </container>
            </xsl:when>
            <xsl:otherwise>
                <container marker="{$rootMarker/@name}" nam="{$rootMarker/parser:attribute[@name eq 'nam']}"
                    desc="{$rootMarker/parser:attribute[@name eq 'desc']}"
                    lng="{$rootMarker/parser:attribute[@name eq 'lng']}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
