<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:display="http://www.mpi.nl/lexus/display/1.0"
    xmlns:rr="http://nl.mpi.lexus/resource-resolver" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs" version="2.0">


    <xsl:include href="../util/encodeXML.xslt"/>

    <!-- 
        JSON to produce:
        
        {
        "id": "Mon Aug 16 14:50:36 CEST 2010",
        "result": {"lexicalEntry":         {
        "id": "MmM5MDkwYTIxMWVhYTY5ZTAxMTIyZGMxMTk5OTVjOGU=",
        "children": [            {
        "id": "MmM5MDkwYTIxMWVhYTY5ZTAxMTIyZGMxMTk5OTVjOTA=",
        "value": "aaraj",
        "schemaElementId": "MmM5MDkwYTIxMWVhYTY5ZTAxMTIyZGMxMTk5OTVjOGM=",
        "label": "lx",
        "notes": null
        }],
        "schemaElementId": "MmM5MDkwYTIxMWVhYTY5ZTAxMTIyZGMxMTk5NjVjODQ=",
        "label": "lexicalEntry",
        "notes": null,
        "listView": {"value": "aaraj"},
        "entryView": "entryLayout.htm?id=MmM5MDkwYTIxMWVhYTY5ZTAxMTIyZGMxMTk5OTVjOGU="
        }},
        "requester": "LexiconBrowser1277",
        "status":         {
        "message": "At your service",
        "duration": "114",
        "insync": true,
        "success": true
        },
        "requestId": "35242B50-E85A-A1EC-BC11-7AF38E2C9BFD"
        }
    -->

    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="//lexus:get-lexical-entry/lexus:result/result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="//lexus:get-lexical-entry/lexus:result/result/lexical-entry">
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
            <xsl:apply-templates select="lexical-entry"/>
            <string key="lexiconId"><xsl:value-of select="@lexicon"/></string>
            <xsl:choose>
                <xsl:when test="permissions/write eq 'true'">
                    <true key="isEditable"/>
                </xsl:when>
                <xsl:otherwise>
                    <false key="isEditable"/>
                </xsl:otherwise>
            </xsl:choose>
        </object>
    </xsl:template>

    <xsl:template match="lexical-entry">
        <object key="lexicalEntry">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <object key="listView">
                <xsl:choose>
                    <xsl:when test="//display:lexicon/lexical-entry[@id = current()/@id]">
                        <string key="value">
                            <xsl:apply-templates
                                select="//display:lexicon/lexical-entry[@id = current()/@id]/xhtml:html/xhtml:body/child::node()"
                                mode="encoded"/>
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
            <string key="entryView">entryLayout.htm?lexicon=<xsl:value-of
                    select="ancestor::lexus:get-lexical-entry/lexus:result/result/@lexicon"
                    />&amp;id=<xsl:value-of select="@id"/></string>
            <string key="schemaElementId">
                <xsl:value-of select="@schema-ref"/>
            </string>
            <xsl:if test="container|data">
                <array key="children">
                    <xsl:apply-templates select="container|data"/>
                </array>
            </xsl:if>
            <string key="label">
                <xsl:value-of
                    select="//lexus:get-lexical-entry/lexus:result/result/schema//container[@id eq current()/@schema-ref]/@name"
                />
            </string>
        </object>
<!--        <xsl:apply-templates select="schema"/>-->
    </xsl:template>

    <xsl:template match="container|data">
        <object>
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <xsl:if test="value">
                <string key="value">
                    <xsl:value-of select="value"/>
                </string>
            </xsl:if>
            <string key="schemaElementId">
                <xsl:value-of select="@schema-ref"/>
            </string>
            <xsl:if test="container|data or //lexus:get-lexical-entry/lexus:result/result/schema//container[@id eq current()/@schema-ref]/@type eq 'component'">
                <array key="children">
                    <xsl:apply-templates select="container|data"/>
                </array>
            </xsl:if>
            <string key="label">
                <xsl:value-of
                    select="//lexus:get-lexical-entry/lexus:result/result/schema//container[@id eq current()/@schema-ref]/@name"
                />
            </string>
            <string key="notes">
                <xsl:value-of
                    select="//lexus:get-lexical-entry/lexus:result/result/lexical-entry//data[@id eq current()/@id]/@note"
                />
            </string>

            <xsl:apply-templates select="resource"/>
        </object>
    </xsl:template>


    <xsl:template match="resource">
        <!-- Output this:
            "multimedia":                                                         {
            "mimetype": "text/x-eaf+xml",
            "value": "MPI316757#",
            "archive": "MPI",
            "type": "url",
            "url": "http://corpus1.mpi.nl/ds/annex/runLoader?nodeid=MPI316757%23&time=0&duration=18000&viewType=waveform"
            }
        -->
        <object key="multimedia">
            <string key="value">
                <xsl:value-of select="@value"/>
            </string>
            <string key="type">
                <xsl:value-of select="@type"/>
            </string>
            <string key="mimetype">
                <xsl:value-of select="@mimetype"/>
            </string>
            <string key="archive">
                <xsl:value-of select="@archive"/>
            </string>
            <string key="url">
                <xsl:choose>
                    <xsl:when test="@archive eq 'local'">
                        <rr:resource-id-to-url>
                            <xsl:copy-of select="@*"/>
                            <xsl:attribute name="lexiconId" select="ancestor::lexus:get-lexical-entry/lexus:result/result/@lexicon"/>
                        </rr:resource-id-to-url>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="url"/>
                    </xsl:otherwise>
                </xsl:choose>
            </string>
        </object>
    </xsl:template>
    <xsl:template match="@* | node()"/>

</xsl:stylesheet>
