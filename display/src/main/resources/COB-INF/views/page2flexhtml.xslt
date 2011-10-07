<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:rr="http://nl.mpi.lexus/resource-resolver" 
    xmlns:display="http://www.mpi.nl/lexus/display/1.0" exclude-result-prefixes="#all" version="2.0">

    <xsl:include href="../util/encodeXML.xslt"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Lexical entry</title>
            </head>
            <body>
                <xsl:apply-templates select="@* | node()"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="display:page">
        <xsl:apply-templates select="display:structure/*"/>
    </xsl:template>

    <xsl:template match="text">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="table"> &lt;table&gt; <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/> &lt;/table&gt; </xsl:template>
    <xsl:template match="thead"> &lt;head&gt; <xsl:apply-templates/> &lt;/head&gt; </xsl:template>
    <xsl:template match="tbody"> &lt;body&gt; <xsl:apply-templates/> &lt;/body&gt; </xsl:template>
    <xsl:template match="tr"> &lt;tr&gt; <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/> &lt;/tr&gt; </xsl:template>
    <xsl:template match="td"> &lt;td&gt; <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/> &lt;/td&gt; </xsl:template>
    <xsl:template match="th"> &lt;th&gt; <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/> &lt;/th&gt; </xsl:template>

    <xsl:template match="@class | @colspan">        
        <xsl:apply-templates select="." mode="encoded"/>
    </xsl:template>

	<!--AAM: we have 8 possible cases with italic, bold and underlined local style parameters-->
    <xsl:template match="div">
    	<xsl:if test = "./@localStyle eq 'true' or not(./@localStyle)">
    		<xsl:if test="./@fontStyle eq 'italic' and not(./@fontWeight eq 'bold') and not(./@textDecoration eq 'underline')">
    	     		&lt;I&gt;&lt;font <xsl:apply-templates select="@*"/>&gt;
        		<xsl:apply-templates/>
        		&lt;/font&gt;&lt;/I&gt;
    		</xsl:if>
    		<xsl:if test="./@fontWeight eq 'bold' and not(./@fontStyle eq 'italic') and not(./@textDecoration eq 'underline')">
    	     		&lt;b&gt;&lt;font <xsl:apply-templates select="@*"/>&gt;
        		<xsl:apply-templates/>
        		&lt;/font&gt;&lt;/b&gt;
    		</xsl:if>
    		<xsl:if test="./@textDecoration eq 'underline' and not(./@fontStyle eq 'italic') and not(./@fontWeight eq 'bold')">
    	     		&lt;u&gt;&lt;font <xsl:apply-templates select="@*"/>&gt;
        		<xsl:apply-templates/>
        		&lt;/font&gt;&lt;/u&gt;
    		</xsl:if>
    		<xsl:if test="./@fontStyle eq 'italic' and ./@fontWeight eq 'bold' and not(./@textDecoration eq 'underline')">
    	     		&lt;b&gt;&lt;I&gt;&lt;font <xsl:apply-templates select="@*"/>&gt;
        		<xsl:apply-templates/>
        		&lt;/font&gt;&lt;/I&gt;&lt;/b&gt;
    		</xsl:if>
    		<xsl:if test="./@fontStyle eq 'italic' and ./@textDecoration eq 'underline' and not(./@fontWeight eq 'bold')">
    	     		&lt;u&gt;&lt;I&gt;&lt;font <xsl:apply-templates select="@*"/>&gt;
        		<xsl:apply-templates/>
        		&lt;/font&gt;&lt;/I&gt;&lt;/u&gt;
    		</xsl:if>
    		<xsl:if test="./@fontWeight eq 'bold' and ./@textDecoration eq 'underline' and not(./@fontStyle eq 'italic')">
    	     		&lt;b&gt;&lt;u&gt;&lt;font <xsl:apply-templates select="@*"/>&gt;
        		<xsl:apply-templates/>
        		&lt;/font&gt;&lt;/u&gt;&lt;/b&gt;
    		</xsl:if>
    		<xsl:if test="./@fontWeight eq 'bold' and ./@fontStyle eq 'italic' and ./@textDecoration eq 'underline'">
    	     		&lt;b&gt;&lt;I&gt;&lt;u&gt;&lt;font <xsl:apply-templates select="@*"/>&gt;
        		<xsl:apply-templates/>
        		&lt;/font&gt;&lt;/u&gt;&lt;/I&gt;&lt;/b&gt;
    		</xsl:if>
    		<xsl:if test="not(./@fontStyle eq 'italic') and not(./@fontWeight eq 'bold') and not(./@textDecoration eq 'underline')">
     			&lt;font <xsl:apply-templates select="@*"/>&gt;
        		<xsl:apply-templates/> &lt;/font&gt; 
        	</xsl:if>
        </xsl:if>
        <xsl:if test = "./@localStyle eq 'false'">
        &lt;span <xsl:apply-templates select="@*"/>&gt;
        	<xsl:apply-templates/> &lt;/span&gt; 
        </xsl:if>          
    </xsl:template>

    <xsl:template match="@dsl_class[not(../@localStyle) or ../@localStyle eq 'false']">
        <xsl:text>class=&apos;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&apos; </xsl:text>
    </xsl:template>
    <xsl:template match="@dsl_class[./@dsl_class eq '']">
    </xsl:template>

    <xsl:template match="@type | @optional | @name | @block" priority="2"/>
        
    
    <xsl:template match="@color[not(../@localStyle) or ../@localStyle eq 'true']">
        <!--<xsl:attribute name="color">
            <xsl:value-of select="."/>
        </xsl:attribute>-->

        <xsl:text>color=&apos;#</xsl:text>
        <xsl:value-of select="substring-after(., '0x')"/>
        <xsl:text>&apos; </xsl:text>
    </xsl:template>

    <xsl:template match="@fontFamily[not(../@localStyle) or ../@localStyle eq 'true']">
        <!--<xsl:attribute name="font-family">
            <xsl:value-of select="."/>
        </xsl:attribute>-->
        <xsl:text>face=&apos;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&apos; </xsl:text>
    </xsl:template>

    <xsl:template match="@fontSize[not(../@localStyle) or ../@localStyle eq 'true']">
        <!--<xsl:attribute name="font-size">
            <xsl:value-of select="."/>
        </xsl:attribute>-->
        <xsl:text>size=&apos;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&apos; </xsl:text>
    </xsl:template>  
    
    <xsl:template match="@color[../@localStyle eq 'false']">
    </xsl:template>

    <xsl:template match="@fontFamily[../@localStyle eq 'false']">
    </xsl:template>

    <xsl:template match="@fontSize[../@localStyle eq 'false']">
    </xsl:template>

    <xsl:template match="text()" priority="1">
        <xsl:copy/>
    </xsl:template>


    <xsl:template match="img"><xsl:text> &lt;img </xsl:text><xsl:apply-templates select="@*"/><xsl:text>&gt;</xsl:text>
        <xsl:apply-templates/><xsl:text> &lt;/img&gt; </xsl:text></xsl:template>
    
    
    <xsl:template match="rr:*" priority="1">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:apply-templates select="." mode="encoded"/>
    </xsl:template>


</xsl:stylesheet>
