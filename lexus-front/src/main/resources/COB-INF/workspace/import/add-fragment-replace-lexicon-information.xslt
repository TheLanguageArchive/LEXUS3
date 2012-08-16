<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:fragments="http://org.apache.cocoon.transformation/fragments/1.0"
    xmlns:util="java:java.util.UUID" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Aug 10, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> andmor</xd:p>
            <xd:p/>
            <xd:p>Replace the lexicon: name, description and note, by the ones contained in the
                'lexicon-information' element.</xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:template match="data">
        <data>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <xsl:variable name="lexiconId" select="@new-lexicon-id"/>
            <xsl:variable name="userId" select="user/@id"/>
            <fragments:transform fragment-name="replace-lexicon-information"
                fragment-namespace="http://www.mpi.nl/lexus">
                <lexus:replace-lexicon-information lexicon="{$lexiconId}" user="{$userId}">
                    <xsl:if test="exists(lexus:lexicon-information)">
                        <xsl:apply-templates select="lexus:lexicon-information" mode="lexus-ns"/>
                    </xsl:if>
                    <xsl:if test="not(exists(lexus:lexicon-information))">
                        <lexus:lexicon-information>
                            <lexus:name>UnamedLexicon!</lexus:name>
                            <lexus:description>LEXUS could not determine a name and description for this imported lexicon.
The 'lexicon-information' element seems to be missing from the lexicon data file.</lexus:description>
                            <lexus:note/>
                        </lexus:lexicon-information>
                    </xsl:if>
                </lexus:replace-lexicon-information>
            </fragments:transform>
        </data>
    </xsl:template>
    <!--
        Identity transform.
        -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--
        Identity transform for elements in the 'lexus' namespace.
        It removes the ns declaration and add the prefix.
        -->
    <xsl:template match="element()" mode="lexus-ns">
        <xsl:element name="lexus:{local-name()}">
            <xsl:apply-templates select="node()|@*" mode="lexus-ns"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
