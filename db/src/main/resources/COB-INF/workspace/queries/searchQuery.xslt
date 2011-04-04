<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    <xsl:include href="buildSearchQuery.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>


    <!--
        Create db query and send it off, return the results.
    -->
    
    
    <xsl:template match="lexus:search">
        <xsl:copy>
            <lexus:query>
                <lexus:text>
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>
                    
                    
                    <!-- Insert lexus:search() function here. --> 
                    <xsl:apply-templates select="query" mode="build-query">
                        <xsl:with-param name="lexica" select="../lexus:search-lexica/lexus"/>
                    </xsl:apply-templates>
            
                    let $search := <xsl:apply-templates select="." mode="encoded"/>
                    let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                    let $startLetter := data($search/refiner/startLetter)
                    let $searchTerm := data($search/refiner/searchTerm)
                    let $pageSize := number($search/refiner/pageSize)
                    let $startPage := number($search//refiner/startPage)
                   
                    let $from := ($startPage) * $pageSize
                    let $to := ($startPage + 1) * $pageSize
                    
                    
                    (: Returns a list of lexicon elements, containing ($firstDC, (lexical-entry)*) :)
                    let $search-results := lexus:search($startLetter, $searchTerm) 
        
                    <xsl:text>return element search-results { </xsl:text>
                    <xsl:text> attribute total { count($search-results//lexical-entry) }, </xsl:text>
                    <xsl:apply-templates select="query" mode="encoded"/>
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="refiner" mode="encoded"/>
                    <xsl:text>, for $l in $search-results 
                        return element lexicon { $l/@*, subsequence($l/lexical-entries/lexical-entry, $from, $to) }</xsl:text>
                    <xsl:text>, element boe {$search-results} }</xsl:text>
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>

    <xsl:template match="query">
    </xsl:template>

</xsl:stylesheet>
