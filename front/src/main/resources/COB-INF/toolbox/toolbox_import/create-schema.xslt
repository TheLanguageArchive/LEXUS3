<?xml version="1.0" encoding="UTF-8"?>
<!--
    Create a schema of the .typ file as parsed by Chaperon.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mpi="http://www.mpi.nl/lexus"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:util="java:java.util.UUID" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/" xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:import href="../../util/identity.xslt"/>

    <xsl:template match="toolbox-import">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="lexiconSchema">
        <xsl:variable name="lexiconId" select="concat('uuid:',util:toString(util:randomUUID()))"/>
        <xsl:variable name="lexicalEntryId"
            select="concat('uuid:',util:toString(util:randomUUID()))"/>
        <lexus:meta version="1.0">
            <lexus:schema>
                <lexus:container id="{$lexiconId}" description="Represents the entire lexicon"
                    type="lexicon" name="Lexicon" mandatory="true" multiple="false" note=""
                    admin-info="">
                    <lexus:container
                        description="Represents a word, a multi-word expression, or an affix in a given language"
                        type="lexical-entry" id="{$lexicalEntryId}">
                        <xsl:apply-templates/>
                    </lexus:container>
                </lexus:container>
            </lexus:schema>
        </lexus:meta>
    </xsl:template>

    <xsl:template match="lexiconSchema//container[container]" priority="1">
        <xsl:variable name="containerId" select="concat('uuid:',util:toString(util:randomUUID()))"/>
        <xsl:variable name="dataId" select="concat('uuid:',util:toString(util:randomUUID()))"/>
        <lexus:container description="Group added for marker '{@marker}'"
            name="{concat(@nam, 'Group')}" type="component" id="{$containerId}"
            mdf:marker="{@marker}">
            <lexus:container description="{@desc}" name="{@nam}" type="data" id="{$dataId}"
                mdf:marker="{@marker}" mdf:lng="{@lng}"/>
            <xsl:apply-templates/>
        </lexus:container>
    </xsl:template>

    <xsl:template match="lexiconSchema//container[not(container)]">
        <xsl:variable name="containerId" select="concat('uuid:',util:toString(util:randomUUID()))"/>
        <lexus:container description="{@desc}" name="{@nam}" type="data" id="{$containerId}"
            mdf:marker="{@marker}" mdf:lng="{@lng}"/>
    </xsl:template>

</xsl:stylesheet>
