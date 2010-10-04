<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="#all"
      version="2.0">

    <!-- 
        Combine components that were added because they are missing parents of
        data categories in the source .txt file.
        We added them in, one for each dc. However, it happens that
        every dc in a parentcomponent gets it's own parent!
        This stylesheet rectifies this and combines components with
        the same name and marker that are siblings.
        -->

    <xsl:template match="component[@name = following::*[1]/@name]"/>        
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
