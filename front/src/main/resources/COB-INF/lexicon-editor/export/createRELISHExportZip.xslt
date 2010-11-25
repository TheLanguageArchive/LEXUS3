<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0" xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:include href="createRelaxNGForLexicon.xslt"/>
    <xsl:include href="createAltFormatForLexicon.xslt"/>

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- 
        Separate the data from the backend in separate files:
        1   the lexicon.
        2   the meta/schema data + sort orders if used.
    -->

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:key name="schemaIds" match="//lexus/meta/schema//container" use="@id"/>

    <xsl:variable name="lexusNamespace" select="'http://www.mpi.nl/lexus'"/>

    <!--
        Copy the zip:archive element.
    -->
    <xsl:template match="zip:archive">
        <zip:archive>
            <xsl:apply-templates/>
        </zip:archive>
    </xsl:template>

    <!-- Skip any elements in the lexus namespace -->
    <xsl:template match="lexus:*">
        <xsl:apply-templates />
    </xsl:template>
    
    <!-- Match the top node we got from the back module,
        generate sort orders file and then process the lexus element. -->
    <xsl:template match="docAndSortorders">
        <xsl:apply-templates select="lexus"/>
        <!--<zip:entry name="{substring-after(lexus/@id, 'uuid:')}-all-in-one.xml" serializer="xml">
            <xsl:element name="lexus" namespace="{$lexusNamespace}">
                <xsl:apply-templates select="lexus/lexicon"/>
                <xsl:apply-templates select="lexus/meta"/>
            </xsl:element>
        </zip:entry>-->
    </xsl:template>


    <!-- 
        Create a sort order file if a sort order is used.
    -->
    <xsl:template match="sortorders">
        <xsl:variable name="usedSOs"
            select="distinct-values(ancestor::docAndSortorders/lexus/meta/schema//container/@sort-order)"/>

        <xsl:if test="sortorder[@id = $usedSOs]">
            <xsl:element name="sortorders" namespace="{$lexusNamespace}">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="sortorder[@id = $usedSOs]" mode="use_namespace">
                    <xsl:with-param name="ns" select="$lexusNamespace"/>
                </xsl:apply-templates>
            </xsl:element>
        </xsl:if>
    </xsl:template>


    <!-- 
        Create a lexicon file, a schema file and a human readable alternative format of the lexicon.
        -->
    <xsl:template match="lexus">
        <xsl:variable name="id" select="substring-after(@id, 'uuid:')"/>
        <zip:entry name="{$id}.xml" serializer="xml">
            <xsl:apply-templates select="lexicon"/>
        </zip:entry>
        <zip:entry name="{$id}_internal_schema.xml" serializer="xml">
            <xsl:apply-templates select="meta"/>
        </zip:entry>
        <!--<zip:entry name="{$id}_rng.xml" serializer="xml">
            <xsl:apply-templates select="meta" mode="relaxng"/>
        </zip:entry>-->
        <zip:entry name="{$id}_alt.xml" serializer="xml">
            <xsl:apply-templates select="lexicon" mode="alt"/>
        </zip:entry>
    </xsl:template>

    <!--
        Add a namespace and copy children.
        -->
    <xsl:template match="lexicon">
        <xsl:element name="lexicon" namespace="{$lexusNamespace}">
            <xsl:attribute name="version" select="'1.0'"/>
            <xsl:apply-templates select="@*"/>
            <xsl:call-template name="lexicon-information"/>
            <xsl:apply-templates mode="use_namespace">
                <xsl:with-param name="ns" select="$lexusNamespace"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>


    <!-- Copy name, description and note to a lexicon -->
    <xsl:template name="lexicon-information">
        <xsl:element name="lexicon-information" namespace="{$lexusNamespace}">
            <xsl:element name="name" namespace="{$lexusNamespace}">
                <xsl:value-of select="ancestor::lexus/meta/name"/>
            </xsl:element>
            <xsl:element name="description" namespace="{$lexusNamespace}">
                <xsl:value-of select="ancestor::lexus/meta/description"/>
            </xsl:element>
            <xsl:element name="note" namespace="{$lexusNamespace}">
                <xsl:value-of select="ancestor::lexus/meta/note"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!--
        Generate the meta/schema file.
        Add the id attribute, a namespace and copy children.
    -->
    <xsl:template match="meta">
        <xsl:element name="meta" namespace="{$lexusNamespace}"
            xmlns:isocat="http://www.isocat.org/datcat/">
            <xsl:attribute name="version" select="'1.0'"/>
            <xsl:attribute name="id" select="ancestor::lexus/@id"/>
            <xsl:apply-templates mode="use_namespace">
                <xsl:with-param name="ns" select="$lexusNamespace"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="ancestor::docAndSortorders/sortorders"/>
        </xsl:element>
    </xsl:template>

    <!-- Skip the lexicon container, it's pretty useless.
    -->
    <xsl:template match="schema//container[@type='lexicon']" mode="use_namespace">
        <xsl:apply-templates mode="use_namespace"/>
    </xsl:template>
    
    
    <!-- Modify the lexical-entry container, it's got too much information.
    -->
    <xsl:template match="schema//container[@type='lexical-entry']" mode="use_namespace">
        <xsl:element name="container" namespace="{$lexusNamespace}">
            <xsl:copy-of select="@id | @admin-info | @description | @type | @note"/>
            <xsl:apply-templates select="*" mode="use_namespace"/>
        </xsl:element>
    </xsl:template>
    
    <!-- Transform the registry/reference attributes to datcat="isocat:DC-xxxx" attribute.
    -->
    <xsl:template match="schema//container[@type='data']" mode="use_namespace"
        xmlns:dcr="http://www.isocat.org/ns/dcr">
        <xsl:element name="datacategory" namespace="{$lexusNamespace}"
            xmlns:isocat="http://www.isocat.org/datcat/">
            <xsl:copy-of select="@*[local-name() ne 'reference' and local-name() ne 'registry']"/>
            <xsl:choose>
                <xsl:when test="@registry eq 'ISO-12620' and @reference ne ''">
                    <xsl:attribute name="dcr:datcat" select="@reference"/>
                </xsl:when>
                <xsl:when test="@registry eq 'MDF' and @reference ne ''">
                    <xsl:attribute name="dcr:datcat"
                        select="concat('http://lexus.mpi.nl/datcat/mdf/', @reference)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of
                        select="@*[local-name() eq 'reference' and local-name() eq 'registry']"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="meta/owner|meta/users|meta/views|meta/name|meta/description|meta/note"
        mode="use_namespace"/>

</xsl:stylesheet>
