<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" 
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
            <xsl:apply-templates select="data/result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="data/result/lexical-entry">
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
        </object>
    </xsl:template>

    <xsl:template match="lexical-entry">
        <object key="lexicalEntry">
            <string key="id">
                <xsl:value-of select="@id"/>
            </string>
            <!--<object key="listView">
                <string key="value">
                    <xsl:variable name="son" select=".//data[@sort-key][1]"/>
                    <xsl:value-of select="$son/value"/>
                </string>
                </object>-->
            <object key="listView">
                <xsl:choose>
                    <xsl:when
                        test="/data/lexus:display/lexical-entry[@id = current()/@id]">
                        <string key="value">
                            <![CDATA[<b>]]>
                            <xsl:value-of select="/data/lexus:display/lexical-entry[@id = current()/@id]/xhtml:html/xhtml:body"/>
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
            <string key="entryView">entryLayout.htm?id=<xsl:value-of select="@id"/></string>
            <string key="schemaElementId">
                <xsl:value-of select="@schema-ref"/>
            </string>
            <xsl:if test="container|data">
                <array key="children">
                    <xsl:apply-templates select="container|data"/>
                </array>
            </xsl:if>
            <string key="label">
                <xsl:value-of select="/data/result/schema//container[@id eq current()/@schema-ref]/@name"
                />
            </string>
        </object>
        <xsl:apply-templates select="schema"/>
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
            <xsl:if test="container|data">
                <array key="children">
                    <xsl:apply-templates select="container|data"/>
                </array>
            </xsl:if>
            <string key="label">
                <xsl:value-of select="/data/result/schema//container[@id eq current()/@schema-ref]/@name"
                />
            </string>
        </object>
    </xsl:template>

    <xsl:template match="@* | node()"/>

</xsl:stylesheet>
