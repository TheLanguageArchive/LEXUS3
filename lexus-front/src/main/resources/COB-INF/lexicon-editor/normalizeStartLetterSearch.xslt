<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
	
	<xsl:include href="../util/identity.xslt"/>  
    
    
    <xsl:template match="expression">
        <xsl:copy>
            <xsl:for-each-group select="lexicon" group-by="@id">
                <xsl:copy>
                    <xsl:apply-templates select="/data//query/expression/lexicon/@*"/>
                    <xsl:apply-templates select="/data//query/expression/lexicon/*"/>
                </xsl:copy>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>