<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    exclude-result-prefixes="xd"
    version="1.0">
    
    <xsl:import href="../../util/identity.xslt"/>
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 30, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="lexus">
        <cinclude:include src="cocoon:/reOrderLexicon.xml?id={@id}"></cinclude:include>
    </xsl:template>
</xsl:stylesheet>