<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="java:java.util.UUID"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

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
    <xsl:variable name="schema-lexical-entry-id"
        select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="schema-form-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="schema-sense-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>

    <xsl:template match="/data">
        <data>
            <lexus:create-lexicon>
                <lexus id="{$id}">
                    <lexicon id="{$id}">
                        <lexicon-information id="{concat('uuid:',util:toString(util:randomUUID()))}"
                            schema-id="{$schema-lexicon-information-id}"/>
                        <lexical-entry id="{concat('uuid:',util:toString(util:randomUUID()))}"
                            schema-id="{$schema-lexical-entry-id}">
                            <container id="{concat('uuid:',util:toString(util:randomUUID()))}"
                                schema-id="{$schema-form-id}"/>
                            <container id="{concat('uuid:',util:toString(util:randomUUID()))}"
                                schema-id="{$schema-sense-id}"/>
                        </lexical-entry>
                    </lexicon>
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
                            <container id="{$id}"
                                description="The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry"
                                name="Lexicon" mandatory="true" multiple="false" type="lexicon"
                                admin-info="">
                                <container id="{$schema-lexical-entry-id}"
                                    description="Represents a word, a multi-word expression, or an affix in a given language"
                                    name="Lexical Entry" mandatory="true" multiple="true"
                                    type="lexical-entry" admin-info="">
                                    <container id="{$schema-form-id}"
                                        description="Represents one lexical variant of the written or spoken form of the lexical entry"
                                        name="form" mandatory="true" multiple="false" type="Form"
                                        admin-info=""/>
                                    <container id="{$schema-sense-id}"
                                        description="Contains attributes that describe meanings of a lexical entry"
                                        name="sense" mandatory="true" multiple="false" type="Sense"
                                        admin-info=""/>
                                </container>
                            </container>
                        </schema>
                    </meta>
                </lexus>
            </lexus:create-lexicon>
            <lexus:get-saved-lexicon id="{$id}"/>
            <log id="{$id}">
                <entry type="create-lexicon" date-time="{current-dateTime()}" user="{/data/user/@id}"
                    username="{/data/user/name}"/>
            </log>
            <xsl:copy-of select="user"/>
        </data>
    </xsl:template>

</xsl:stylesheet>
