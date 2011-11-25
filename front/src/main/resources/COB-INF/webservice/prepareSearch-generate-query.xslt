<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
    xmlns:impl="http://www.mpi.nl/lexus/webservice/"
    xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> March 3, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Transform query to the format the db module expects.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="../util/identity.xslt"/>


    <!--
        For instance:
        
        Transform this:
        
        <query>
        <id/>
        <name/>
        <lexicon>
        <id>uuid:2c9090a211eaa69e01122dc119965c82</id>
        <name>400 Qom Espa�ol Lexicon</name>
        <children>
        <parameter>
        <id/>
        <name>Definition (E)</name>
        <condition>contains</condition>
        <negation>false</negation>
        <value>e</value>
        <children/>
        </parameter>
        </children>
        </lexicon>
        </query>
        -->
    <xsl:template match="lexus:search/query">
        <xsl:copy>
            <xsl:attribute name="id" select="id"/>
            <xsl:copy-of select="name|description"/>
            <expression>
                <xsl:apply-templates select="lexicon"/>
            </expression>
            <xsl:apply-templates select="refiner"/>
        </xsl:copy>
    </xsl:template>


    <!--
        For instance:
        
        Transform this:
        
        
            <lexicon>
                <id>uuid:2c9090a211eaa69e01122dc119965c82</id>
                <name>400 Qom Espa�ol Lexicon</name>
                <children>
                    <parameter>
                        <id/>
                        <name>Definition (E)</name>
                        <condition>contains</condition>
                        <negation>false</negation>
                        <value>e</value>
                        <children/>
                    </parameter>
                </children>
            </lexicon>
        
        to:
        
        <lexicon id="uuid:eae8c847-4462-432e-bf95-56eae4831044"
            name="976b83a2-7bef-4099-9e5f-04f22bd7e98f">
            <datacategory schema-ref="uuid:6e1f2b5f-778e-4940-b054-dc8f1e0d2dec" name="Lexeme"
                value="test" condition="is" negation="false"/>
    -->
    <xsl:template match="lexicon">
        <lexicon id="{id}" name="{name}">
            <xsl:apply-templates select="children/parameter"/>
        </lexicon>
    </xsl:template>
    
    <xsl:template match="parameter">
        <datacategory schema-ref="{id}" name="{name}" value="{value}" condition="{condition}" negation="{negation}">
            <xsl:apply-templates select="children/parameter"/>
        </datacategory>
    </xsl:template>
    
</xsl:stylesheet>
