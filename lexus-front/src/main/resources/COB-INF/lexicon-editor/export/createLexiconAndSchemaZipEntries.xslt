<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0" xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">

    <!-- 
        Separate the data from the backend in three separate files:
        1   the lexicon.
        2   the meta/schema data.
        3   if sort orders are used, a file with the sort orders.
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

    <!-- Match the top node we got from the back module,
        generate sort orders file and then process the lexus element. -->
    <xsl:template match="docAndSortorders">
        <xsl:apply-templates select="sortorders"/>
        <xsl:apply-templates select="lexus"/>
    </xsl:template>


    <!-- 
        Create a sort order file if a sort order is used.
    -->
    <xsl:template match="sortorders">
        <xsl:variable name="usedSOs"
            select="distinct-values(ancestor::docAndSortorders/lexus/meta/schema//container/@sort-order)"/>

        <xsl:if test="sortorder[@id = $usedSOs]">
            <zip:entry name="{lexus/@id}-sort-orders.xml" serializer="xml">
                <xsl:element name="sortorders" namespace="{$lexusNamespace}">
                    <xsl:attribute name="version" select="'1.0'"/>
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="id" select="ancestor::docAndSortorders/lexus/@id"/>
                    <xsl:apply-templates select="sortorder[@id = $usedSOs]" mode="use_namespace">
                        <xsl:with-param name="ns" select="$lexusNamespace"/>
                    </xsl:apply-templates>
                </xsl:element>
            </zip:entry>
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
        <zip:entry name="{$id}_schema.xml" serializer="xml">
            <xsl:apply-templates select="meta"/>
        </zip:entry>
        <zip:entry name="{$id}_alt.xml" serializer="xml">
            <xsl:apply-templates select="lexicon" mode="alt"/>
        </zip:entry>
    </xsl:template>


    <!--
        Add a namespace and copy children.
        -->
    <xsl:template match="lexicon">
        <xsl:element name="lexicon" namespace="{$lexusNamespace}">
            <xsl:attribute name="LMF" select="'no'"/>
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
        <xsl:element name="meta" namespace="{$lexusNamespace}">
            <xsl:attribute name="version" select="'1.0'"/>
            <xsl:attribute name="id" select="ancestor::lexus/@id"/>
            <xsl:apply-templates mode="use_namespace">
                <xsl:with-param name="ns" select="$lexusNamespace"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>



    <!--
        Export an alternative format, more human readable, to some.
        Add a lexicon-information element.
    -->
    <xsl:template match="lexicon" mode="alt">
        <xsl:element name="lexicon" namespace="{$lexusNamespace}">
            <xsl:apply-templates select="@*" mode="alt"/>
            <xsl:attribute name="version" select="'1.0-alt'"/>
            <xsl:call-template name="lexicon-information"/>
            <xsl:apply-templates select="*" mode="alt"/>
        </xsl:element>
    </xsl:template>

    <!--
        Copy text and attributes in the alt-format.
        -->
    <xsl:template match="text() | @*" mode="alt" priority="1">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!--
        Copy nodes in the alt-format.
        -->
    <xsl:template match="node()" mode="alt">
        <xsl:variable name="localName" select="lexus:getLocalName(local-name())"/>
        <xsl:element name="{$localName}" namespace="{$lexusNamespace}">
            <xsl:apply-templates select="@* | node()" mode="alt"/>
        </xsl:element>
    </xsl:template>

    <!--
        Copy container elements in the alt-format.
        -->
    <xsl:template match="container" mode="alt" priority="1">
        <xsl:element name="{lexus:getLocalName(key('schemaIds', @schema-ref)/@name)}"
            namespace="{$lexusNamespace}">
            <xsl:apply-templates select="@* | node()" mode="alt"/>
        </xsl:element>
    </xsl:template>

    <!--
        Copy data elements in the alt-format.
        -->
    <xsl:template match="data" mode="alt" priority="1">
        <xsl:element name="{lexus:getLocalName(key('schemaIds', @schema-ref)/@name)}"
            namespace="{$lexusNamespace}">
            <xsl:apply-templates select="@*"/>
            <xsl:value-of select="value"/>
        </xsl:element>
    </xsl:template>


    <!-- Generate a valid local-name from a string. 
         Rudimentary atm, just relaces the space character by _x0020_.
        -->
    <xsl:function name="lexus:getLocalName">
        <xsl:param name="s"/>
        <xsl:value-of
            select="replace(replace(replace($s, ' ', '_x0020_'), '\(', '_x0028_'), '\)', '_x0029_')"
        />
    </xsl:function>
</xsl:stylesheet>
