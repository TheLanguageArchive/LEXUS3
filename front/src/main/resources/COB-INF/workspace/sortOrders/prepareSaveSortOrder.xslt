<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="java:java.util.UUID"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <!-- 

    original app's JSON to mimic (but leave out stuff that's unnecessary, like "fill"):
    {
    "id": "9CA0F21B-98FF-7D76-919A-E0ED41243F44",
    "parameters":         {
    "id": "MmM5MDkwYzMyNjIzMGViZDAxMjYyYmUyOTE4ODAxNzA=",
    "description": "",
    "mx_internal_uid": "BB651210-CB42-1444-4B82-E0ED0A2B43D7",
    "name": "Marquesan",
    "fill": "a(a['a][-a][-'a]àáâä?['?][-'A]['A]AÀÁÂÄ?)e(e['e][-e]èéê?ë['E]EÈÉÊË)f(fF)h(hH)i(i['i][-i]ìíï[-'?]['?][-?]['I]IÌÍÏ)k(kK)m(mM)n(nñ[-n]NÑ)o(o['o][-o]?òóôõö['?]OÒÓ['O]ÔÕÖ)p(pP)r(rR)s(sS)t(t[-t]T)u(u['u][-u]úûü['?]['U]['?]UÙÚÛÜ)v(vV)?",
    "data":             [
    {
    "characters": "a['a][-a][-'a]àáâä?['?][-'A]['A]AÀÁÂÄ?",
    "mx_internal_uid": "D46C2CA5-6CC7-E204-F0CE-E0ED0A330237",
    "startLetter": "a"
    },
    {
    "characters": "e['e][-e]èéê?ë['E]EÈÉÊË",
    "mx_internal_uid": "08FB051D-0559-4A69-8779-E0ED0A437312",
    "startLetter": "e"
    },
    ]
    },
    "requester": "Workspace58"
    }
-->

    <xsl:template match="/data">
        <xsl:copy>
            <xsl:apply-templates select="json/parameters"/>
            <xsl:copy-of select="user"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="parameters">
        <lexus:save-sortorder>
            <sortorder>
                <xsl:attribute name="id">
                    <xsl:choose>
                        <xsl:when test="id != ''">
                            <xsl:value-of select="id"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('uuid:',util:toString(util:randomUUID()))"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:copy-of select="name, description"/>
                <mappings>
                    <xsl:choose>
                        <xsl:when test="id != ''">
                            <xsl:apply-templates select="data/data"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Provide default mapping -->
                            <xsl:for-each select="97 to 122">
                                <mapping>
                                    <to>
                                        <xsl:value-of select="codepoints-to-string(.)"/>
                                    </to>
                                    <from>
                                        <xsl:value-of select="codepoints-to-string(. - 32)"/>
                                        <xsl:value-of select="codepoints-to-string(.)"/>
                                    </from>
                                </mapping>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </mappings>
            </sortorder>
        </lexus:save-sortorder>
    </xsl:template>


    <xsl:template match="data/data">
        <mapping>
            <xsl:apply-templates select="characters, startLetter"/>
        </mapping>
    </xsl:template>

    <xsl:template match="startLetter">
        <to>
            <xsl:apply-templates/>
        </to>
    </xsl:template>

    <xsl:template match="characters">
        <from>
            <xsl:apply-templates/>
        </from>
    </xsl:template>

</xsl:stylesheet>
