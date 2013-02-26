<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    version="2.0">
    
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    
    <xsl:template match="lexus:update-lexicon-for-updated-schema">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <lexus:query>
                <lexus:text>
                    <xsl:call-template name="declare-namespace"/>
                    element nr-of-lexical-entries {
                        count(collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = '<xsl:value-of select="@id"/>']/lexicon/lexical-entry)
                    }
                </lexus:text>
                <properties>
                    <property name="pretty-print" value="no"/>
                </properties>
            </lexus:query>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
