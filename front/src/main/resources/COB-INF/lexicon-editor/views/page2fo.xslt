<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="/page">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4">
                    <!-- Page template goes here -->
                </fo:simple-page-master>
            </fo:layout-master-set>
            
            <fo:page-sequence master-reference="A4">
                <!-- Page content goes here -->
            </fo:page-sequence>
            
        </fo:root>
    </xsl:template>

    <xsl:template match="text">
        <div xmlns="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="style">display: inline; <xsl:apply-templates select="@*"
                /></xsl:attribute>
            <xsl:apply-templates select="."/>
        </div>
    </xsl:template>

    <xsl:template match="@bold[.='true']">
        <xsl:text>font-weight: bold;</xsl:text>
    </xsl:template>

    <xsl:template match="@italic[.='true']">
        <xsl:text>font-style: italic;</xsl:text>
    </xsl:template>

    <xsl:template match="@font-size">
        <xsl:text>font-size: </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="@background-color">
        <xsl:text>background-color: </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="@border">
        <xsl:text>border: </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    
    <xsl:template match="@width">
        <xsl:text>width: </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    
    
    <xsl:template match="@font-family">
        <xsl:text>font-family: </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="table">
        <table xmlns="http://www.w3.org/1999/xhtml">
            <xsl:if test="@*">
                <xsl:attribute name="style">
                    <xsl:apply-templates select="@*"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <xsl:template match="row">
        <tr xmlns="http://www.w3.org/1999/xhtml">
            <xsl:if test="@*">
                <xsl:attribute name="style">
                    <xsl:apply-templates select="@*"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <xsl:template match="col">
        <td xmlns="http://www.w3.org/1999/xhtml">
            <xsl:if test="@*">
                <xsl:attribute name="style">
                    <xsl:apply-templates select="@*"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template match="@*"/>


    <xsl:template match="text()" priority="1">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:if test="@*">
                <xsl:attribute name="style">
                    <xsl:apply-templates select="@*"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
