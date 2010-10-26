<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0" xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">


    <!--
        Generate the RelaxNG schema file.
    -->
    <xsl:template match="meta" mode="relaxng">
        <grammar xmlns="http://relaxng.org/ns/structure/1.0">
            <start>
                <element name="lexicon" ns="http://www.mpi.nl/lexus">
                    <attribute name="id"/>
                    <attribute name="version"/>
                    <ref name="lexicon-information"/>
                    <oneOrMore>
                        <ref name="lexical-entry"/>
                    </oneOrMore>
                </element>
            </start>

            <define name="lexicon-information">
                <element name="lexicon-information" ns="http://www.mpi.nl/lexus">
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

            <define name="lexical-entry">
                <element name="lexical-entry" ns="http://www.mpi.nl/lexus">
                    <attribute name="id"/>
                    <attribute name="schema-ref"/>
                    <!--
                        HHV: Interleave the data elements and the containers.
                        The export from the old backend does not export a lexical entry
                        with the dc's and components in the right order, according to schema
                        that is. Should be fixed there, but for now... Yikes!
                    -->
                    <xsl:if test="schema/container[@type eq 'data']">
                        <interleave>
                            <xsl:apply-templates select="schema/container[@type eq 'data']"
                                mode="relaxng"/>
                        </interleave>
                    </xsl:if>
                    <xsl:if test="schema/container[@type ne 'data']">
                        <interleave>
                            <xsl:apply-templates select="schema/container[@type ne 'data']"
                                mode="relaxng"/>
                        </interleave>
                    </xsl:if>
                </element>
            </define>
        </grammar>
    </xsl:template>

    <!--
        Skip the lexicon and lexical-entry containers (already taken care of).
        -->
    <xsl:template match="container[@type eq 'lexicon' or @type eq 'lexical-entry']" mode="relaxng" priority="10">
        <xsl:apply-templates mode="relaxng"/>
    </xsl:template>


    <!--
        Generate a RelaxNG element to match the <data/> elements.
        -->
    <xsl:template match="container[@type = 'data'][@mandatory = 'false']" mode="relaxng"
        priority="4">
        <optional xmlns="http://relaxng.org/ns/structure/1.0">
            <xsl:call-template name="data"/>
        </optional>
    </xsl:template>
    <xsl:template match="container[@type = 'data']" mode="relaxng" priority="1">
        <xsl:call-template name="data"/>
    </xsl:template>
    <xsl:template name="data">
        <element xmlns="http://relaxng.org/ns/structure/1.0" name="data"
            ns="http://www.mpi.nl/lexus">
            <attribute name="id"/>
            <attribute name="schema-ref"/>
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
    <xsl:template match="container[@type != 'data'][@mandatory = 'false']" mode="relaxng" priority="4">
        <optional xmlns="http://relaxng.org/ns/structure/1.0">
            <xsl:call-template name="container"/>
        </optional>
    </xsl:template>
    <xsl:template match="container[@type != 'data']" mode="relaxng" priority="1">
        <xsl:call-template name="container"/>
    </xsl:template>
    <xsl:template name="container">
        <element xmlns="http://relaxng.org/ns/structure/1.0" name="container"
            ns="http://www.mpi.nl/lexus">
            <attribute name="id"/>
            <attribute name="schema-ref"/>
            <attribute name="name">
                <value>
                    <xsl:value-of select="@name"/>
                </value>
            </attribute>

            <xsl:if test="container[@type eq 'data']">
                <interleave>
                    <xsl:apply-templates select="container[@type eq 'data']" mode="relaxng"/>
                </interleave>
            </xsl:if>
            <xsl:if test="container[@type ne 'data']">
                <interleave>
                    <xsl:apply-templates select="container[@type ne 'data']" mode="relaxng"/>
                </interleave>
            </xsl:if>
        </element>
    </xsl:template>
</xsl:stylesheet>
