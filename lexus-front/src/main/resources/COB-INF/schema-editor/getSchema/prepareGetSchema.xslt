<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is for instance:
        <data>
            <json xmlns:json="http://apache.org/cocoon/json/1.0">
                <id>14097311-090E-4B0D-43D5-B8647A5CF746</id>
                <requester>SchemaEditor4756</requester>
                <parameters>
                    <id>uuid:74827f4a-edd1-4522-a9b0-d7d8e5753223</id>
                </parameters>
            </json>
            <user id="uuid:2c9090c109fdedd00109fe3a58910012">
                <name>jacrin</name>
                <account>jacrin</account>
                <accesslevel>10</accesslevel>
            </user>
        </data>
        
    -->
    <xsl:include href="../../util/identity.xslt"/>
    
    <xsl:template match="json">
        <!-- HHV: json element is needed elsewhere, f.i. when creating a new lexicalentry -->
        <xsl:copy-of select="."/>
        <lexus:get-schema><xsl:apply-templates select="parameters/*"/></lexus:get-schema>
    </xsl:template>

</xsl:stylesheet>
