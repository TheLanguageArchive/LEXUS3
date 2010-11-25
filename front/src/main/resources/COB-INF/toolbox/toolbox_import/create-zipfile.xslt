<?xml version="1.0" encoding="UTF-8"?>
<!--
    Create a zip file containing the typ-generated-schema and the lexicon.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mpi="http://www.mpi.nl/lexus"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="toolbox-import">
        <zip:archive>
            <zip:entry name="typ-generated-schema.xml" serializer="xml">
                <xsl:copy-of select="lexus:meta"/>
            </zip:entry>
            <zip:entry name="lexicon.xml" serializer="xml">
                <xsl:copy-of select="lexus:lexicon"/>
            </zip:entry>
        </zip:archive>
    </xsl:template>

</xsl:stylesheet>
