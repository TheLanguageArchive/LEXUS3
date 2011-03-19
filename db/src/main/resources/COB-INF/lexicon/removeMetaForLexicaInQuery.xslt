<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        Remove lexus:search-lexica element.
    -->

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="lexus:search-lexica"/>
</xsl:stylesheet>
