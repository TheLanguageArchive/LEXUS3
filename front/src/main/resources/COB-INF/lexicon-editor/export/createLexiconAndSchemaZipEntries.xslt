<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    
    <xsl:key name="schemaIds" match="//lexus/meta/schema//component" use="@id"/>
    
    <!--
        Copy the zip:archive element.
    -->
    <xsl:template match="zip:archive">
        <zip:archive>
            <xsl:apply-templates/>
        </zip:archive>
    </xsl:template>

    <!-- 
        Create a lexicon file, a schema file and a human readable alternative format of the lexicon.
        -->
    <xsl:template match="lexus">
        <xsl:variable name="id" select="substring-after(@id, 'uuid:')"/>
        <zip:entry name="{$id}.xml" serializer="xml">
            <xsl:apply-templates select="lexicon" mode="remove_namespaces"/>
        </zip:entry>
        <zip:entry name="{$id}_schema.xml" serializer="xml">
            <xsl:apply-templates select="meta"/>
        </zip:entry>        
        <zip:entry name="{$id}_alt.xml" serializer="xml">
            <xsl:apply-templates select="lexicon" mode="alt"/>
        </zip:entry>
    </xsl:template>

    <!--
        Add the id attribute and copy children.
    -->
    <xsl:template match="meta">
        <xsl:element name="meta">
            <xsl:attribute name="id" select="ancestor::lexus/@id"/>
            <xsl:apply-templates mode="remove_namespaces" />
        </xsl:element>
    </xsl:template>
    
    
    
    <!--
        Export an alternative format, more human readable, to some.
        Add a lexicon-information element.
    -->
    <xsl:template match="lexicon" mode="alt">
        <lexicon>
            <xsl:apply-templates select="@*" mode="alt"/>
            <lexicon-information>
                <name><xsl:value-of select="ancestor::lexus/meta/name"/></name>
                <description><xsl:value-of select="ancestor::lexus/meta/description"/></description>
                <note><xsl:value-of select="ancestor::lexus/meta/note"/></note>
            </lexicon-information>
            <xsl:apply-templates select="*" mode="alt"/>
        </lexicon>
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
        <xsl:element name="{local-name()}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="@* | node()" mode="alt"/>
        </xsl:element>
    </xsl:template>
    
    <!--
        Copy component elements in the alt-format.
        -->    
    <xsl:template match="component" mode="alt" priority="1">
        <xsl:element name="{replace(key('schemaIds', @schema-ref)/@name, ' ', '_0x0020_')}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="@* | node()" mode="alt"/>
        </xsl:element>
    </xsl:template>

    <!--
        Copy data elements in the alt-format.
        -->    
    <xsl:template match="data" mode="alt" priority="1">
        <xsl:element name="{replace(key('schemaIds', @schema-ref)/@name, ' ', '_0x0020_')}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="@*"/>
            <xsl:value-of select="value"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
