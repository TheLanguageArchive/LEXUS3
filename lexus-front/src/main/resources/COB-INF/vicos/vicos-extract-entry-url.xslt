<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"  xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="#all" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 31, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> andmor</xd:p>
            <xd:p>Extract url from lexical entry for vicos.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="../util/identity.xslt"/>    
    
    <xsl:template match="lexus:get-entry-from-data">
		<result>
			<url><xsl:value-of select="concat(../contextURL/text(), 'EntryViewer.html?id=', lexus:result/lexical-entry/@id)"/></url>
		</result>
    </xsl:template>
    
    <xsl:template match="contextURL"/>
    
</xsl:stylesheet>