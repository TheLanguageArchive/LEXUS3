<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">
    
    <xsl:import href="identity.xslt"/>
    
    <xsl:param name="endpoint"/>

    <xsl:template match="lexus:query">
        <rest:request target="{$endpoint}" method="POST">
            <rest:header name="Content-Type" value="application/query+xml; charset=UTF-8"/>
            <rest:body>
                <query>
                    <text><xsl:value-of select="lexus:text"/></text>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
