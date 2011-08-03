<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">


    <!-- 
            Transform this:
            <schema>
            <container id="uuid:67a9c4d1-7fb1-4c4a-b3a8-c67a494e449a" description="The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry" name="Lexicon" mandatory="true" multiple="false" type="lexicon">
            <container id="uuid:ef64b80b-5aad-4392-9265-296000ccd87b" description="Contains administrative information and other general attributes" name="Lexicon Information" type="lexicon-information" mandatory="true" multiple="false"/>
            <container id="uuid:9e1dbc3c-55d1-4ba2-96b8-391f779a16ab" description="Represents a word, a multi-word expression, or an affix in a given language" name="lexical-entry" mandatory="true" multiple="true" type="lexical-entry">
            <container id="uuid:6b9f1ff4-6349-4c08-96ad-d04d29533813" description="Represents one lexical variant of the written or spoken form of the lexical entry" name="Form" mandatory="true" multiple="false" type="form"/>
            <container id="uuid:c27cd277-9852-4fd8-94bb-7909e25fdd8c" description="Contains attributes that describe meanings of a lexical entry" name="Sense" mandatory="true" multiple="false" type="sense"/>
            </container>
            </container>
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
        <xsl:param name="tree" select="'true'"/>
        <xsl:choose>
            <xsl:when test="$tree eq 'true'">
                <!-- Generate the tree schema with the name 'schema' -->
                <object key="schema">
                    <xsl:apply-templates select="container">
                        <xsl:with-param name="tree" select="$tree"/>
                    </xsl:apply-templates>
                </object>
            </xsl:when>
            <xsl:otherwise>
                <!-- Generate the list schema with the name 'mySchema' -->
                <array key="mySchema">
                    <xsl:apply-templates select=".//container">
                        <xsl:with-param name="tree" select="$tree"/>
                    </xsl:apply-templates>
                </array>
            </xsl:otherwise>
        </xsl:choose>
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
    <xsl:template match="container[@type='lexicon']" priority="10">
        <xsl:param name="tree"/>
        <xsl:choose>
            <xsl:when test="$tree eq 'false'">
                <object>
                    <xsl:call-template name="lexicon-container">
                        <xsl:with-param name="tree" select="$tree"/>
                    </xsl:call-template>
                </object>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="lexicon-container">
                    <xsl:with-param name="tree" select="$tree"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="lexicon-container">
        <xsl:param name="tree"/>
        <string key="id">
            <xsl:value-of select="@id"/>
        </string>
        <number key="min">1</number>
        <number key="max">1</number>
        <string key="adminInfo">
            <xsl:value-of select="@admin-info"/>
        </string>
        <string key="description">
            <xsl:value-of select="@description"/>
        </string>
        <string key="type">Lexicon</string>
        <string key="name">lexicon</string>
        <null key="parent"/>
        <string key="note">
                <xsl:value-of select="@note"/>
        </string>
        <xsl:if test="container and $tree eq 'true'">
            <array key="children">
                <xsl:apply-templates select="container">
                    <xsl:with-param name="tree" select="$tree"/>
                </xsl:apply-templates>
            </array>
        </xsl:if>

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
    <!--<xsl:template match="container[@type='lexicon-information']" priority="10">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <number key="min">1</number>
            <number key="max">1</number>
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="type">component</string>
            <string key="name">lexiconInformation</string>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="note"/>
            <xsl:if test="container">
                <array key="children">
                <xsl:apply-templates select="container"/>
                </array>
            </xsl:if>
        </object>
    </xsl:template>-->

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
    <xsl:template match="container[@type='lexical-entry']" priority="10">
        <xsl:param name="tree"/>
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <number key="min">1</number>
            <null key="max"/>
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
            <string key="description">
                <xsl:value-of select="@description"/>
            </string>
            <string key="type">LexicalEntry</string>
            <string key="name">lexicalEntry</string>
            <string key="parent">
                <xsl:value-of select="../@id"/>
            </string>
            <string key="note">
                <xsl:value-of select="@note"/>
            </string>
            <xsl:if test="container and $tree eq 'true'">
                <array key="children">
                    <xsl:apply-templates select="container">
                        <xsl:with-param name="tree" select="$tree"/>
                    </xsl:apply-templates>
                </array>
            </xsl:if>
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
    <xsl:template match="container[@type eq 'data']" priority="10">
        <xsl:param name="tree"/>
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <xsl:if test="$tree eq 'true'">
                <xsl:choose>
                    <xsl:when test="@sort-order">
                        <object key="sortOrder">
                            <string key="id">
                                <xsl:value-of select="@sort-order"/>
                            </string>
                        </object>
                    </xsl:when>
                    <xsl:otherwise>
                        <null key="sortOrder"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <number key="min">
                <xsl:choose>
                    <xsl:when test="@mandatory eq 'true'">
                        <xsl:text>1</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </number>
            <xsl:choose>
                <xsl:when test="@multiple eq 'false'">
                    <number key="max">
                        <xsl:text>1</xsl:text>
                    </number>
                </xsl:when>
                <xsl:otherwise>
                    <null key="max"/>
                </xsl:otherwise>
            </xsl:choose>
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
                <xsl:choose>
                    <xsl:when test="@registry eq 'ISO-12620'">
                        <xsl:text>12620</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@registry"/>
                    </xsl:otherwise>
                </xsl:choose>
            </string>
            <string key="DCRReference">
                <xsl:value-of select="@reference"/>
            </string>
            <xsl:if test="$tree eq 'false'">
                <string key="sortOrder">
                    <xsl:value-of select="@sortOrder"/>
                </string>
            </xsl:if>
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
            <string key="note">
                <xsl:value-of select="@note"/>
            </string>
            <array key="valuedomain">
                <xsl:apply-templates select="valuedomain/domainvalue"/>
            </array>
        </object>
    </xsl:template>

    <xsl:template match="domainvalue">
        <object>
            <string key="value">
                <xsl:value-of select="."/>
            </string>
        </object>
    </xsl:template>

    <xsl:template match="container" priority="1">
        <xsl:param name="tree"/>
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <xsl:if test="$tree eq 'true'">
                <xsl:choose>
                    <xsl:when test="@sort-order">
                        <object key="sortOrder">
                            <string key="id">
                                <xsl:value-of select="@sort-order"/>
                            </string>
                        </object>
                    </xsl:when>
                    <xsl:otherwise>
                        <null key="sortOrder"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <number key="min">
                <xsl:choose>
                    <xsl:when test="@mandatory eq 'true'">
                        <xsl:text>1</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </number>
            <xsl:choose>
                <xsl:when test="@multiple eq 'false'">
                    <number key="max">
                        <xsl:text>1</xsl:text>
                    </number>
                </xsl:when>
                <xsl:otherwise>
                    <null key="max"/>
                </xsl:otherwise>
            </xsl:choose>
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
                <xsl:choose>
                    <xsl:when test="@registry eq 'ISO-12620'">
                        <xsl:text>12620</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@registry"/>
                    </xsl:otherwise>
                </xsl:choose>
            </string>
            <string key="DCRReference">
                <xsl:value-of select="@reference"/>
            </string>
            <xsl:if test="$tree eq 'false'">
                <string key="sortOrder">
                    <xsl:value-of select="@sortOrder"/>
                </string>
            </xsl:if>
            <string key="adminInfo">
                <xsl:value-of select="@admin-info"/>
            </string>
			<string key="note">
                <xsl:value-of select="@note"/>
            </string>
            <array key="children">
                <xsl:if test="$tree eq 'true' and container">
                    <xsl:apply-templates select="container">
                        <xsl:with-param name="tree" select="$tree"/>
                    </xsl:apply-templates>
                </xsl:if>
            </array>
        </object>
    </xsl:template>


</xsl:stylesheet>
