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
        parents to the $markers sequence and continue.
        -->
    <xsl:function name="lexus:add_parents2">
        <xsl:param name="markers" as="node()*"/>
        <xsl:param name="pos" as="xs:integer"/>
        <xsl:param name="context" as="node()"/>

        <xsl:variable name="marker" select="subsequence($markers, $pos, 1)"/>
        <xsl:variable name="precedingAncestors"
            select="lexus:preceding-ancestors($markers, $pos - 1, $marker/@name, $context)"/>

        <xsl:choose>

            <xsl:when test="$pos gt count($markers)">
                <xsl:sequence select="$markers"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:variable name="parentName"
                    select="subsequence(distinct-values(key('containers', data($marker/@name), $context)[parent::container]/../@marker), 1, 1)"/>

                <!-- If the first parent does not exist, add all missing parents -->
                <xsl:choose>
                    <xsl:when
                        test="count($parentName) > 0 and not($parentName = $precedingAncestors)">
                        <xsl:variable name="parents"
                            select="lexus:get_parents($precedingAncestors, data($marker/@name), $context)"/>
                        <xsl:variable name="newMarkers"
                            select="insert-before($markers, $pos, $parents)"/>
                        <!-- And process the following markers -->
                        <xsl:sequence
                            select="lexus:add_parents2($newMarkers, $pos + count($parents) + 1, $context)"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Process the following markers -->
                        <xsl:sequence
                            select="lexus:add_parents2($markers, $pos + 1, $context)"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <!--
        Create a sequence of ancestors for the marker $name and all it's parents that are not in $markers.
    -->
    <xsl:function name="lexus:get_parents" as="node()*">
        <xsl:param name="markers" as="xs:string*"/>
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="context" as="node()"/>

        <xsl:variable name="parentName"
            select="subsequence(distinct-values(key('containers', $name, $context)[parent::container]/../@marker), 1, 1)"/>

        <xsl:choose>
            <xsl:when test="count($parentName) = 0">
                <!-- No parent, just the () then. -->
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:when test="$markers = $parentName">
                <!-- parent exists in list of available ancestors, continue with parent -->
                <xsl:sequence select="lexus:get_parents($markers, $parentName, $context)"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- parent does not exists in list of available ancestors, continue with parent,
                    then add a marker element for the missing parent. So the top missing ancestor
                    is generated first. -->
                <xsl:sequence select="lexus:get_parents($markers, $parentName, $context)"/>
                <marker name="{$parentName}" added="true" marker="{$name}" ancestors="{$markers}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>



    <!--
        Create a sequence of ancestor markers (@names) for $marker that are present in $markers.
        $pos is position of preceding marker.
        $name is @name of current marker
        $context is document node, necessary for key().
        Return xs:string*.
    -->
    <xsl:function name="lexus:preceding-ancestors" as="xs:string*">
        <xsl:param name="markers" as="node()*"/>
        <xsl:param name="pos" as="xs:integer"/>
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="context" as="node()"/>

        <xsl:choose>
            <!-- Already processed the first marker, so return empty sequence. -->
            <xsl:when test="$pos lt 1">
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:otherwise>

                <xsl:variable name="pred" select="data(subsequence($markers, $pos, 1)/@name)"/>

                <xsl:choose>
                    <!-- When the previous marker is an ancestors add it to the list
                        of available ancestors and continue with the previous marker. -->
                    <xsl:when
                        test="$pred = distinct-values(key('containers', $name, $context)/ancestor::container/@marker)">
                        <xsl:sequence
                            select="(lexus:preceding-ancestors($markers, $pos - 1, $pred, $context), $pred)"
                        />
                    </xsl:when>
                    <!-- Previous marker is not in the list of the ancestors.
                        Now there are two situations:
                            - $pred is higher in the tree than $name. That means means we've jumped to a higher level in the tree and continue searching for
                        an ancestor of this marker ***above the treelevel of $pred*** to add to the list.
                            - $pred is not higher in the tree than $name. We carry on with $name.
                        -->
                    <xsl:otherwise>
                        <xsl:variable name="predAncestors" select="key('containers', $pred, $context)/ancestor::container/@marker"/>
                        <xsl:variable name="nameAncestors" select="key('containers', $name, $context)/ancestor::container/@marker"/>
                        <xsl:variable name="predTreeLevel" select="count($predAncestors)"/>
                        <xsl:variable name="nameTreeLevel" select="count($nameAncestors)"/>
                        <xsl:choose>
                            <xsl:when test="$predTreeLevel lt $nameTreeLevel">
                                <xsl:sequence
                                    select="lexus:preceding-ancestors($markers, $pos - 1, subsequence($nameAncestors, $predTreeLevel + 1, 1), $context)"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence
                                    select="lexus:preceding-ancestors($markers, $pos - 1, $name, $context)"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
