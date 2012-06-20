<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="json">
        <xsl:copy-of select="."/>


        <!-- 
            Delete the lexical entry.
        -->
        <lexus:delete-lexical-entry lexicon="{parameters/lexicon}" id="{parameters/lexicalEntry/id}"/>
        
    </xsl:template>

</xsl:stylesheet>
