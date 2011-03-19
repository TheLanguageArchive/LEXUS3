<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Turn a query in shabby JSON-client-side format into a good looking super hot lexus
                standard query!</xd:p>
        </xd:desc>
    </xd:doc>



    <!--
        Process the query element from the expression.
        Expression are always like this:
        <query>
            <lexicon>
                <datacategory>
                    <datacategory>
                        ...
                    ...
                <datacategory>*
            <lexicon>+
        <query>
    -->
    <xsl:template match="query" mode="json-query">
        <xsl:param name="startLetter" select="''"/>
        <xsl:copy>
            <xsl:attribute name="id" select="id"/>
            <xsl:copy-of select="name | description"/>
            <expression>
                <xsl:apply-templates select="children/children" mode="json-query-lexicon">
                    <xsl:with-param name="startLetter" select="$startLetter"/>
                </xsl:apply-templates>
            </expression>
        </xsl:copy>
    </xsl:template>

    <!--
        Process a lexicon element from the expression.
    -->
    <xsl:template match="children" mode="json-query-lexicon">
        <xsl:param name="startLetter" select="''"/>
        <lexicon id="{id}" name="{name}">
            <xsl:apply-templates select="children/children" mode="json-query-first-level">
                <xsl:with-param name="startLetter" select="$startLetter"/>
            </xsl:apply-templates>
        </lexicon>
    </xsl:template>


    <!--
        Process a first level (OR level) datacategory element from the expression.
    -->
    <xsl:template match="children" mode="json-query-first-level">
        <xsl:param name="startLetter" select="''"/>
        <datacategory schema-ref="{id}" name="{name}" value="{value}" condition="{condition}"
            negation="{negation}">
            <!-- If a start character was chosen in the UI, add a datacategory element for it,
                match the first datacategory element used in the list view. -->
            <xsl:if test="$startLetter ne ''">
                <datacategory schema-ref="" ref="lexus:first-datacategory-in-listview" name=""
                    value="{$startLetter}" condition="begins with"
                    negation="false"/>
            </xsl:if>
            <xsl:apply-templates select="children/children" mode="json-query"/>
        </datacategory>
    </xsl:template>
    
    <!--
        Process a datacategory element (AND-level) from the expression.
        -->
    <xsl:template match="children" mode="json-query">
        <datacategory schema-ref="{id}" name="{name}" value="{value}" condition="{condition}"
            negation="{negation}">
            <xsl:apply-templates select="children/children" mode="json-query"/>
        </datacategory>
    </xsl:template>


</xsl:stylesheet>
