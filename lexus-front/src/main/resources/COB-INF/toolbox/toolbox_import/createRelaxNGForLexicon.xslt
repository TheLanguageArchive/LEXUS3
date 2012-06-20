<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns="http://relaxng.org/ns/structure/1.0" exclude-result-prefixes="#all" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="lexus:lexicon">
        <!-- Add <?oxygen RNGSchema="lexicon.rng" type="xml"?> to lexicon document, for convenience. -->
        <xsl:processing-instruction name="oxygen"> RNGSchema="lexicon.rng" type="xml" </xsl:processing-instruction>
        <xsl:copy-of select="."/>
    </xsl:template>
    <!--
        Generate the RelaxNG schema file.
    -->
    <xsl:template match="lexus:meta">
        <xsl:copy-of select="."/>
        <grammar ns="http://www.mpi.nl/lexus">
            <start>
                <element name="lexicon">
                    <optional>
                        <attribute name="id"/>
                    </optional>
                    <attribute name="version"/>
                    <ref name="lexicon-information"/>
                    <oneOrMore>
                        <ref name="lexical-entry"/>
                    </oneOrMore>
                </element>
            </start>

            <define name="lexicon-information">
                <element name="lexicon-information">
                    <interleave>
                        <element name="name">
                            <text/>
                        </element>
                        <element name="description">
                            <text/>
                        </element>
                        <element name="note">
                            <text/>
                        </element>
                    </interleave>
                </element>
            </define>

            <xsl:apply-templates select=".//lexus:container[@type='lexical-entry']" mode="rng"/>

        </grammar>
    </xsl:template>

    <!--
        Generate a RelaxNG element to match the <lexical-entry/> elements.
    -->
    <xsl:template match="lexus:container[@type='lexical-entry']" mode="rng">
        <define name="lexical-entry">
            <element name="lexical-entry">
                <optional>
                    <attribute name="id"/>
                </optional>
                <attribute name="schema-ref">
                    <value>
                        <xsl:value-of select="@id"/>
                    </value>
                </attribute>
                <zeroOrMore>
                    <choice>
                        <!-- data categories -->
                        <xsl:apply-templates select="lexus:datacategory" mode="rng"/>
                        <!-- containers -->
                        <xsl:for-each select="lexus:container">
                            <ref name="c-{replace(@id,':','-')}"/>
                        </xsl:for-each>
                    </choice>
                </zeroOrMore>
            </element>
        </define>

        <xsl:apply-templates select="lexus:container" mode="rng"/>

    </xsl:template>

    <!--
        Generate a RelaxNG element to match the <data/> elements.
        -->
    <xsl:template match="lexus:datacategory" mode="rng">
        <element name="data">
            <optional>
                <attribute name="id"/>
            </optional>
            <attribute name="schema-ref">
                <value>
                    <xsl:value-of select="@id"/>
                </value>
            </attribute>
            <attribute name="name">
                <value>
                    <xsl:value-of select="@name"/>
                </value>
            </attribute>
            <element name="value">
                <text/>
            </element>
        </element>
    </xsl:template>

    <!--
        Generate a RelaxNG element to match the <container/> elements.
    -->
    <xsl:template match="lexus:container" mode="rng">
        <define name="c-{replace(@id,':','-')}">
            <element name="container">
                <optional>
                    <attribute name="id"/>
                </optional>
                <attribute name="schema-ref">
                    <value>
                        <xsl:value-of select="@id"/>
                    </value>
                </attribute>
                <attribute name="name">
                    <value>
                        <xsl:value-of select="@name"/>
                    </value>
                </attribute>
                <zeroOrMore>
                    <choice>
                        <!-- data categories -->
                        <xsl:apply-templates select="lexus:datacategory" mode="rng"/>
                        <!-- containers -->
                        <xsl:for-each select="lexus:container">
                            <ref name="c-{replace(@id,':','-')}"/>
                        </xsl:for-each>
                    </choice>
                </zeroOrMore>
            </element>
        </define>

        <xsl:apply-templates select="lexus:container" mode="rng"/>

    </xsl:template>

</xsl:stylesheet>
