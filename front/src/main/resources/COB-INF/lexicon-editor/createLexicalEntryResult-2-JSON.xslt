<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs" version="2.0">


    <!-- 
        JSON to produce:
        
        
        {
        "id": "Wed Nov 10 10:50:29 CET 2010",
        "result": {"entry":         {
        "id": "OGE4MDgxODMyYzM1MmU3MTAxMmMzNTMxOWI3ZDAxNTY=",
        "children":             [
        {
        "id": "OGE4MDgxODMyYzM1MmU3MTAxMmMzNTMxOWI5NDAxNTg=",
        .....
        ],
        "schemaElementId": "MmM5MDkwYTIxNjMzMjUzNDAxMTYzNDk1MGM2ZjAwMDM=",
        "label": "lexicalEntry",
        "notes": null,
        "listView": {"value": "\n&lt;span&gt;&lt;span id=&quot;OGE4MDgxODMyYzM1MmU3MTAxMmMzNTMxOWJiNDAxYjI=&quot;&gt;&lt;img align=&quot;right&quot; height=&quot;12&quot; hspace=&quot;45&quot; src=&quot;images/white.gif&quot; vspace=&quot;0&quot; width=&quot;12&quot;/&gt; &lt;img align=&quot;right&quot; height=&quot;12&quot; hspace=&quot;45&quot; src=&quot;images/white.gif&quot; vspace=&quot;-11&quot; width=&quot;12&quot;/&gt;&amp;amp;#84;&amp;amp;#111;&amp;amp;#32;&amp;amp;#98;&amp;amp;#101;&amp;amp;#32;&amp;amp;#115;&amp;amp;#112;&amp;amp;#101;&amp;amp;#99;&amp;amp;#105;&amp;amp;#102;&amp;amp;#105;&amp;amp;#101;&amp;amp;#100;&lt;/span&gt;&lt;/span&gt; &lt;span&gt;&lt;span id=&quot;OGE4MDgxODMyYzM1MmU3MTAxMmMzNTMxOWJiMzAxYTI=&quot;&gt;&lt;img align=&quot;right&quot; height=&quot;12&quot; hspace=&quot;45&quot; src=&quot;images/white.gif&quot; vspace=&quot;0&quot; width=&quot;12&quot;/&gt; &lt;img align=&quot;right&quot; height=&quot;12&quot; hspace=&quot;45&quot; src=&quot;images/white.gif&quot; vspace=&quot;-11&quot; width=&quot;12&quot;/&gt;&amp;amp;#84;&amp;amp;#111;&amp;amp;#32;&amp;amp;#98;&amp;amp;#101;&amp;amp;#32;&amp;amp;#115;&amp;amp;#112;&amp;amp;#101;&amp;amp;#99;&amp;amp;#105;&amp;amp;#102;&amp;amp;#105;&amp;amp;#101;&amp;amp;#100;&lt;/span&gt;&lt;/span&gt;&lt;span&gt;&lt;span id=&quot;OGE4MDgxODMyYzM1MmU3MTAxMmMzNTMxOWJhZjAxYTA=&quot;&gt;&lt;img align=&quot;right&quot; height=&quot;12&quot; hspace=&quot;45&quot; src=&quot;images/white.gif&quot; vspace=&quot;0&quot; width=&quot;12&quot;/&gt; &lt;img align=&quot;right&quot; height=&quot;12&quot; hspace=&quot;45&quot; src=&quot;images/white.gif&quot; vspace=&quot;-11&quot; width=&quot;12&quot;/&gt;&amp;amp;#84;&amp;amp;#111;&amp;amp;#32;&amp;amp;#98;&amp;amp;#101;&amp;amp;#32;&amp;amp;#115;&amp;amp;#112;&amp;amp;#101;&amp;amp;#99;&amp;amp;#105;&amp;amp;#102;&amp;amp;#105;&amp;amp;#101;&amp;amp;#100;&lt;/span&gt;&lt;/span&gt;\n"},
        "entryView": "entryLayout.htm?id=OGE4MDgxODMyYzM1MmU3MTAxMmMzNTMxOWI3ZDAxNTY="
        }},
        "requester": "LexiconBrowser1000",
        "status":         {
        "message": "At your service",
        "duration": "3995",
        "insync": true,
        "success": true
        },
        "requestId": "CC105BC9-EC08-7AC3-D203-353190CFFF2C"
        }
    -->

    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="/data/result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="/data/result/schema">
                        <true key="success"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <false key="success"/>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
        </object>
    </xsl:template>



    <xsl:template match="result">
        <object key="result">
            <xsl:apply-templates select="schema//container[@type eq 'lexical-entry']"/>
        </object>
    </xsl:template>



    <xsl:template match="container[@type eq 'lexical-entry']">
        <object key="entry">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="value">
                <xsl:value-of select="value"/>
            </string>
            <string key="schemaElementId">
                <xsl:value-of select="@id"/>
            </string>
            <string key="label">
                <xsl:value-of select="@name"/>
            </string>
            <object key="listView">
                <xsl:choose>
                    <xsl:when test="/data/lexus:display/lexical-entry[@id = current()/@id]">
                        <string key="value">
                            <![CDATA[<b>]]>
                            <xsl:value-of
                                select="/data/lexus:display/lexical-entry[@id = current()/@id]/xhtml:html/xhtml:body"/>
                            <xsl:apply-templates
                                select="/data/lexus:display/lexical-entry[@id = current()/@id]/xhtml:html/xhtml:body/*"
                                mode="encoded"/>
                            <![CDATA[</b>]]>
                        </string>
                    </xsl:when>
                    <xsl:otherwise>
                        <string key="value">
                            <xsl:variable name="son" select=".//data[@sort-key][1]"/>
                            <xsl:value-of select="$son/value"/>
                        </string>
                    </xsl:otherwise>
                </xsl:choose>
            </object>
            <string key="entryView">entryLayout.htm?lexicon=<xsl:value-of select="ancestor::lexus:get-lexical-entry/result/@lexicon"/>&amp;id=<xsl:value-of select="@id"/></string>
            <xsl:if test="container|data">
                <array key="children">
                    <xsl:apply-templates select="container|data"/>
                </array>
            </xsl:if>
        </object>
    </xsl:template>



    <xsl:template match="container|data">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <string key="value">
                <xsl:value-of select="value"/>
            </string>
            <string key="schemaElementId">
                <xsl:value-of select="@id"/>
            </string>
            <xsl:if test="container|data">
                <array key="children">
                    <xsl:apply-templates select="container|data"/>
                </array>
            </xsl:if>
            <string key="label">
                <xsl:value-of select="@name"/>
            </string>
        </object>
    </xsl:template>



</xsl:stylesheet>
