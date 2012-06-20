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
                    <element name="name">
                        <text/>
                    </element>
                    <element name="description">
                        <text/>
                    </element>
                    <element name="note">
                        <text/>
                    </element>
                </element>
            </define>

            <define name="data">
                <element name="data" ns="http://www.mpi.nl/lexus">
                    <attribute name="id"/>
                    <attribute name="schema-ref"/>
                    <attribute name="name"/>
                    <element name="value">
                        <text/>
                    </element>
                </element>
            </define>

            <define name="container">
                <element name="container" ns="http://www.mpi.nl/lexus">
                    <attribute name="id"/>
                    <attribute name="schema-ref"/>
                    <attribute name="name"/>
                    <zeroOrMore>
                        <ref name="data"/>
                    </zeroOrMore>
                    <zeroOrMore>
                        <ref name="container"/>
                    </zeroOrMore>
                </element>
            </define>

            <define name="lexical-entry">
                <element name="lexical-entry" ns="http://www.mpi.nl/lexus">
                    <attribute name="id"/>
                    <attribute name="schema-ref"/>
                    <zeroOrMore>
                        <ref name="data"/>
                    </zeroOrMore>
                    <zeroOrMore>
                        <ref name="container"/>
                    </zeroOrMore>
                </element>
            </define>
        </grammar>
    </xsl:template>

    <!--
        Skip the lexicon and lexical-entry containers (already taken care of.
        -->
<!--    <xsl:template match="container[@type eq 'lexicon' or @type eq 'lexical-entry']" mode="relaxng">
        <xsl:apply-templates mode="relaxng"/>
    </xsl:template>


    <!-\-
        Generate a RelaxNG element to match the <data/> elements.
        -\->
    <xsl:template match="container[@type eq 'data']" mode="relaxng" priority="1">
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


    <!-\-
        Generate a RelaxNG element to match the <container/> elements.
    -\->
    <xsl:template match="container" mode="relaxng">
        <element xmlns="http://relaxng.org/ns/structure/1.0" name="container"
            ns="http://www.mpi.nl/lexus">
            <attribute name="id"/>
            <attribute name="schema-ref"/>
            <attribute name="name">
                <value>
                    <xsl:value-of select="@name"/>
                </value>
            </attribute>
            <xsl:apply-templates mode="relaxng"/>
        </element>
    </xsl:template>
-->
</xsl:stylesheet>
