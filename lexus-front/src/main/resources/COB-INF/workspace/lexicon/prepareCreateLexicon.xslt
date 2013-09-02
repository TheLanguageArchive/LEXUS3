<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="java:java.util.UUID"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <!-- 
        Prepare to create a new lexicon, using the JSON input:
    
           {
           "id": "53DBFE6E-5B55-FF7B-7A93-5DE43E752E89",
           "requester": "workspace",
           "parameters":         {
           "name": "qwerty",
           "description": "asdf",
           "size": 0,
           "note": "nootje"
           }
    
    -->

    <xsl:param name="endpoint"/>
    <xsl:param name="users-collection"/>

    <xsl:param name="templateCatalog"/>

    <xsl:variable name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>
    <xsl:variable name="schema-lexicon-information-id"
        select="concat('uuid:',util:toString(util:randomUUID()))"/>

    <xsl:template match="*[@type='lexicon']" mode="data">
        <lexicon id="{$id}">
            <xsl:apply-templates mode="#current"/>
        </lexicon>
    </xsl:template>

    <xsl:template match="*[@type='lexical-entry']" mode="data">
        <xsl:param name="map" tunnel="yes"/>
        <lexical-entry id="{concat('uuid:',util:toString(util:randomUUID()))}"
            schema-ref="{$map//entry[from=current()/@id]/to}">
            <xsl:apply-templates mode="#current"/>
        </lexical-entry>
    </xsl:template>

    <xsl:template match="*[@type='container']" mode="data">
        <xsl:param name="map" tunnel="yes"/>
        <container id="{concat('uuid:',util:toString(util:randomUUID()))}"
            schema-ref="{$map//entry[from=current()/@id]/to}" name="{@name}">
            <xsl:if test="count(./*) > 0"><xsl:apply-templates mode="#current"/></xsl:if>
        </container>
    </xsl:template>

    <xsl:template match="*[@type='data']" mode="data">
        <xsl:param name="map" tunnel="yes"/>
        <data id="{concat('uuid:',util:toString(util:randomUUID()))}"
            schema-ref="{$map//entry[from=current()/@id]/to}" name="{@name}">
            <value>
                <xsl:value-of select="@name"/>
            </value>
        </data>
    </xsl:template>

    <xsl:template match="@*|text()" mode="schema">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="element()" mode="schema">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@id" mode="schema">
        <xsl:param name="map" tunnel="yes"/>
        <xsl:attribute name="id" select="$map//entry[from=current()]/to"/>
    </xsl:template> 
    
    <xsl:template match="lexus:datacategory" mode="schema">
        <container type="data">
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </container>
    </xsl:template>
        
    <xsl:template match="@*|text()" mode="views">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="element()" mode="views">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@id" mode="views">
        <xsl:param name="map" tunnel="yes"/>
        <xsl:attribute name="id" select="$map//entry[from=current()]/to"/>
    </xsl:template> 
    
    <xsl:template match="lexus:views/@*" mode="views">
        <xsl:param name="map" tunnel="yes"/>
        <xsl:attribute name="{name()}" select="$map//entry[from=current()]/to"/>
    </xsl:template> 
    
    <xsl:template match="/data">
        <xsl:variable name="templateName" select="json/parameters/template"/>
        <xsl:message>INFO: template name:<xsl:value-of select="$templateName"/></xsl:message>
        <xsl:variable name="template"
            select="document($templateCatalog)//lexus:template[@name=$templateName]"/>
        <xsl:message>INFO: template:<xsl:value-of select="$template/@name"/>[<xsl:value-of
                select="$template/@description"/>]</xsl:message>

        <xsl:variable name="map" as="node()">
            <map>
                <xsl:for-each select="distinct-values($template//@id)">
                    <entry>
                        <start>[</start>
                        <from>
                            <xsl:value-of select="current()"/>
                        </from>
                        <arrow>]=[</arrow>
                        <to>
                            <xsl:value-of select="concat('uuid:',util:toString(util:randomUUID()))"
                            />
                        </to>
                        <stop>]</stop>
                        <xsl:value-of select="system-property('line.separator')"/>
                    </entry>
                </xsl:for-each>
            </map>
        </xsl:variable>
        <xsl:message>INFO: map:<xsl:value-of select="$map"/></xsl:message>
        <data>
            <lexus:create-lexicon>
                <lexus id="{$id}">
                    <!--
                        <lexicon id="{$id}">
                        <lexical-entry id="{concat('uuid:',util:toString(util:randomUUID()))}"
                            schema-ref="{$schema-lexical-entry-id}">
                            <container id="{concat('uuid:',util:toString(util:randomUUID()))}"
                                name="Form" schema-ref="{$schema-form-id}">
                                <data id="{concat('uuid:',util:toString(util:randomUUID()))}"
                                    schema-ref="{$schema-lexeme-id}" name="Lexeme"
                                    reference="http://www.isocat.org/datcat/DC-1325"
                                    registry="12620">
                                    <value>Lexeme</value>
                                </data>
                            </container>
                            <container id="{concat('uuid:',util:toString(util:randomUUID()))}"
                                name="Sense" schema-ref="{$schema-sense-id}"/>
                        </lexical-entry>
                        </lexicon>
                    -->
                    <meta id="{$id}">
                        <name>
                            <xsl:value-of select="json/parameters/name"/>
                        </name>
                        <template name="{$template/@id}">
                        	<xsl:for-each select="$template/lexus:export">
    							<export name="{@name}" id ="{@id}"  description="{@description}" valid="true">
    							</export>                    	
                        	</xsl:for-each>
                        		
                        </template>
                        <description>
                            <xsl:value-of select="json/parameters/description"/>
                        </description>
                        <note>
                            <xsl:value-of select="json/parameters/note"/>
                        </note>
                        <owner ref="{user/@id}"/>
                        <users>
                            <user ref="{user/@id}">
                                <permissions>
                                    <read>true</read>
                                    <write>true</write>
                                </permissions>
                            </user>
                        </users>
                        <schema>
                            <xsl:apply-templates mode="schema" select="$template/lexus:schema/*">
                                <xsl:with-param name="map" select="$map" tunnel="yes"/>
                            </xsl:apply-templates>
                            <!--
                            <container id="{$id}"
                                description="The container for all the lexical entries of a source language within the database. A Lexicon must contain at least one lexical entry"
                                name="Lexicon" mandatory="true" multiple="false" type="lexicon"
                                admin-info="">
                                <container id="{$schema-lexical-entry-id}"
                                    description="Represents a word, a multi-word expression, or an affix in a given language"
                                    name="Lexical Entry" mandatory="true" multiple="true"
                                    type="lexical-entry" admin-info="">
                                    <container id="{$schema-form-id}"
                                        description="Represents one lexical variant of the written or spoken form of the lexical entry"
                                        name="Form" mandatory="true" multiple="false"
                                        type="container" admin-info="">
                                        <container id="{$schema-lexeme-id}"
                                            description="Main word of the lexical entry"
                                            name="Lexeme" mandatory="true" multiple="false"
                                            type="data" admin-info=""/>
                                    </container>
                                    <container id="{$schema-sense-id}"
                                        description="Contains attributes that describe meanings of a lexical entry"
                                        name="Sense" mandatory="false" multiple="true"
                                        type="container" admin-info=""/>
                                </container>
                            </container>
                            -->
                        </schema>
                        <xsl:apply-templates mode="views" select="$template/lexus:views">
                            <xsl:with-param name="map" select="$map" tunnel="yes"/>
                        </xsl:apply-templates>
                        <!--
                        <views listView="{$listViewId}" lexicalEntryView="{$leViewId}">
                            <view id="{$listViewId}" type="dsl_view" isBranch="true"
                                name="List view" description="Created by Lexus.">
                                <style/>
                                <structure isBranch="true">
                                    <show optional="false" isBranch="true" type="dsl_show"
                                        name="Decorator" dsl_class="">
                                        <data isBranch="false" type="data category" name="Lexeme"
                                            id="{$schema-lexeme-id}"/>
                                    </show>
                                </structure>
                            </view>
                            <view id="{$leViewId}" isBranch="true" name="Lexical Entry View"
                                description="Created by Lexus." type="dsl_view">
                                <style type="dsl_style">
                                    body {
                                        background-color : #333333;
                                    }
                                    .lexeme {
                                        font-size : 20pt;
                                        color : grey;
                                    }</style>
                                <structure isBranch="true">
                                    <show type="dsl_show" name="Decorator" 
                                        isBranch="true" dsl_class="lexeme" optional="false"
                                        block="false" localStyle="false">
                                        <data isBranch="false" type="data category" name="Lexeme"
                                            id="{$schema-lexeme-id}"/>
                                    </show>
                                </structure>
                            </view>
                        </views>
                        -->
                    </meta>
                    <xsl:apply-templates mode="data" select="$template/lexus:schema/*">
                        <xsl:with-param name="map" select="$map" tunnel="yes"/>
                    </xsl:apply-templates>
                </lexus>
            </lexus:create-lexicon>
            <lexus:get-saved-lexicon id="{$id}"/>
            <xsl:copy-of select="user"/>
        </data>
    </xsl:template>

</xsl:stylesheet>
