<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:util="java:java.util.UUID"
    xmlns:lexus="http://www.mpi.nl/lexus" exclude-result-prefixes="xd" version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jun 10, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Create a Klingon lexicon from the Klingon Extended Corpus.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:variable name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexiconId" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexicalEntryId" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexemeGroupId" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexemeId" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="meaningId" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="typeId" select="concat('uuid:',util:toString(util:randomUUID()))"/>


    <xsl:template match="/">
        <lexus:lexus>
            <lexus:lexicon version="1.0" id="{$id}">
                <lexus:lexicon-information>
                    <lexus:name>Klingon Extended Corpus</lexus:name>
                    <lexus:description>This is the Klingon demo lexicon for
                        Lexus</lexus:description>
                    <lexus:note>Adapted from http://www.kli.org/stuff/ECP.html</lexus:note>
                </lexus:lexicon-information>
                <xsl:apply-templates select="klingon/dictionary/dl/dt"/>
            </lexus:lexicon>

            <lexus:meta xmlns:lexus="http://www.mpi.nl/lexus" version="1.0" id="{$id}">
                <lexus:schema>
                    <lexus:container id="{concat('uuid:',util:toString(util:randomUUID()))}"
                        description="Represents the entire lexicon" type="lexicon" name="Lexicon"
                        mandatory="true" multiple="false" note="" admin-info="">
                        <lexus:container
                            description="Represents a word, a multi-word expression, or an affix in a given language"
                            type="lexical-entry" name="lexical-entry"
                            id="{$lexicalEntryId}">
                            <lexus:container 
                                description="LexemeGroup" name="LexemeGroup" type="component"
                                id="{$lexemeGroupId}">
                                <lexus:datacategory xmlns:dcr="http://www.isocat.org/ns/dcr"
                                    description="lexeme" name="Lexeme" type="data"
                                    id="{$lexemeId}"
                                    dcr:datcat="http://www.isocat.org/datcat/DC-3723"
                                    />
                                <lexus:datacategory xmlns:dcr="http://www.isocat.org/ns/dcr"
                                    description="Meaning." name="meaning" type="data"
                                    id="{$meaningId}"
                                    />
                                <lexus:datacategory xmlns:dcr="http://www.isocat.org/ns/dcr"
                                    description="Type." name="type" type="data"
                                    id="{$typeId}"
                                    />
                            </lexus:container>
                        </lexus:container>
                    </lexus:container>
                </lexus:schema>
            </lexus:meta>
        </lexus:lexus>
    </xsl:template>


    <!--
        Match a word in the Klingon language. The following-sibling::dd contains
        more information on the word.
        -->
    <xsl:template match="dt">
        <lexus:lexical-entry schema-ref="{$lexicalEntryId}" id="{concat('uuid:',util:toString(util:randomUUID()))}">
            <lexus:container schema-ref="{$lexemeGroupId}" name="LexemeGroup" id="{concat('uuid:',util:toString(util:randomUUID()))}">
                <lexus:data schema-ref="{$lexemeId}" name="Lexeme" id="{concat('uuid:',util:toString(util:randomUUID()))}">
                    <lexus:value>
                        <xsl:value-of select="strong[@class='entry']"/>
                    </lexus:value>
                </lexus:data>
                <xsl:apply-templates select="following-sibling::dd[1]"/>
            </lexus:container>
        </lexus:lexical-entry>

    </xsl:template>

    <!--
        Process info about a lexical entry.
        -->
    <xsl:template match="dd">
        <lexus:data schema-ref="{$meaningId}" name="meaning" id="{concat('uuid:',util:toString(util:randomUUID()))}">
            <lexus:value>
                <xsl:apply-templates select="node()"/>
            </lexus:value>
        </lexus:data>
        <lexus:data schema-ref="{$typeId}" name="type" id="{concat('uuid:',util:toString(util:randomUUID()))}">
            <lexus:value>
                <xsl:value-of select="translate(b[1], '()', '')"/>
            </lexus:value>
        </lexus:data>
    </xsl:template>


    <!--
        Process the elements and text in the info element for a word.
    -->

    <!-- Skip the first b element, it contains the type. -->
    <xsl:template match="b[not(preceding-sibling::b)]"/>

    <!-- Ignore i elements, but process their content  -->
    <xsl:template match="i">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Ignore a elements and their content. -->
    <xsl:template match="a"/>

    <!-- Ouput text but skip [ and ] -->
    <xsl:template match="text()" priority="1">
        <xsl:value-of select="translate(., '[]', '')"/>
    </xsl:template>

    <!-- I don't think there are other elements, but if there are, ignore the elements and process their content. -->
    <!--<xsl:template match="node()">
        <other-element name="local-name()">
            <xsl:apply-templates/>
        </other-element>
    </xsl:template>-->

</xsl:stylesheet>
