<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>


<!--
    <query xmlns:json="http://apache.org/cocoon/json/1.0"
        id="uuid:9c061431-140a-49ea-96e9-3b964fb91884">
        <description/>
        <name>testje 2</name>
        <expression>
            <lexicon id="uuid:eae8c847-4462-432e-bf95-56eae4831044"
            name="976b83a2-7bef-4099-9e5f-04f22bd7e98f">
                <datacategory schema-ref="uuid:6e1f2b5f-778e-4940-b054-dc8f1e0d2dec" name="Lexeme"
                value="test" condition="is" negation="false"/>
            </lexicon>
        </expression>
    </query>
    
        ==>
    
    /lexus[@id eq "uuid:eae8c847-4462-432e-bf95-56eae4831044"]/lexicon/
    lexical-entry[(.//data[@schema-ref eq "uuid:6e1f2b5f-778e-4940-b054-dc8f1e0d2dec" and value eq "test"])]) 

declare function lexus:createQuery($query as node()) as node()

-->
    
    
    <xsl:template match="lexus:search-with-query">
        <xsl:copy>
            <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="permissions"/>

                <xsl:apply-templates select="query"/> 
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>

    <xsl:template match="query">
        <xsl:text>let $startPage := </xsl:text><xsl:value-of select="../refiner/position"/>
        <xsl:text>
            
        </xsl:text>
        <xsl:text>let $pageSize := </xsl:text><xsl:value-of select="../refiner/pageSize"/>
        <xsl:text>
            
        </xsl:text>
        <xsl:text>let $from := ($startPage) * $pageSize</xsl:text>
        
        <xsl:text>
            
        </xsl:text>
        <xsl:text>let $to := ($startPage + 1) * $pageSize</xsl:text>
        
        <xsl:text>
            
        </xsl:text>
        
        <xsl:text>let $search-results := (</xsl:text>
        <xsl:for-each select="expression/lexicon">
            <xsl:text>element lexicon {</xsl:text>
            <xsl:text> attribute id {'</xsl:text><xsl:value-of select="./@id"/><xsl:text>'}, </xsl:text>
            <xsl:text> attribute name {'</xsl:text><xsl:value-of select="./@name"/><xsl:text>'}, </xsl:text>
            <xsl:apply-templates select="."/>
            <xsl:text> }</xsl:text>
        </xsl:for-each>
        <xsl:text> )</xsl:text>
        <xsl:text>
            
        </xsl:text>
        <xsl:text>return element search-results { </xsl:text>
        <xsl:text> attribute total { count($search-results//lexical-entry) }, </xsl:text>
        <xsl:apply-templates select="." mode="encoded"/>
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="../refiner" mode="encoded"/>
        <xsl:text>, for $l in $search-results return element lexicon { $l/@*, subsequence($l/lexical-entry, $from, $to) }</xsl:text>
        <xsl:text> }</xsl:text>
    </xsl:template>
    
    
    <!--
        /lexus[@id eq "uuid:eae8c847-4462-432e-bf95-56eae4831044"]/lexicon/lexical-entry[...]
        -->
    <xsl:template match="lexicon">
        <xsl:text>collection('</xsl:text><xsl:value-of select="$lexica-collection"/><xsl:text>')</xsl:text>
        <xsl:text>/lexus[@id eq "</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>"]/lexicon/lexical-entry[</xsl:text>
        <xsl:for-each select="datacategory">
            <xsl:text>(</xsl:text>
            <xsl:apply-templates select="." />
            <xsl:text>)</xsl:text>
            <xsl:if test="position()!=last()"><xsl:text> or </xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    
    <!--
        .//data[@schema-ref eq "uuid:6e1f2b5f-778e-4940-b054-dc8f1e0d2dec" and value eq "test"]
        -->
    <xsl:template match="datacategory">
        <xsl:text>.//data[@schema-ref eq "</xsl:text>
        <xsl:value-of select="@schema-ref"/>
        <xsl:text>" and </xsl:text>
        <xsl:apply-templates select="." mode="condition"/>
        <xsl:if test="datacategory">
            <xsl:text> and (</xsl:text>
            <xsl:apply-templates select="datacategory"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <!--
        Generate eq, not(eq), contains(), not(contains()) etc.
    -->
    <xsl:template match="datacategory" mode="condition">
        <xsl:variable name="uc" select="upper-case(@value)"/>
        
        <xsl:if test="@negation eq 'true'">not(</xsl:if>
        <xsl:choose>
            <xsl:when test="@condition eq 'is'">
                upper-case(value) eq '<xsl:value-of select="$uc"/>' 
            </xsl:when>
            <xsl:when test="@condition eq 'contains'">
                contains(upper-case(value), '<xsl:value-of select="$uc"/>') 
            </xsl:when>
            <xsl:when test="@condition eq 'begins with'">
                starts-with(upper-case(value), '<xsl:value-of select="$uc"/>') 
            </xsl:when>
            <xsl:when test="@condition eq 'ends with'">
                ends-with(upper-case(value), '<xsl:value-of select="$uc"/>') 
            </xsl:when>
        </xsl:choose>
        <xsl:if test="@negation eq 'true'">)</xsl:if>
    </xsl:template>
</xsl:stylesheet>
