<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:import href="identity.xslt"/>
    
    <xsl:param name="endpoint"/>

    <xsl:template match="lexus:query">
        <rest:request target="{$endpoint}" method="POST">
            <rest:header name="Content-Type" value="application/query+xml; charset=UTF-8"/>
            <rest:body>
                <query xmlns="http://basex.org/rest">
                    <text><xsl:value-of select="lexus:text"/></text>
                 	<parameter name="wrap-prefix" value="basexrest"/>
                 	<parameter name="wrap-uri" value="http://basex.org/rest"/>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
