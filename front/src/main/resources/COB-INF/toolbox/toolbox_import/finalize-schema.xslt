<?xml version="1.0" encoding="UTF-8"?>
<!--
   Remove markers from groups in the schema. Also rename container elements to datacategory elements.
   Add ISOCat DCR references based on the MDF markers (mdf:marker),
   or add Lexus' MDF DCR references to MDF markers.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/"
    xmlns:dcr="http://www.isocat.org/ns/dcr" xmlns:dcif="http://www.isocat.org/ns/dcif"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:variable name="isocat-to-mdf-dcs" select="doc('DCS-374.dcif')"/>
    
    <!--
        //dcif:dataCategory[exists(.//dcif:dataElementNameSection[dcif:source="MDF"][dcif:dataElementName="bw"])]/@pid
        -->
    <xsl:key name="dcs" match="dcif:dataElementNameSection[dcif:source='MDF'][dcif:dataElementName]" use="dcif:dataElementName"/>

    <!-- Transform mdf:marker attrs to ISOCat references: dcr:datcat="http://www.isocat.org/datcat/DC-3688",
         or Lexus MDF references: dcr:datcat="http://lexus.mpi.nl/datcat/mdf/xx". -->
    <xsl:template match="lexus:schema//@mdf:marker">
        <xsl:attribute name="dcr:datcat">
            <xsl:choose>
                <!-- First try to match the mdf:marker to ISOCat -->
                <xsl:when test="key('dcs', data(.), $isocat-to-mdf-dcs)">
                    <xsl:value-of select="key('dcs', data(.), $isocat-to-mdf-dcs)/ancestor::dcif:dataCategory/@pid"/>
                </xsl:when>
                <!-- If that doesn't work, create a reference to our own lexus MDF DCR. -->
                <xsl:otherwise>
                    <xsl:text>lexus-user:</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:copy/>
    </xsl:template>
    
    <!-- Remove mdf:marker attrs from lexicon. -->
    <xsl:template match="lexus:lexicon//@mdf:marker"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="lexus:schema//lexus:container[@type eq 'component'][@mdf:marker]">
        <xsl:copy>
            <xsl:apply-templates select="@*[local-name() ne 'marker']"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="lexus:schema//lexus:container[@type eq 'data']">
        <lexus:datacategory>
            <xsl:apply-templates select="@* | node()"/>
        </lexus:datacategory>
    </xsl:template>
</xsl:stylesheet>
