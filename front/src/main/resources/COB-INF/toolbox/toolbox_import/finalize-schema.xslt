<?xml version="1.0" encoding="UTF-8"?>
<!--
   Remove markers from groups in the schema. Also rename container elements to datacategory elements.
   Transform mdf:marker attrs to dcr:datcat="http://lexus.mpi.nl/datcat/mdf/xx" attrs.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/"
    xmlns:dcr="http://www.isocat.org/ns/dcr" exclude-result-prefixes="#all" version="2.0">


    <!-- Transform mdf:marker attrs to dcr:datcat="http://lexus.mpi.nl/datcat/mdf/xx" attrs. -->
    <xsl:template match="lexus:schema//@mdf:marker">
        <xsl:attribute name="dcr:datcat">
            <xsl:text>http://lexus.mpi.nl/datcat/mdf/</xsl:text>
            <xsl:value-of select="."/>
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

    <xsl:template match="lexus:schema//lexus:container[@type eq 'container'][@mdf:marker]">
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
