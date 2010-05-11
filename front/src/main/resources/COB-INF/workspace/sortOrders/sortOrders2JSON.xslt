<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

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
-->

    <xsl:template match="sortorders">
        <result>
            <xsl:apply-templates select="*"/>
        </result>
    </xsl:template>
    
    <xsl:template match="sortorder">
        <sortOrders><id><xsl:value-of select="@id"/></id><xsl:apply-templates /></sortOrders>
    </xsl:template>
    
    <xsl:template match="mappings">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="mapping">
        <data><xsl:apply-templates /></data>
    </xsl:template>
    
    <xsl:template match="to">
        <startLetter><xsl:apply-templates /></startLetter>
    </xsl:template>
    
    <xsl:template match="from">
        <characters><xsl:apply-templates /></characters>
    </xsl:template>
</xsl:stylesheet>
