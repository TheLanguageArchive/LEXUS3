<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus" 
    xmlns:process-upload="http://www.mpi.nl/lexus/process-upload/1.0" 
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="json">
        <xsl:copy-of select="."/>


        <!-- 
            Save the lexical entry.
        -->
        <lexus:save-lexical-entry lexicon="{parameters/lexicon}">
            <xsl:apply-templates select="parameters/lexicalEntry"/>
        </lexus:save-lexical-entry>
        
        
        <!-- 
            Update the sort-order keys in the lexical entry previously saved.
        -->
        <lexus:update-sort-order-keys-in-lexical-entry lexicon="{parameters/lexicon}" user-id="{/data/user/@id}">
            <xsl:apply-templates select="parameters/lexicalEntry" mode="update-sort-order-keys"/>
        </lexus:update-sort-order-keys-in-lexical-entry>
        
        
        
        <!-- 
            Get Lexical Entry after it has been saved and the sort-order keys have been updated.
        -->
        <lexus:get-lexical-entry>
            <lexicon>
                <xsl:value-of select="parameters/lexicon"/>
            </lexicon>
            <id>
                <xsl:value-of select="parameters/lexicalEntry/id"/>
            </id>
        </lexus:get-lexical-entry>
    </xsl:template>


    <xsl:template match="lexicalEntry" mode="update-sort-order-keys">
        <lexical-entry id="{id}"/>
    </xsl:template>
    
    <xsl:template match="lexicalEntry">
        <lexical-entry id="{id}" schema-ref="{schemaElementId}">
            <xsl:apply-templates select="children/children"/>
        </lexical-entry>
    </xsl:template>

    <xsl:template match="children[children]">
        <container id="{id}" schema-ref="{schemaElementId}" name="{label}">
            <xsl:apply-templates select="children/children"/>
        </container>
    </xsl:template>

    <xsl:template match="children[not(children)]">
        <data id="{id}" schema-ref="{schemaElementId}" name="{label}">
            <value>
                <xsl:value-of select="value"/>
            </value>
            <!-- If any resources were added or already existed, copy them. -->
            <xsl:copy-of select="resource"/>
        </data>
    </xsl:template>
</xsl:stylesheet>
