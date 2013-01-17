<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rr="http://nl.mpi.lexus/resource-resolver" exclude-result-prefixes="#all" version="2.0">

    <xsl:preserve-space elements="*"/>

    <xsl:template match="/page">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="text">
        <fo:inline>
            <xsl:value-of select="."/>
        </fo:inline>
    </xsl:template>


    <!--
        An inline decorator element. 
        -->
    <xsl:template match="div[@type eq 'dsl_show'][@block eq 'false']" priority="1">
        <fo:inline>
            <xsl:apply-templates select="@* | node()"/>
        </fo:inline>
    </xsl:template>


    <!--
        A block decorator element. 
    -->
    <xsl:template match="div[@type eq 'dsl_show'][@block eq 'true']" priority="1">
        <fo:block>
            <xsl:apply-templates select="@* | node()"/>
        </fo:block>
    </xsl:template>


    <!--
        A block div element. 
    -->
    <xsl:template match="div[@block eq 'true']">
        <fo:block>
            <xsl:apply-templates select="@* | node()"/>
        </fo:block>
    </xsl:template>


    <!--
        An inline div element. 
    -->
    <xsl:template match="div[@block eq 'false']">
        <fo:inline>
            <xsl:apply-templates select="@* | node()"/>
        </fo:inline>
    </xsl:template>
    
    
    <!--
        A line feed element.
        The 'inline' element is needed otherwise the FOP processor ignores line feeds
        placed right after another line feed.
    -->
    <xsl:template match="br">
        <fo:block/>
        <xsl:if test="not(./following-sibling::*[1][self::hr] or ./following-sibling::*[1][self::div[@block eq 'true']])">
	        <fo:inline >
	        		<xsl:text>&#xA;</xsl:text>
	        </fo:inline>
        </xsl:if>
    </xsl:template>
    
    
	<!--
        A horizontal line element.
    -->
    <xsl:template match="hr">
    	<fo:block text-align-last="justify">
	        <fo:leader leader-pattern="rule" rule-style="solid" color="black">
		        <xsl:choose>
		        	<xsl:when test="exists(@size)">
						<xsl:attribute name="rule-thickness"><xsl:value-of select="concat(@size, 'px')"/></xsl:attribute>
		        	</xsl:when>
		        	<xsl:otherwise>
						<xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
		        	</xsl:otherwise>
		        </xsl:choose>
	        </fo:leader>
        </fo:block>
    </xsl:template>


    <xsl:template match="@fontWeight[.='bold']">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:template>

    <xsl:template match="@fontStyle[.='italic']">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:template>

    <xsl:template match="@textDecoration[.='underline']">
        <xsl:attribute name="text-decoration">underline</xsl:attribute>
    </xsl:template>


    <xsl:template match="@fontSize">
        <xsl:attribute name="font-size">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@fontFamily">
        <xsl:attribute name="font-family">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="@color[starts-with(., '0x')]">
        <xsl:attribute name="color">
            <xsl:value-of select="concat('#', substring-after(., '0x'))"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@color[starts-with(., '#')]">
        <xsl:attribute name="color">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>


<!-- AAM: not checked from this point on. -->
    <xsl:template match="@background-color">
        <xsl:attribute name="background-color">
            <xsl:value-of select="concat('#', substring-after(., '0x'))"/>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="@border">
        <xsl:attribute name="border">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="@block"/>


    <xsl:template match="table">
        <fo:table border-width="0.4mm" border-style="solid">
            <xsl:apply-templates/>
        </fo:table>
    </xsl:template>
    
    <xsl:template match="thead">
        <fo:table-header>
            <xsl:apply-templates/>
        </fo:table-header>
    </xsl:template>
    
    <xsl:template match="tbody">
        <fo:table-body>
            <xsl:apply-templates/>
        </fo:table-body>
    </xsl:template>
    
    <xsl:template match="tr">
        <fo:table-row>
            <xsl:apply-templates/>
        </fo:table-row>
    </xsl:template>
    
    <xsl:template match="th">
        <fo:table-cell border-width="0.1mm" border-style="solid">
            <fo:block>
                <xsl:apply-templates/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>
    
    <xsl:template match="td">
        <fo:table-cell border-width="0.1mm" border-style="solid">
            <fo:block>
                <xsl:apply-templates/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>


    <xsl:template match="img">
        <fo:external-graphic>
            <xsl:copy-of select="@src | *"/>
        </fo:external-graphic>
    </xsl:template>

    <xsl:template match="resource" priority="1">
        <rr:resource-id-to-url>
            <xsl:copy-of select="@*"/>
        </rr:resource-id-to-url>
    </xsl:template>


    <xsl:template match="@*"/>


    <xsl:template match="text()" priority="1">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>
