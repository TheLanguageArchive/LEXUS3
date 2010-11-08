<?xml version="1.0" encoding="UTF-8"?>
<!--
    Add missing parents before attributes.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" exclude-result-prefixes="#all" version="2.0">

    <xsl:key name="containers" match="/toolbox-import/lexiconSchema//container" use="@marker"/>

    <xsl:template match="lexical-entry">
        <xsl:copy>
            <xsl:copy-of select="lexus:add_parents(marker, 1)"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:function name="lexus:add_parents">
        <xsl:param name="markers" as="node()*"/>
        <xsl:param name="pos" as="xs:integer"/>
        
        <xsl:variable name="precedingMarkers" select="$markers[position() lt $pos]/@name"/>

        <xsl:for-each select="$markers[$pos]">
            <xsl:variable name="parentNames"
                select="distinct-values(key('containers', @name)[parent::container]/../@marker)"/>
            <!-- parent does not exists, add the first parent -->
            <xsl:choose>
                <xsl:when test="count($parentNames) > 0 and not($parentNames = $precedingMarkers)">
                    <xsl:variable name="children"
                        select="lexus:get_siblings($markers, $pos, $parentNames[1])"/>
                    <marker name="{$parentNames[1]}" added="true">
                    </marker>
                    <!-- 
                        Do not add parent markers for sibling elements -->
                    <xsl:sequence select="$children"/>
                    <xsl:sequence
                        select="lexus:add_parents($markers, $pos + count($children))"/>
                </xsl:when>
                <!-- Copy the node and process the others -->
                <xsl:otherwise>
                    <xsl:sequence select="."/>
                    <xsl:sequence
                        select="lexus:add_parents($markers, $pos + 1)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="lexus:get_siblings">
        <xsl:param name="markers" as="node()*"/>
        <xsl:param name="pos" as="xs:integer"/>
        <xsl:param name="parent" as="xs:string"/>

        <xsl:for-each select="$markers[$pos]">
            <xsl:variable name="parentNames"
                select="distinct-values(key('containers', @name)[parent::container]/../@marker)"/>
            <!-- parent does not exists, add element to the sibling list -->
            <xsl:if test="count($parentNames) > 0 and $parentNames[1] eq $parent">
                <xsl:variable name="children"
                    select="lexus:get_siblings($markers, $pos + 1, $parent)"/>
                <xsl:sequence select="."/>
                <xsl:sequence select="$children"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>

</xsl:stylesheet>
