<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="#all" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 6, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p/>
            <xd:p>Create an id for the lexus:lexus, lexus:meta and lexus:lexicon elements. Also, add
                ids to all the lexical entries, containers and data elements in the lexicon,
                existing ids are preserved. Add owner and user informtion to the meta element.</xd:p>
        </xd:desc>
    </xd:doc>


    <!--
        Define id for the lexus, meta and lexicon elements, overwriting existing @id attributes.
        If lexus:meta has an id attribute that starts with 'uuid:', use that, otherwise generate a new id.
        -->
    <xsl:template match="lexus:import-lexicon">
        <xsl:variable name="lexiconId">
            <xsl:choose>
                <xsl:when
                    test="starts-with(lexus:meta[@id], 'uuid:') and (string-length(lexus:meta[@id]) gt 5)">
                    <xsl:value-of select="lexus:meta[@id]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('uuid:',util:toString(util:randomUUID()))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <lexus id="{$lexiconId}" xmlns="http://www.mpi.nl/lexus">
            <xsl:apply-templates select="lexus:meta | lexus:lexicon">
                <xsl:with-param name="lexiconId" select="$lexiconId"/>
            </xsl:apply-templates>
        </lexus>
    </xsl:template>

    <!--
        Add or replace id for the lexus:meta element. Copy the rest.
    -->
    <xsl:template match="lexus:meta" priority="1">
        <xsl:param name="lexiconId"/>
        <xsl:copy>
            <xsl:copy-of select="@*[local-name() ne 'id']"/>
            <xsl:attribute name="id" select="$lexiconId"/>
            <xsl:apply-templates/>
            <owner ref="{../lexus:user/@id}" xmlns="http://www.mpi.nl/lexus"/>
            <users xmlns="http://www.mpi.nl/lexus">
                <user ref="{../lexus:user/@id}" xmlns="http://www.mpi.nl/lexus">
                    <permissions xmlns="http://www.mpi.nl/lexus">
                        <read xmlns="http://www.mpi.nl/lexus">true</read>
                        <write xmlns="http://www.mpi.nl/lexus">true</write>
                    </permissions>
                </user>
            </users>
            <xsl:apply-templates select="../lexus:lexicon/lexus:lexicon-information/lexus:*"/>
        </xsl:copy>
    </xsl:template>

    <!--
        Add or replace id for the lexus:lexicon element. Process the children, adding ids where necessary.
    -->
    <xsl:template match="lexus:lexicon" priority="1">
        <xsl:param name="lexiconId"/>
        <xsl:copy>
            <xsl:copy-of select="@*[local-name() ne 'id']"/>
            <xsl:attribute name="id" select="$lexiconId"/>
            <xsl:apply-templates select="lexus:lexical-entry" mode="add-ids"/>
        </xsl:copy>
    </xsl:template>


    <!--
        Any lexus:* element that has an id is copied verbatim.
        -->
    <xsl:template match="lexus:*[@id]" mode="add-ids">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="add-ids"/>
        </xsl:copy>
    </xsl:template>

    <!--
        Any lexus:* element that does not have an id gets an @id attribute and is otherwise copied verbatim.
        -->
    <xsl:template match="lexus:*[not(@id)]" mode="add-ids">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
            <xsl:apply-templates select="node()" mode="add-ids"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="lexus:lexicon-information/lexus:note">
        <xsl:copy>[This lexicon was imported by <xsl:value-of select="/lexus:import-lexicon/lexus:user/lexus:name"/> on <xsl:value-of select="current-dateTime()"/>.]
        <xsl:text>            
        </xsl:text><xsl:value-of select="."/></xsl:copy>
    </xsl:template>
    <!--
        Identity transform.
        -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
