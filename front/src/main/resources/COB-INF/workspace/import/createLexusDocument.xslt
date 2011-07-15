<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/" xmlns:ex="http://apache.org/cocoon/exception/1.0"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="#all" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 6, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p/>
            <xd:p>Create an id for the lexus:lexus, lexus:meta and lexus:lexicon elements. Also, add
                ids to all the lexical entries, containers and data elements in the lexicon,
                existing ids are NOT preserved. Add owner and user information to the meta
                element.</xd:p>
        </xd:desc>
    </xd:doc>


    <!--
        Define id for the lexus, meta and lexicon elements, overwriting existing @id attributes.
        -->
    <xsl:template match="lexus:import-lexicon">
        <xsl:variable name="lexiconId">
            <xsl:value-of select="concat('uuid:',util:toString(util:randomUUID()))"/>
        </xsl:variable>

        <lexus id="{$lexiconId}" xmlns="http://www.mpi.nl/lexus">
            <xsl:apply-templates select="lexus:meta | lexus:lexicon">
                <xsl:with-param name="lexiconId" select="$lexiconId"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="//ex:exception-report"/>
        </lexus>
    </xsl:template>

    <!--
        Add or replace id for the lexus:meta element.
        Add name/description/note.
        Add owner/user info.
        Process the schema.
    -->
    <xsl:template match="lexus:meta" priority="1">
        <xsl:param name="lexiconId"/>
        <xsl:copy>
            <xsl:apply-templates select="@*[local-name() ne 'id']"/>
            <xsl:attribute name="id" select="$lexiconId"/>
            <xsl:apply-templates select="../lexus:lexicon/lexus:lexicon-information/lexus:*"/>
            <lexus:owner ref="{../lexus:user/@id}"/>
            <lexus:users>
                <lexus:user ref="{../lexus:user/@id}">
                    <lexus:permissions>
                        <lexus:read>true</lexus:read>
                        <lexus:write>true</lexus:write>
                    </lexus:permissions>
                </lexus:user>
            </lexus:users>
            <xsl:apply-templates mode="meta"/>
        </xsl:copy>
    </xsl:template>


    <!--
        Add @type='lexicon' to first lexus:container.
    -->
    <xsl:template match="lexus:container[not(ancestor::lexus:container)]" mode="meta" priority="3">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type" select="'lexicon'"/>
            <xsl:apply-templates select="node()" mode="meta"/>
        </xsl:copy>
    </xsl:template>


    <!--
        Add @type='lexical-entry' to second lexus:container.
    -->
    <xsl:template match="lexus:container[count(ancestor::lexus:container) eq 1]" mode="meta"
        priority="2">
        <xsl:copy>
            <!-- HHV: Do NOT change the ids in the schema! Just the ids in the lexicon. -->            
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type" select="'lexical-entry'"/>

            <xsl:apply-templates select="node()" mode="meta"/>
        </xsl:copy>
    </xsl:template>
    <!--
        Add @type and @id to lexus:container.
    -->
    <xsl:template match="lexus:container" mode="meta" priority="1">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:attribute name="type" select="'container'"/>
            <xsl:apply-templates select="node()" mode="meta"/>
        </xsl:copy>
    </xsl:template>
    <!--
        Create lexus:container with @type and @id for lexus:datacategory.
    -->
    <xsl:template match="lexus:datacategory" mode="meta" priority="1">
        <lexus:container>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type" select="'data'"/>

            <xsl:if test="lexus:value">
                <lexus:valuedomain>
                    <xsl:apply-templates select="lexus:value" mode="meta"/>
                </lexus:valuedomain>
            </xsl:if>
            <xsl:apply-templates select="*[local-name() ne 'value']" mode="meta"/>
        </lexus:container>
    </xsl:template>


    <!--
        Rewite lexus:value in the schema to lexus:domainvalue elements.
    -->
    <xsl:template match="lexus:value" mode="meta" priority="1">
        <lexus:domainvalue>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()" mode="meta"/>
        </lexus:domainvalue>
    </xsl:template>


    <!--
        Add or replace id for the lexus:lexicon element. Process the children, adding ids where necessary.
    -->
    <xsl:template match="lexus:lexicon" priority="1">
        <xsl:param name="lexiconId"/>
        <xsl:copy>
            <xsl:apply-templates select="@*[local-name() ne 'id']"/>
            <xsl:attribute name="id" select="$lexiconId"/>
            <xsl:apply-templates select="lexus:lexical-entry" mode="add-ids"/>
        </xsl:copy>
    </xsl:template>

    <!--
        Add missing @id attributes.
    -->
    <xsl:template match="lexus:container|lexus:data|lexus:lexical-entry" mode="add-ids">
        <xsl:copy>
            <xsl:apply-templates select="@*[local-name() ne 'id']"/>
            <xsl:attribute name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>

            <xsl:apply-templates select="node()" mode="add-ids"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="lexus:lexicon-information/lexus:note">
        <xsl:copy>[This lexicon was imported by <xsl:value-of
                select="/lexus:import-lexicon/lexus:user/lexus:name"/> on <xsl:value-of
                select="current-dateTime()"/>.]
                <xsl:text>            
        </xsl:text><xsl:value-of select="."/></xsl:copy>
    </xsl:template>

    <!--
        Identity transform.
        -->
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
