<?xml version="1.0" encoding="UTF-8"?>
<!--
    Create a zip file containing the typ-generated-schema, the lexicon and a RelaxNG schema for the lexicon.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="toolbox-import">
        <zip:archive>
            <zip:entry name="typ-generated-schema.xml" serializer="xml">
                <xsl:copy-of select="lexus:meta"/>
            </zip:entry>
            <zip:entry name="lexicon.xml" serializer="xml">
                <xsl:copy-of select="processing-instruction()"/>
                <xsl:copy-of select="lexus:lexicon"/>
            </zip:entry>
            <zip:entry name="lexicon.rng" serializer="xml">
                <xsl:copy-of select="rng:grammar"/>
            </zip:entry>
        </zip:archive>
    </xsl:template>

</xsl:stylesheet>
