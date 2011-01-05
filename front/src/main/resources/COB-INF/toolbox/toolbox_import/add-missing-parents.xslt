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
            <xsl:sequence select="lexus:add_parents2(marker, 1, /)"/>
        </xsl:copy>
    </xsl:template>
        
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <!--
        Process markers until the first marker with a missing parent is found. Then, add the 
        parents and start over again.
        -->
    <xsl:function name="lexus:add_parents2">
        <xsl:param name="markers" as="node()*"/>
        <xsl:param name="pos" as="xs:integer"/>
        <xsl:param name="context" as="node()"/>

        <xsl:variable name="marker" select="subsequence($markers, $pos, 1)"/>
        <xsl:variable name="precedingMarkers" select="subsequence($markers, 1, $pos - 1)"/>

        <xsl:choose>
            
            <xsl:when test="$pos gt count($markers)">
                <xsl:sequence select="$markers"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:variable name="parentName"
                    select="subsequence(distinct-values(key('containers', data($marker/@name), $context)[parent::container]/../@marker), 1, 1)"/>
                
                <!-- If the first parent does not exist, add all missing parents -->
                <xsl:choose>
                    <xsl:when test="count($parentName) > 0 and not($parentName = $precedingMarkers/@name)">
                        <xsl:variable name="parents">
                            <xsl:sequence
                                select="lexus:get_parents($precedingMarkers, $parentName, $context)"/>
                        </xsl:variable>
                        <xsl:variable name="newMarkers" select="insert-before($markers, $pos, $parents)"/>
                        <xsl:sequence select="lexus:add_parents2($newMarkers, count($newMarkers) + 1, $context)"/>
                    </xsl:when>
                    <!-- Process the following markers -->
                    <xsl:otherwise>
                        <xsl:sequence select="lexus:add_parents2($markers, $pos + 1, $context)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>

    <!--
        Create a sequence of markers for the marker $name and all it's parents that are not in $markers.
    -->
    <xsl:function name="lexus:get_parents">
        <xsl:param name="markers" as="node()*"/>
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="context" as="node()"/>

        <xsl:variable name="parentName"
            select="subsequence(distinct-values(key('containers', $name, $context)[parent::container]/../@marker), 1, 1)"/>

        <!-- parent exists, add element to the parents sequence -->
        <xsl:if test="count($parentName) > 0 and not($markers/@name = $parentName)">
            <xsl:sequence select="lexus:get_parents($markers, $parentName, $context)"/>
        </xsl:if>

        <marker name="{$name}" added="true" parentName="{$parentName}"/>

    </xsl:function>

</xsl:stylesheet>
