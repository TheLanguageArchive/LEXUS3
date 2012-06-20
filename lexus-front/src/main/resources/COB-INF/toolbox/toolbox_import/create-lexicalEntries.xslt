<?xml version="1.0" encoding="UTF-8"?>
<!--
    Create a tree representation of the .typ file as parsed by Chaperon.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mpi="http://www.mpi.nl/lexus"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0" exclude-result-prefixes="#all"
    version="2.0">

    <xsl:param name="name" select="''"/>

    <xsl:key name="markers" match="/toolbox-import/lexus:meta/lexus:schema//lexus:container[@type='data']"
        use="@mdf:marker"/>
    <xsl:key name="groups" match="/toolbox-import/lexus:meta/lexus:schema//lexus:container[@type='component']"
        use="@mdf:marker"/>

    <xsl:template match="toolbox-import">
        <xsl:copy>
            <xsl:copy-of select="lexus:meta"/>
            <lexus:lexicon version="1.0">
                <lexus:lexicon-information>
                    <lexus:name>
                        <xsl:choose>
                            <xsl:when test="ends-with($name, '.typ')">
                                <xsl:value-of select="substring-before($name, '.typ')"/>
                            </xsl:when>
                            <xsl:otherwise>                                
                                <xsl:value-of select="$name"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </lexus:name>
                    <lexus:description/>
                    <lexus:note/>
                </lexus:lexicon-information>
                <xsl:apply-templates select="lexicon/lexical-entry[position() > 1]"/>
            </lexus:lexicon>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="lexical-entry">
        <lexus:lexical-entry schema-ref="{/toolbox-import/lexus:meta/lexus:schema//lexus:container[@type eq 'lexical-entry']/@id}">
            <xsl:apply-templates select="marker[1]">
                <xsl:with-param name="parent" select="''"/>
            </xsl:apply-templates>
        </lexus:lexical-entry>
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
        <xsl:variable name="schemaContainer" select="key('markers', $attrName)[1]"/>
        <xsl:variable name="schemaName" select="$schemaContainer/@name"/>
        <xsl:variable name="schemaId" select="$schemaContainer/@id"/>

        <xsl:choose>
            <!-- marker has descendants -->
            <xsl:when test="key('groups', @name)/lexus:container">

                <xsl:variable name="nextMarkerAncestorMarkers"
                    select="key('markers', following-sibling::marker[1]/@name)/ancestor::lexus:container/@mdf:marker"/>

                <!-- If next marker is a descendant then process it and include in container element -->
                <xsl:choose>
                    <xsl:when test="$nextMarkerAncestorMarkers = $attrName or $parent eq ''">
                        <xsl:variable name="children">
                            <xsl:apply-templates select="following-sibling::marker[1]">
                                <xsl:with-param name="parent" select="$attrName"/>
                            </xsl:apply-templates>
                        </xsl:variable>
                        <lexus:container name="{key('groups', @name)/@name}"
                            schema-ref="{key('groups', @name)/@id}">
                            <lexus:data name="{$schemaName}" schema-ref="{$schemaId}"
                                mdf:marker="{@name}">
                                <xsl:copy-of
                                    select="@*[local-name() ne 'name'][local-name() ne 'value']"/>
                                <lexus:value>
                                    <xsl:value-of select="@value"/>
                                </lexus:value>
                            </lexus:data>
                            <xsl:copy-of select="$children"/>
                        </lexus:container>
                        <!-- Check if next marker is a (descendant of a) sibling -->
                        <xsl:call-template name="process-possible-sibling">
                            <xsl:with-param name="parent" select="$parent"/>
                            <xsl:with-param name="nextMarker"
                                select="following-sibling::marker[position() eq 1 + count($children//lexus:data)]"
                            />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Next marker is not a descendant, but may be a (descendant of a) sibling -->
                        <lexus:container name="{key('groups', @name)/@name}" schema-ref="{key('groups', @name)/@id}">
                            <lexus:data name="{$schemaName}" schema-ref="{$schemaId}"
                                mdf:marker="{@name}">
                                <xsl:copy-of
                                    select="@*[local-name() ne 'name'][local-name() ne 'value']"/>
                                <lexus:value>
                                    <xsl:value-of select="@value"/>
                                </lexus:value>
                            </lexus:data>
                        </lexus:container>
                        <xsl:call-template name="process-possible-sibling">
                            <xsl:with-param name="parent" select="$parent"/>
                            <xsl:with-param name="nextMarker" select="following-sibling::marker[1]"
                            />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Marker has no descendants: just a data category -->
            <xsl:otherwise>
                <lexus:data name="{$schemaName}" schema-ref="{$schemaId}" mdf:marker="{@name}">
                    <xsl:copy-of select="@*[local-name() ne 'name'][local-name() ne 'value']"/>
                    <lexus:value>
                        <xsl:value-of select="@value"/>
                    </lexus:value>
                </lexus:data>
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
        <xsl:variable name="nextMarkersAncestors"
            select="key('markers', $nextMarker/@name)/ancestor::lexus:container/@mdf:marker"/>

        <xsl:if test="$nextMarkersAncestors = $parent or $parent eq ''">
            <xsl:apply-templates select="$nextMarker">
                <xsl:with-param name="parent" select="$parent"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
