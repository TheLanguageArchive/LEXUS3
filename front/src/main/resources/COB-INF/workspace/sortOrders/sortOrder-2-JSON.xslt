<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    
    <!--
        
    This stylesheet creates:
    
    {
    "result": {
    "sortOrder": {
    "id": 1, "name": "Yeli Dnye sort order", "description": "Demo sort order", "data":[ {
    "startLetter": "a", "characters": "Aa['a]"
    }, {
    "startLetter": "b", "characters": "Bb['b]"
    }]
    }
    }
    }
    
-->

    <xsl:template match="/">
        <object>
            <object key="result">
                <object key="status">
                    <string key="success">
                        <xsl:choose>
                            <xsl:when test="/data/lexus:get-sortorders/lexus:result[@success='true']">true</xsl:when>
                            <xsl:otherwise>false</xsl:otherwise>
                        </xsl:choose>
                    </string>
                </object>
                <xsl:apply-templates select="/data/lexus:get-sortorders/lexus:result/*"/>
            </object>
        </object>
    </xsl:template>
    
    <!-- Skip the sortorders element, we're only returning the one requested sortorder (loadSortOrder.json). -->
    <xsl:template match="sortorders">
        <xsl:apply-templates select="*[@id eq /data/json/parameters/id]"/>
    </xsl:template>
    
    <xsl:template match="sortorder">
        <object key="sortOrder">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="name">
                <xsl:value-of select="name"/>
            </string>
            <string key="description">
                <xsl:value-of select="description"/>
            </string>
            <xsl:apply-templates select="mappings"/>
        </object>
    </xsl:template>

    <xsl:template match="mappings">
        <array key="data">
            <xsl:apply-templates/>
        </array>
    </xsl:template>

    <xsl:template match="mapping">
        <object>
            <xsl:apply-templates/>
        </object>
    </xsl:template>

    <xsl:template match="to">
        <string key="startLetter">
            <xsl:apply-templates/>
        </string>
    </xsl:template>

    <xsl:template match="from">
        <string key="characters">
            <xsl:apply-templates/>
        </string>
    </xsl:template>
</xsl:stylesheet>
