<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0" xmlns:lexus="http://www.mpi.nl/lexus"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="h:request">
        <lexus:get-lexical-entry>
            <lexicon>
                <xsl:value-of select="h:requestParameters/h:parameter[@name eq 'lexicon']/h:value"/>
            </lexicon>
            <id>
                <xsl:value-of select="h:requestParameters/h:parameter[@name eq 'id']/h:value"/>
            </id>
        </lexus:get-lexical-entry>
    </xsl:template>

</xsl:stylesheet>
