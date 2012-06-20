<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:lexus="http://www.mpi.nl/lexus" exclude-result-prefixes="#all"
      version="2.0">

    <!-- 
        Remove data-categories that were added because they are missing parents of
        data categories in the source .txt file.
        We added them in and then created a container *and* a dc for them,
        the container has to stay (they are parents), but the added
        dc must go.
        -->

    <xsl:template match="lexus:data[@added='true']"/>        
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
