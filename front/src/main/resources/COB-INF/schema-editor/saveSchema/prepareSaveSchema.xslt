<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:util="java:java.util.UUID" version="2.0">
    <!--
        
        Input is:
        <data>
            <json xmlns:json="http://apache.org/cocoon/json/1.0">
                <id>912580AC-03D2-97B8-9691-0320A125485A</id>
                <requester>SchemaEditor639</requester>
                <parameters>
                  <schema>
                    <schema>
                        <adminInfo/>
                        <min>1</min>
                        <id>uuid:67a9c4d1-7fb1-4c4a-b3a8-c67a494e449a</id>
                        <max>1</max>
                        <description/>
                        <name>lexicon</name>
                        <children>
                            <children>
                            <adminInfo>a&#13;</adminInfo>
                            <min>0</min>
                            <valuedomain>null</valuedomain>
                            <max>null</max>
                            <style/>
                            <DCR>null</DCR>
                            <description>a</description>
                            <name>a</name>
                            <DCRReference>null</DCRReference>
                            <type>data category</type>
                            </children>
                            <children>
      
      and it should be transformed to something like:
      <schema>
      <container id="uuid:67a9c4d1-7fb1-4c4a-b3a8-c67a494e449a" description="The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry" name="Lexicon" mandatory="true" multiple="false" type="lexicon">
      <container id="uuid:ef64b80b-5aad-4392-9265-296000ccd87b" description="Contains administrative information and other general attributes" name="Lexicon Information" type="lexicon-information" mandatory="true" multiple="false"/>
      <container id="uuid:9e1dbc3c-55d1-4ba2-96b8-391f779a16ab" description="Represents a word, a multi-word expression, or an affix in a given language" name="lexical-entry" mandatory="true" multiple="true" type="lexical-entry">
      <container id="uuid:6b9f1ff4-6349-4c08-96ad-d04d29533813" description="Represents one lexical variant of the written or spoken form of the lexical entry" name="Form" mandatory="true" multiple="false" type="form"/>
      <container id="uuid:c27cd277-9852-4fd8-94bb-7909e25fdd8c" description="Contains attributes that describe meanings of a lexical entry" name="Sense" mandatory="true" multiple="false" type="sense"/>
      </container>
      </container>
      </schema>
    -->
    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="json">
        <lexus:save-schema id="{parameters/viewId}">
            <xsl:apply-templates select="parameters/schema"/>
        </lexus:save-schema>
        <lexus:update-lexica-for-updated-schema id="{parameters/viewId}">
            <xsl:apply-templates select="parameters/schema"/>
        </lexus:update-lexica-for-updated-schema>
    </xsl:template>

    <xsl:template match="schema">
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="type = 'Lexicon'">
                    <xsl:text>lexicon</xsl:text>
                </xsl:when>
                <xsl:when test="type = 'LexicalEntry'">
                    <xsl:text>lexical-entry</xsl:text>
                </xsl:when>
                <xsl:when test="type = 'data category'">
                    <xsl:text>data</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <schema>
            <container id="{id}" description="{description}" name="{name}" type="{$type}"
                mandatory="{if (number(min) gt 0) then 'true' else 'false'}"
                multiple="{if (number(max) eq 1) then 'false' else 'true'}" note="{note}"
                admin-info="{adminInfo}">
                <xsl:apply-templates select="sortOrder"/>
                <xsl:apply-templates select="children/children"/>
            </container>
        </schema>
    </xsl:template>

    <xsl:template match="children">
        <xsl:variable name="id"
            select="if (id) then id else concat('uuid:',util:toString(util:randomUUID()))"/>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="type = 'Lexicon'">
                    <xsl:text>lexicon</xsl:text>
                </xsl:when>
                <xsl:when test="type = 'LexicalEntry'">
                    <xsl:text>lexical-entry</xsl:text>
                </xsl:when>
                <xsl:when test="type = 'data category'">
                    <xsl:text>data</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <container id="{$id}" description="{description}" name="{name}" type="{$type}" 
            mandatory="{if (number(min) gt 0) then 'true' else 'false'}"
            multiple="{if (number(max) eq 1) then 'false' else 'true'}" note="{note}"
            admin-info="{adminInfo}">
            <xsl:apply-templates select="sortOrder"/>
            <xsl:choose>
                <xsl:when test="children/children">
                    <xsl:apply-templates select="children/children"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="processDataCategoryAttributes"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="valuedomain ne 'null'">
                <valuedomain>
                    <xsl:apply-templates select="valuedomain/valuedomain"/>
                </valuedomain>
            </xsl:if>
        </container>
    </xsl:template>

    <xsl:template name="processDataCategoryAttributes">
        <xsl:if test="DCRReference ne 'null'">
            <xsl:attribute name="reference" select="DCRReference"/>
        </xsl:if>
        <xsl:if test="DCR ne 'null'">
            <xsl:attribute name="registry" select="DCR"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="sortOrder[not(id)]"/>
    <xsl:template match="sortOrder[data(id) eq 'null']"/>
    <xsl:template match="sortOrder[starts-with(id, 'uuid')]">
        <xsl:attribute name="sort-order" select="id"/>    
    </xsl:template>
    
    <xsl:template match="valuedomain/valuedomain" priority="1">
        <domainvalue>
            <xsl:if test="value/text() ne 'null'">
                <xsl:value-of select="value"/>
            </xsl:if>
        </domainvalue>
    </xsl:template>
</xsl:stylesheet>
