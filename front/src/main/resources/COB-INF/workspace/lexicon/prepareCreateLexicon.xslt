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
    <xsl:param name="dbpath"/>

    <xsl:variable name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexicon-information-id"
        select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexicon-name-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexicon-description-id"
        select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexicon-note-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="lexical-entry-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="form-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="sense-id" select="concat('uuid:',util:toString(util:randomUUID()))"/>

    <xsl:template match="/">
        <create-lexicon>
            <lexicon id="{$id}" version="1">
                <lexicon-information schema-id="{$lexicon-information-id}" version="1">
                    <data schema-id="{$lexicon-name-id}" name="Lexicon name" lexus-id="lexicon-name"
                        version="1">
                        <xsl:value-of select="/data/json/parameters/name"/>
                    </data>
                    <data schema-id="{$lexicon-description-id}" name="Lexicon description"
                        lexus-id="lexicon-description" version="1">
                        <xsl:value-of select="/data/json/parameters/description"/>
                    </data>
                    <data schema-id="{$lexicon-note-id}" name="Lexicon note" lexus-id="lexicon-note"
                        version="1">
                        <xsl:value-of select="/data/json/parameters/note"/>
                    </data>
                </lexicon-information>
                <lexical-entry schema-id="{$lexical-entry-id}" version="1">
                    <form schema-id="{$form-id}" version="1"/>
                    <sense schema-id="{$sense-id}" version="1"/>
                </lexical-entry>
            </lexicon>
            <lexus id="{$id}">
                <meta>
                    <owner ref="{data/user/@id}"/>
                    <users>
                        <user ref="{data/user/@id}">
                            <permissions>
                                <read>true</read>
                                <write>true</write>
                            </permissions>
                        </user>
                    </users>
                    <schema>
                        <!-- 
                            "min": 1,
                            "adminInfo": null,
                            "id": "MmM5MDk5OWMyODVkODE4MzAxMjg1ZGU0M2U4YTAwMDE=",
                            "max": 1,
                            "description": "The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry",
                            "name": "lexicon",
                            "parent": null,
                            "type": "Lexicon",
                            "note": null,
                            "style": null,
                            "children":                 [
                            {
                            "min": 0,
                            "max": null,
                            "sortOrder": null,
                            "parent": "MmM5MDkwYzMyNjIzMGViZDAxMjYyN2ZiMDhjZDAwMDg=",
                            "DCRReference": "lx",
                            "type": "data category",
                            "id": "MmM5MDkwYzMyNjIzMGViZDAxMjYyN2ZiMDhkYjAwYTg=",
                            "adminInfo": null,
                            "valuedomain": [],
                            "description": "The Record marker for each record in a lexical entry. It contains the lexeme or headword (which is commonly mono-morphemic). Since such a lexeme form is often not accessible for vernacular speakers if printed, use the \\lc field to provide a more readable form for vernacular speakers.",
                            "DCR": "user defined",
                            "name": "Lexeme",
                            "note": null,
                            "style": null
                            }
                        -->
                        <component id="{$id}"
                            description="The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry"
                            name="Lexicon" mandatory="true" multiple="false" type="lexicon">
                            <component id="{$lexicon-information-id}"
                                description="Contains administrative information and other general attributes"
                                name="Lexicon Information" type="lexicon-information"
                                mandatory="true" multiple="false">
                                <component id="{$lexicon-name-id}" description="Name of the lexicon"
                                    name="Lexicon name" type="data" mandatory="true"
                                    lexus-id="lexicon-name" multiple="false"/>
                                <component id="{$lexicon-description-id}"
                                    description="Description of the lexicon"
                                    lexus-id="lexicon-description" name="Lexicon description"
                                    type="data" mandatory="true" multiple="false"/>
                                <component id="{$lexicon-note-id}"
                                    description="Note for the lexicon" lexus-id="lexicon-note"
                                    name="Lexicon note" type="data" mandatory="false"
                                    multiple="false"/>
                            </component>
                            <component id="{$lexical-entry-id}"
                                description="Represents a word, a multi-word expression, or an affix in a given language"
                                name="lexical-entry" mandatory="true" multiple="true"
                                type="lexical-entry">
                                <component id="{$form-id}"
                                    description="Represents one lexical variant of the written or spoken form of the lexical entry"
                                    name="Form" mandatory="true" multiple="false" type="form"/>
                                <component id="{$sense-id}"
                                    description="Contains attributes that describe meanings of a lexical entry"
                                    name="Sense" mandatory="true" multiple="false" type="sense"/>
                            </component>
                        </component>
                    </schema>
                </meta>
            </lexus>
            <log id="{$id}">
                <entry type="create" date-time="{current-dateTime()}" user="{data/user/@id}"
                    username="{data/user/name}"/>
            </log>
        </create-lexicon>
    </xsl:template>

</xsl:stylesheet>
