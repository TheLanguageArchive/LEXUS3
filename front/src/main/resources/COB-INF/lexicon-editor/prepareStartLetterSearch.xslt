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
                <lexicon>1</lexicon>
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
    
    <xsl:template match="json">
        <lexus:search><xsl:apply-templates select="parameters/lexicon | parameters/refiner"/></lexus:search>
    </xsl:template>

</xsl:stylesheet>
