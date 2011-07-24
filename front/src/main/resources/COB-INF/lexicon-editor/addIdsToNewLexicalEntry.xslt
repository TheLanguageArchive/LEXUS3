<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="#all" version="2.0">


    <xsl:import href="../util/identity.xslt"/>

    <xsl:variable name="lexicalEntryId" select="concat('uuid:',util:toString(util:randomUUID()))"/>

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

    <!--
        Process the result of getSchema. Store a lexical entry in the db, then get it again from the db.
        -->
    <xsl:template match="result">
        
        <lexus:save-lexical-entry lexicon="{/data/json/parameters/id}">
            <xsl:apply-templates select="schema//container[@type eq 'lexical-entry']"/>
        </lexus:save-lexical-entry>

        <!-- Once it has been stored to the database, read the result from the db. -->
        <lexus:get-lexical-entry>
            <lexicon>
                <xsl:value-of select="/data/json/parameters/id"/>
            </lexicon>
            <id>
                <xsl:value-of select="$lexicalEntryId"/>
            </id>
        </lexus:get-lexical-entry>
    </xsl:template>


    <xsl:template match="container[@type eq 'lexical-entry']" priority="1">
        <lexical-entry id="{$lexicalEntryId}" schema-ref="{@id}">
            <xsl:apply-templates/>
        </lexical-entry>
    </xsl:template>

    <xsl:template match="container[@type eq 'container']">
        <xsl:variable name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
        <container id="{$id}" schema-ref="{@id}" name="{@name}">
            <xsl:apply-templates/>
        </container>
    </xsl:template>

    <xsl:template match="container[@type eq 'data']">
        <xsl:variable name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
        <data id="{$id}" schema-ref="{@id}" name="{@name}">
            <value/>
        </data>
    </xsl:template>

</xsl:stylesheet>
