<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="java:java.util.UUID"
    version="2.0">

    <!-- 
        Prepare to create a new lexicon, using the JSON input:
    
           {
           "id": "53DBFE6E-5B55-FF7B-7A93-5DE43E752E89",
           "requester": "workspace",
           "parameters":         {
           "name": "qwerty",
           "description": "asdf",
           "size": 0,
           "note": "nootje"
           }
    
    -->

    <xsl:param name="endpoint"/>
    <xsl:param name="users-collection"/>

    <xsl:variable name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="schema-lexicon-information-id"
        select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexicon-name-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexicon-description-id"
        select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexicon-note-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="schema-lexical-entry-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="schema-form-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="schema-sense-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>

    <xsl:template match="/data">
        <data>
            <lexicon id="{$id}">
                <lexicon-information id="{concat('uuid:',util:toString(util:randomUUID()))}" schema-id="{$schema-lexicon-information-id}"/> 
                <lexical-entry id="{concat('uuid:',util:toString(util:randomUUID()))}" schema-id="{$schema-lexical-entry-id}">
                    <component id="{concat('uuid:',util:toString(util:randomUUID()))}" schema-id="{$schema-form-id}"/>
                    <component id="{concat('uuid:',util:toString(util:randomUUID()))}" schema-id="{$schema-sense-id}"/>
                </lexical-entry>
            </lexicon>
            <lexus id="{$id}">
                <meta>
                    <name>
                        <xsl:value-of select="json/parameters/name"/>
                    </name>
                    <description>
                        <xsl:value-of select="json/parameters/description"/>
                    </description>
                    <note>
                        <xsl:value-of select="json/parameters/note"/>
                    </note>
                    <owner ref="{user/@id}"/>
                    <users>
                        <user ref="{user/@id}">
                            <permissions>
                                <read>true</read>
                                <write>true</write>
                            </permissions>
                        </user>
                    </users>
                    <schema>
                        <component id="{$id}"
                            description="The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry"
                            name="Lexicon" mandatory="true" multiple="false" type="Lexicon" admin-info="">
                            <component id="{$schema-lexicon-information-id}"
                                description="Contains administrative information and other general attributes"
                                name="Lexicon Information" type="LexiconInformation"
                                mandatory="true" multiple="false" admin-info=""/> 
                            <component id="{$schema-lexical-entry-id}"
                                description="Represents a word, a multi-word expression, or an affix in a given language"
                                name="lexical entry" mandatory="true" multiple="true"
                                type="LexicalEntry" admin-info="">
                                <component id="{$schema-form-id}"
                                    description="Represents one lexical variant of the written or spoken form of the lexical entry"
                                    name="Form" mandatory="true" multiple="false" type="Form" admin-info=""/>
                                <component id="{$schema-sense-id}"
                                    description="Contains attributes that describe meanings of a lexical entry"
                                    name="Sense" mandatory="true" multiple="false" type="Sense" admin-info=""/>
                            </component>
                        </component>
                    </schema>
                </meta>
            </lexus>
            <log id="{$id}">
                <entry type="create-lexicon" date-time="{current-dateTime()}" user="{data/user/@id}"
                    username="{data/user/name}"/>
            </log>
            <xsl:copy-of select="user"/>
        </data>
    </xsl:template>

</xsl:stylesheet>
