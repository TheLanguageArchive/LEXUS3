<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:util="java:java.util.UUID"
    version="2.0">

    <xsl:include href="../../util/identity.xslt"/>


    <xsl:template match="data">
        <xsl:copy>
            <xsl:apply-templates select="json"/>
            <xsl:copy-of select="user"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="json">
        <save-user>
            <xsl:if test="not(parameters/id)">
                <xsl:variable name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
                <id>
                    <xsl:value-of select="$id"/>
                </id>
            </xsl:if>
            <xsl:apply-templates select="parameters/*"/>
            <xsl:if test="not(role)">
                <accesslevel>10</accesslevel>
            </xsl:if>
            <workspace>
                <queries/>
                <sortorders/>
            </workspace>
        </save-user>
    </xsl:template>

    <xsl:template match="username">
        <account>
            <xsl:value-of select="."/>
        </account>
    </xsl:template>

    <xsl:template match="displayName">
        <name>
            <xsl:value-of select="."/>
        </name>
    </xsl:template>
</xsl:stylesheet>
