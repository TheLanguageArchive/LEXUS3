<?xml version="1.0" encoding="UTF-8"?>
<!--
    Create a proper schema from the component elements below the
    lexicalSchema element.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mpi="http://www.mpi.nl/lat/lexus"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lat/lexus" xmlns:util="java:java.util.UUID"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:include href="../../../util/identity.xslt"/>

    <xsl:template match="lexicalSchema//component">

        <xsl:variable name="uid" select="util:randomUUID()"/>
        <xsl:variable name="id" select="util:toString($uid)"/>

        <xsl:choose>
            <!-- marker has descendants -->
            <xsl:when test="component">

                <xsl:variable name="cuid" select="util:randomUUID()"/>
                <xsl:variable name="cid" select="util:toString($cuid)"/>

                <component id="uuid:{$cid}" name="{concat(@nam, 'Group')}" marker="{@marker}">
                    <xsl:copy>
                        <xsl:attribute name="id" select="concat('uuid:', $id)"/>
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates/>
                    </xsl:copy>
                </component>
            </xsl:when>
            <!-- Marker has no descendants: just a data category -->
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:attribute name="id" select="concat('uuid:', $id)"/>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
