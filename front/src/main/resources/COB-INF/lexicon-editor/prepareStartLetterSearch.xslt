<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        <data>
            <json xmlns:json="http://apache.org/cocoon/json/1.0">
                <id>AF836C97-5C1A-3DA6-00A2-3E4F31CCE5F4</id>
                <requester>LexiconBrowser793</requester>
                <parameters>
                // - Either a query or a lexicon element is present //
                <query>? 
                <lexicon>1</lexicon>?
                <refiner>
                <startLetter/>
                <pageSize>25</pageSize>
                <startPage>0</startPage>
                </refiner>
                </parameters>
            </json>
            <user>...</user>
        </data>
        
        Generate the following XML:
        
        <data>
        <lexus:search>
            <lexicon>1</lexicon>
            <refiner>
                <startLetter/>
                <pageSize>25</pageSize>
                <startPage>0</startPage>
            </refiner>
            </lexus:search>
        <user>...</user>
        </data>
        -->
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../workspace/queries/json-query-to-lexus-query-format.xslt"/>

    <xsl:template match="json">
        <xsl:variable name="startLetter" select="if (parameters/refiner/startLetter ne '-') then parameters/refiner/startLetter else ''"/>
        <lexus:search>
            <xsl:choose>
                <xsl:when test="parameters/query">
                    <xsl:apply-templates select="parameters/query" mode="json-query">
                        <xsl:with-param name="startLetter" select="$startLetter"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Create an adhoc query that uses startLetter. -->
                    <query xmlns:json="http://apache.org/cocoon/json/1.0" id="adhoc">
                        <expression>
                            <lexicon id="{parameters/lexicon}">
                                    <xsl:if test="$startLetter ne ''"><datacategory schema-ref="" ref="lexus:start-letter-search"
                                        name="" value="{$startLetter}"
                                        condition="begins with" negation="false"/></xsl:if>
                            </lexicon>
                        </expression>
                    </query>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="parameters/refiner"/>
        </lexus:search>
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
