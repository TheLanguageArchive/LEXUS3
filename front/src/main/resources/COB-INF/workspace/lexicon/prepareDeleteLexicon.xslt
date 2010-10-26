<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="data">
        <xsl:copy>
            <lexus:delete-lexicon>
                <lexicon id="{json/parameters/id}"/>
            </lexus:delete-lexicon>
            <lexicon id="{json/parameters/id}"/>
            <xsl:copy-of select="user"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
