<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    xmlns:fragments="http://org.apache.cocoon.transformation/fragments/1.0" version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="display:lexicon[@view eq 'list-view'][@id ne '']" priority="1">
        <display:lexicon>
            <xsl:apply-templates select="@*"/>
            <fragments:transform stylesheet-uri="cocoon:/getDisplayStylesheet.xslt/listView/{@id}"
                fragment-name="lexical-entry"
                fragment-namespace="http://www.mpi.nl/lexus/display/1.0">
                <xsl:apply-templates/>
            </fragments:transform>
        </display:lexicon>
    </xsl:template>
    
    
    <xsl:template match="display:lexicon[@view eq 'le-view'][@id ne '']" priority="1">
        <display:lexicon>
            <xsl:apply-templates select="@*"/>
            <fragments:transform stylesheet-uri="cocoon:/getDisplayStylesheet.xslt/leView/{@id}"
                fragment-name="lexical-entry"
                fragment-namespace="http://www.mpi.nl/lexus/display/1.0">
                <xsl:apply-templates/>
            </fragments:transform>
        </display:lexicon>
    </xsl:template>


    <xsl:template match="display:lexicon[@view ne ''][@id ne '']">
        <display:lexicon>
            <xsl:apply-templates select="@*"/>
            <fragments:transform stylesheet-uri="cocoon:/getDisplayStylesheet.xslt/{@view}/{@id}"
                fragment-name="lexical-entry"
                fragment-namespace="http://www.mpi.nl/lexus/display/1.0">
                <xsl:apply-templates/>
            </fragments:transform>
        </display:lexicon>
    </xsl:template>
    
    <xsl:template match="display:lexicon//lexical-entry">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <display:lexical-entry>
                <xsl:copy-of select="*"/>
            </display:lexical-entry>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
