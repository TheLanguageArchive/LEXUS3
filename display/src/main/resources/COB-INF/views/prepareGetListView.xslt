<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:param name="lexicon-id" select="''"/>
    
    <xsl:template match="/">
            <lexus:get-listview lexicon="{$lexicon-id}"/>
    </xsl:template>

</xsl:stylesheet>
