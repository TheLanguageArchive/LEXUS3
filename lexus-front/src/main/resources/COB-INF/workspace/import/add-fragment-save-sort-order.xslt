<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:dcr="http://www.isocat.org/ns/dcr"
    xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/" xmlns:ex="http://apache.org/cocoon/exception/1.0"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="#all" version="2.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 8, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> andmor</xd:p>
            <xd:p/>
            <xd:p>Create fragment to save the lexicon sort order in the user workspace.</xd:p>
        </xd:desc>
    </xd:doc>



    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="/data/sortorder">
        <lexus:save-sortorder>
        	<sortorder>
        			<xsl:copy-of select="@*"/>
		        	<xsl:apply-templates/> 
		    </sortorder>
        </lexus:save-sortorder>
    </xsl:template>

</xsl:stylesheet>