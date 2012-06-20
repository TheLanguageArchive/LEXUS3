<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/" exclude-result-prefixes="#all" version="2.0">

    <xsl:include href="createRelaxNGForLexicon.xslt"/>
    <xsl:include href="createAltFormatForLexicon.xslt"/>
    <xsl:include href="../../util/identity.xslt"/>

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- 
        Separate the data from the backend in separate files:
        1   the lexicon.
        2   the meta/schema data + sort orders if used.
    -->

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
        <xsl:apply-templates/>
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
            <xsl:apply-templates select="meta" mode="use_namespace">
                <xsl:with-param name="ns" select="$lexusNamespace"/>
            </xsl:apply-templates>
        </zip:entry>
        <!--<zip:entry name="{$id}_rng.xml" serializer="xml">
            <xsl:apply-templates select="meta" mode="relaxng"/>
        </zip:entry>-->
        <!--<zip:entry name="{$id}_alt.xml" serializer="xml">
            <xsl:apply-templates select="lexicon" mode="alt"/>
        </zip:entry>-->
    </xsl:template>

    <!--
        Add a namespace and copy children.
        -->
    <xsl:template match="lexicon">
        <xsl:element name="lexicon" namespace="{$lexusNamespace}">
            <xsl:attribute name="version" select="'1.0'"/>
            <xsl:apply-templates select="@*"/>
            <xsl:call-template name="lexicon-information">
                <xsl:with-param name="ns" select="$lexusNamespace"/>
            </xsl:call-template>
            <xsl:apply-templates mode="use_namespace">
                <xsl:with-param name="ns" select="$lexusNamespace"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>


    <!-- Copy name, description and note to a lexicon -->
    <xsl:template name="lexicon-information">
        <xsl:param name="ns" select="''"/>
        <xsl:element name="lexicon-information" namespace="{$ns}">
            <xsl:element name="name" namespace="{$ns}">
                <xsl:value-of select="ancestor::lexus/meta/name"/>
            </xsl:element>
            <xsl:element name="description" namespace="{$ns}">
                <xsl:value-of select="ancestor::lexus/meta/description"/>
            </xsl:element>
            <xsl:element name="note" namespace="{$ns}">
                <xsl:value-of select="ancestor::lexus/meta/note"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!--
        Generate the meta/schema file.
        Add the id attribute, a namespace and copy children.
    -->
    <xsl:template match="meta" mode="use_namespace" >
        <xsl:param name="ns" select="''"/>
        <xsl:element name="meta" namespace="{$ns}" xmlns:isocat="http://www.isocat.org/datcat/">
            <xsl:attribute name="version" select="'1.0'"/>
            <xsl:attribute name="id" select="ancestor::lexus/@id"/>
            <xsl:apply-templates mode="use_namespace">
                <xsl:with-param name="ns" select="$ns"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="ancestor::docAndSortorders/sortorders"/>
        </xsl:element>
    </xsl:template>

    <!-- The schema element -->
    <xsl:template match="schema" mode="use_namespace">
        <xsl:param name="ns" select="''"/>
        <xsl:element name="schema" namespace="{$ns}">
            <xsl:apply-templates select="@*|node()" mode="use_namespace">
                <xsl:with-param name="ns" select="$ns"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>


    <!-- Modify the lexical-entry container, it's got too much information.
    -->
    <xsl:template
        match="schema//container[@type='lexical-entry'] | schema//container[@type='lexicon']"
        mode="use_namespace">
        <xsl:param name="ns" select="''"/>
        <xsl:element name="container" namespace="{$ns}">
            <xsl:copy-of select="@id | @admin-info | @description | @type | @note | @name"/>
            <xsl:apply-templates select="*" mode="use_namespace">
                <xsl:with-param name="ns" select="$ns"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <!-- A regular container element -->
    <xsl:template match="schema//container[@type='container'] | schema//container[not(@type)]"
        mode="use_namespace">
        <xsl:param name="ns" select="''"/>
        <xsl:element name="container" namespace="{$ns}">
            <xsl:copy-of select="@id | @admin-info | @description | @type | @note | @name"/>
            <xsl:apply-templates select="*" mode="use_namespace">
                <xsl:with-param name="ns" select="$ns"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <!-- Transform the registry/reference attributes to datcat="isocat:DC-xxxx" attribute.
    -->
    <xsl:template match="schema//container[@type='data']" mode="use_namespace"
        xmlns:dcr="http://www.isocat.org/ns/dcr">
        <xsl:param name="ns" select="''"/>
        <xsl:element name="datacategory" namespace="{$ns}"
            xmlns:isocat="http://www.isocat.org/datcat/">
            <xsl:apply-templates select="@*" mode="use_namespace">
                <xsl:with-param name="ns" select="$ns"/>
            </xsl:apply-templates>
            <xsl:choose>
                <xsl:when test="@registry eq 'ISO-12620' and @reference ne ''">
                    <xsl:attribute name="dcr:datcat" select="@reference"/>
                </xsl:when>
                <!--
                <xsl:when test="@registry eq 'MDF' and @reference ne ''">
                    <xsl:attribute name="dcr:datcat"
                        select="concat('lexus-user:', @reference)"/>
                </xsl:when>-->
                <xsl:otherwise><!--
                    <xsl:copy-of
                        select="@*[local-name() eq 'reference' and local-name() eq 'registry']"/>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@reference | @registry | @mdf:*" mode="use_namespace" priority="3"/>

    <xsl:template match="@*" mode="use_namespace" priority="2">
        <xsl:copy/>
    </xsl:template>


    <xsl:template match="meta/owner|meta/users|meta/views|meta/name|meta/description|meta/note"
        mode="use_namespace"/>

</xsl:stylesheet>
