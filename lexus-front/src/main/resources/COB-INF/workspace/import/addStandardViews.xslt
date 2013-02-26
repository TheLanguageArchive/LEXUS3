<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:dcr="http://www.isocat.org/ns/dcr"
    xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/" xmlns:ex="http://apache.org/cocoon/exception/1.0"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="#all" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 15, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p/>
            <xd:p>Create standard views, list view and lexical entry view.</xd:p>
        </xd:desc>
    </xd:doc>


    <!--
        When views are not defined, add standard views, list view and lexical entry view.
    -->
    <xsl:template match="lexus:meta[not(lexus:views)]" priority="1">
        <xsl:param name="lexiconId"/>
        <xsl:copy>
            <xsl:apply-templates select="@*[local-name() ne 'id']"/>
            <xsl:apply-templates select="*"/>

            <!-- Now create two standard views -->
            <xsl:variable name="listView" select="concat('uuid:',util:toString(util:randomUUID()))"/>
            <xsl:variable name="lexicalEntryView"
                select="concat('uuid:',util:toString(util:randomUUID()))"/>
            
            <xsl:variable name="lexemeId">
                <xsl:choose>
                    <xsl:when
                        test=".//lexus:container[@type eq 'data'][@dcr:datcat eq 'http://www.isocat.org/datcat/DC-3723']">
                        <xsl:value-of
                            select="(.//lexus:container[@type eq 'data'][@dcr:datcat eq 'http://www.isocat.org/datcat/DC-3723'])[1]/@id"
                        />
                    </xsl:when>
                    <xsl:when
                        test=".//lexus:container[@type eq 'data'][@mdf:marker eq 'lx']">
                        <xsl:value-of
                            select="(.//lexus:container[@type eq 'data'][@mdf:marker eq 'lx'])[1]/@id"
                        />
                    </xsl:when>
                    
                    <xsl:when
                        test=".//lexus:container[@type eq 'data'][lower-case(@name) eq 'lexeme']">
                        <xsl:value-of
                            select="(.//lexus:container[@type eq 'data'][lower-case(@name) eq 'lexeme'])[1]/@id"
                        />
                    </xsl:when>
                    <xsl:when
                        test=".//lexus:container[@type eq 'data'][lower-case(@name) eq 'headword']">
                        <xsl:value-of
                            select="(.//lexus:container[@type eq 'data'][lower-case(@name) eq 'headword'])[1]/@id"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select=".//lexus:container[@type eq 'data'][1]/@id"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <lexus:views listView="{$listView}" lexicalEntryView="{$lexicalEntryView}">
                <lexus:view id="{$listView}" name="List view"
                    description="This view has been generated during import. It is used when displaying a list of entries in the lexicon editor."
                    type="dsl_view">
                    <lexus:style/>
                    <lexus:structure isBranch="true">
                        <lexus:show type="dsl_show" name="Decorator" color="0x333333" fontSize="12"
                            fontFamily="Arial" isBranch="true" dsl_class="lexeme" optional="false"
                            localStyle="true">
                            <lexus:data id="{$lexemeId}" name="Data Category" type="data category"
                                isBranch="false"/>
                        </lexus:show>
                    </lexus:structure>
                </lexus:view>
                <lexus:view id="{$lexicalEntryView}" type="dsl_view" isBranch="true" name="Lexical Entry view" description="This view has been generated during import. It is used when displaying one entry in the lexicon editor.">
                    <lexus:style isBranch="false">.lexeme {
    font-family: Arial;
    font-weight: bold;
    font-size: 20pt;
    color:#333333;
}
.base {
}

</lexus:style>
                    <lexus:structure isBranch="true" dsl_class="base">
                        <lexus:show optional="false" isBranch="true" type="dsl_show" name="Container" dsl_class="lexeme" localStyle="false">
                            <lexus:data isBranch="false" type="data category" name="Data Category" id="{$lexemeId}"/>
                        </lexus:show>
                    </lexus:structure>
                </lexus:view>
            </lexus:views>
        </xsl:copy>
    </xsl:template>

    <!--
        Identity transform.
        -->
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
