<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:jax-rx="http://jax-rx.sourceforge.net"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:import href="identity.xslt"/>

    <!-- Remove lexus:result elements, if the op was successfull -->
    <xsl:template match="lexus:result[@success eq 'true']">
        <xsl:apply-templates />
    </xsl:template>
    
</xsl:stylesheet>
