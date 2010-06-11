<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">


    <!-- 
        Transform this:
        <schema>
            <component id="uuid:67a9c4d1-7fb1-4c4a-b3a8-c67a494e449a" description="The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry" name="Lexicon" mandatory="true" multiple="false" type="lexicon">
                <component id="uuid:ef64b80b-5aad-4392-9265-296000ccd87b" description="Contains administrative information and other general attributes" name="Lexicon Information" type="lexicon-information" mandatory="true" multiple="false"/>
                <component id="uuid:9e1dbc3c-55d1-4ba2-96b8-391f779a16ab" description="Represents a word, a multi-word expression, or an affix in a given language" name="lexical-entry" mandatory="true" multiple="true" type="lexical-entry">
                   <component id="uuid:6b9f1ff4-6349-4c08-96ad-d04d29533813" description="Represents one lexical variant of the written or spoken form of the lexical entry" name="Form" mandatory="true" multiple="false" type="form"/>
                   <component id="uuid:c27cd277-9852-4fd8-94bb-7909e25fdd8c" description="Contains attributes that describe meanings of a lexical entry" name="Sense" mandatory="true" multiple="false" type="sense"/>
               </component>
            </component>
        </schema>
        to this:
        "mySchema":             [
        {
        "min": 0,
        "max": null,
        "sortOrder": null,
        "parent": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2VjNDAwNDA=",
        "DCRReference": "xe",
        "type": "data category",
        "id": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2VjNDAwNDI=",
        "adminInfo": null,
        "valuedomain": [],
        "description": "This provides the English translation of the example sentence given in the \\xv field.",
        "DCR": "user defined",
        "name": "Example free trans. (E)",
        "note": null
        },
        -->
    <xsl:template match="schema">
        <array key="mySchema">
            <xsl:apply-templates select=".//component"/>
        </array>
    </xsl:template>

    <!-- 
        {
        "min": 1,
        "adminInfo": "to be filled out ",
        "id": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDc2ZDAwMDY=",
        "max": 1,
        "description": null,
        "name": "lexicon",
        "parent": null,
        "type": "Lexicon",
        "note": null
        }
    -->
    <xsl:template match="component[@type='lexicon']" priority="1">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <number key="min">1</number>
            <number key="max">1</number>
            <string key="adminInfo"/>
            <string key="description"/>
            <string key="type">Lexicon</string>
            <string key="name">lexicon</string>
            <string key="parent">null</string>
            <string key="note"/>
        </object>
    </xsl:template>

    <!-- 
        {
        "min": 1,
        "adminInfo": null,
        "id": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDdhMzAwMGU=",
        "max": 1,
        "description": null,
        "name": "lexiconInformation",
        "parent": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDc2ZDAwMDY=",
        "type": "component",
        "note": null
        }
    -->
    <xsl:template match="component[@type='lexicon-information']" priority="1">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <number key="min">1</number>
            <number key="max">1</number>
            <string key="adminInfo"/>
            <string key="description"/>
            <string key="type">component</string>
            <string key="name">lexiconInformation</string>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="note"/>
        </object>
    </xsl:template>

    <!-- 
        {
        "min": 0,
        "adminInfo": null,
        "id": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDc2ZTAwMDg=",
        "max": null,
        "description": null,
        "name": "lexicalEntry",
        "parent": "MmM5MDkwYzEwOWZkM2U0ZDAxMDlmZDNmNDc2ZDAwMDY=",
        "type": "LexicalEntry",
        "note": null
        }-->
    <xsl:template match="component[@type='lexical-entry']" priority="1">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <number key="min">1</number>
            <string key="max">null</string>
            <string key="adminInfo"/>
            <string key="description"/>
            <string key="type">LexicalEntry</string>
            <string key="name">lexicalEntry</string>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="note"/>
        </object>
    </xsl:template>

    <!-- 
        {
        "min": 0,
        "max": null,
        "sortOrder": null,
        "parent": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2VjNDAwNDA=",
        "DCRReference": "xe",
        "type": "data category",
        "id": "MmM5MDk5ODQyNzFlMDBkYjAxMjcxZTAxN2VjNDAwNDI=",
        "adminInfo": null,
        "valuedomain": [],
        "description": "This provides the English translation of the example sentence given in the \\xv field.",
        "DCR": "user defined",
        "name": "Example free trans. (E)",
        "note": null
        }
    -->
    <xsl:template match="component[not(component)]">
        <object>
            <number key="min">
                <xsl:choose>
                    <xsl:when test="@mandatory='true'"> 1 </xsl:when>
                    <xsl:otherwise> 0 </xsl:otherwise>
                </xsl:choose>
            </number>
            <number key="max">
                <xsl:choose>
                    <xsl:when test="@multiple='false'"> 1 </xsl:when>
                    <xsl:otherwise>null</xsl:otherwise>
                </xsl:choose>
            </number>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="type">data category</string>
            <string key="name">
                <xsl:value-of select="@name"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="DCR">
                <xsl:value-of select="@dcr"/>
            </string>
            <string key="DCRReference">
                <xsl:value-of select="@dcrReference"/>
            </string>
            <string key="sortOrder">
                <xsl:value-of select="@sortOrder"/>
            </string>
        </object>
    </xsl:template>

    <xsl:template match="component[component]">
        <object>
            <number key="min">
                <xsl:choose>
                    <xsl:when test="@mandatory='true'"> 1 </xsl:when>
                    <xsl:otherwise> 0 </xsl:otherwise>
                </xsl:choose>
            </number>
            <number key="max">
                <xsl:choose>
                    <xsl:when test="@multiple='false'"> 1 </xsl:when>
                    <xsl:otherwise>null</xsl:otherwise>
                </xsl:choose>
            </number>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="type">component</string>
            <string key="name">
                <xsl:value-of select="@name"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="DCR">
                <xsl:value-of select="@dcr"/>
            </string>
            <string key="DCRReference">
                <xsl:value-of select="@dcrReference"/>
            </string>
            <string key="sortOrder">
                <xsl:value-of select="@sortOrder"/>
            </string>
        </object>
    </xsl:template>

</xsl:stylesheet>
