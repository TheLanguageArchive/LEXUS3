<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:template match="/data">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="data//lexus:result[@success eq 'false']">
                    <xsl:attribute name="success">false</xsl:attribute>
                    <xsl:apply-templates select="data//lexus:result[@success eq 'false']"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="success">true</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="lexus:create-lexicon[lexus:result[@success eq 'false']]">
        <message><xsl:text>Failed to create the lexicon.</xsl:text></message>
    </xsl:template>

    <xsl:template match="lexus:replace-lexicon-information[lexus:result[@success eq 'false']]">
        <message><xsl:text>Failed to add lexicon information (name, description, note) the lexicon.</xsl:text></message>
    </xsl:template>

    <xsl:template match="lexus:save-lexical-entries[lexus:result[@success eq 'false']]">
        <message>
            <xsl:text>Failed to insert lexical entries </xsl:text>
            <xsl:value-of select="@first"/>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="@last"/>
            <xsl:text> into the lexicon.</xsl:text>
        </message>
    </xsl:template>

    <xsl:template match="@* | node()"/>


</xsl:stylesheet>
