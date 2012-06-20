<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <!-- 

    original app's JSON to mimic (but leave out stuff that's unnecessary, like "fill"):
    
    {
    "id": "Wed Feb 17 18:41:54 CET 2010",
    "result": {"sortOrders":         [
    {
    "id": "MmM5MDkwYTIyMTBiYWJmNDAxMjE1OTFjY2IwMzc3NjU=",
    "description": "headword order",
    "fill": "a(aA[-a][-A][^a][^A][\\(d\\)a][^\\(d\\)a][^\\(rt\\)a][^\\(rt/w\\)a][^\\(w\\)a][*a]àÀáÁâÂãÃäÄ)b(bB[-b][-B][^b][^B])d(dD[-d][-D][^d][^D])i(iI[-i][-I][^i][^I][^\\(j\\)i][^\\(rt\\)i][^\\(w\\)i]ìÌíÍîÎïÏ)j(jJ[-j][-J][^j][^J])k(kK[-k][-K][^k][^K])l(lL[-l][-L][^l][^L])[ld]([ld][LD][-ld][-Ld][^ld][^Ld])m(mM[-m][-M][^m][^M])n(nN[-n][-N][^n][^N])[ng]([ng][Ng][-ng][-Ng][^ng][^Ng])r(rR[-r][-R][^r][^R])[rr]([rr][Rr][-Rr][-rr][^Rr][^rr])[rt]([rt][Rt][-rt][-Rt][^Rt][^rt])u(uU[-u][-U][^u][^U][\\(w\\)u]ùÙúÚûÛüÜ)v(vV[^v][^V])w(wW[-w][-W][^w][^W])y(yY[-y][-Y][^y][^Y]??)",
    "name": "Iwadija headword",
    "data":                 [
    {
    "startLetter": "a",
    "characters": "aA[-a][-A][^a][^A][\\(d\\)a][^\\(d\\)a][^\\(rt\\)a][^\\(rt/w\\)a][^\\(w\\)a][*a]àÀáÁâÂãÃäÄ"
    },
    {
    "startLetter": "b",
    "characters": "bB[-b][-B][^b][^B]"
    }
    ]
    },
    
    
    This stylesheet creates:
    
    {
    "result": {
    "sortOrders": {
    "id": 1, "name": "Yeli Dnye sort order", "description": "Demo sort order", "data":[ {
    "startLetter": "a", "characters": "Aa['a]"
    }, {
    "startLetter": "b", "characters": "Bb['b]"
    }]
    }
    }
    }
    
    From:
    
    <data><lexus:get-sortorders xmlns:lexus="http://www.mpi.nl/lexus">
    <lexus:result success="true">
    <sortorders ...
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
    
    <xsl:template match="sortorders">
        <array key="sortOrders">
            <xsl:apply-templates select="*"/>
        </array>
    </xsl:template>
    <xsl:template match="sortorder">
        <object>
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
