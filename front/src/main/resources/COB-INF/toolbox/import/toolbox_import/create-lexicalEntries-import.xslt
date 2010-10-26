<?xml version="1.0" encoding="UTF-8"?>
<!--
    Create a tree representation of the .typ file as parsed by Chaperon.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mpi="http://www.mpi.nl/lexus"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" exclude-result-prefixes="xs" version="2.0">

    <xsl:key name="containers" match="/toolbox-import/lexiconSchema//container" use="@marker"/>

    <xsl:template match="toolbox-import">
        <lexicon>
            <xsl:apply-templates select="lexicon/lexical-entry[position() > 1]"/>
        </lexicon>
    </xsl:template>

    <xsl:template match="lexical-entry">
        <xsl:copy>
            <xsl:apply-templates select="marker[1]">
                <xsl:with-param name="parent" select="''"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <!-- Handle markers one at a time. When an marker has children,
         calculate children first (by applying templates to the next marker),
         include them in the container and check if the next unprocessed
         marker is a sibling.
         If the marker is just a datacategory, include it and also
         check if the next unprocessed marker is a sibling.
         -->
    <xsl:template match="marker">
        <xsl:param name="parent" select="''"/>

        <xsl:variable name="attrName" as="xs:string" select="@name"/>
        <xsl:variable name="schemaName" select="key('containers', $attrName)[1]/@nam"/>
        
        <xsl:choose>
            <!-- marker has descendants -->
            <xsl:when test="key('containers', @name)/container">
                
                <xsl:variable name="nextMarkerAncestorNames"
                    select="key('containers', following-sibling::marker[1]/@name)/ancestor::container/@marker"/>

                <!-- If next marker is a descendant then process it and include in container element -->
                <xsl:choose>
                    <xsl:when test="$nextMarkerAncestorNames = $attrName or $parent eq ''">
                        <xsl:variable name="children">
                            <xsl:apply-templates select="following-sibling::marker[1]">
                                <xsl:with-param name="parent" select="$attrName"/>
                            </xsl:apply-templates>
                        </xsl:variable>
                        <container name="{concat($schemaName, 'Group')}" marker="{@name}">
                            <data name="{$schemaName}" marker="{@name}">
                                <xsl:copy-of select="@*[local-name() ne 'name']" />
                            </data>
                            <xsl:copy-of select="$children"/>
                        </container>
                        <!-- Check if next marker is a (descendant of a) sibling -->
                        <xsl:call-template name="process-possible-sibling">
                            <xsl:with-param name="parent" select="$parent"/>
                            <xsl:with-param name="nextMarker" select="following-sibling::marker[position() eq 1 + count($children//data)]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Next marker is not a descendant, but may be a (descendant of a) sibling -->
                        <container name="{concat($schemaName, 'Group')}" marker="{@name}">
                            <data name="{$schemaName}" marker="{@name}">
                                <xsl:copy-of select="@*[local-name() ne 'name']" />
                            </data>
                        </container>
                        <xsl:call-template name="process-possible-sibling">
                            <xsl:with-param name="parent" select="$parent"/>
                            <xsl:with-param name="nextMarker" select="following-sibling::marker[1]"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Marker has no descendants: just a data category -->
            <xsl:otherwise>
                <data name="{$schemaName}" marker="{@name}">
                    <xsl:copy-of select="@*[local-name() ne 'name']" />
                </data>
                <!-- Check if next marker is a (descendant of a) sibling -->
                <xsl:call-template name="process-possible-sibling">
                    <xsl:with-param name="parent" select="$parent"/>
                    <xsl:with-param name="nextMarker" select="following-sibling::marker[1]"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="process-possible-sibling">
        <xsl:param name="parent"/>
        <xsl:param name="nextMarker"/>
        <xsl:variable name="nextMarkersAncestors" select="key('containers', $nextMarker/@name)/ancestor::container/@marker"/>
        
        <xsl:if test="$nextMarkersAncestors = $parent or $parent eq ''">
            <xsl:apply-templates
                select="$nextMarker">
                <xsl:with-param name="parent" select="$parent"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
