<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0" xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">

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
