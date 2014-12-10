<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:lx="http://tla.mpi.nl/lexus"
    xmlns:lmf="http://www.lexicalmarkupframework.org/"
    xmlns:dcr="http://www.isocat.org/ns/dcr"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:relish="http://www.mpi.nl/relish"
    xmlns:lexus="http://www.mpi.nl/lexus"
    exclude-result-prefixes="lx">
    
    <!--<xsl:param name="lexicon"/>
    <xsl:variable name="lex-schema" select="document(concat($lexicon,'-schema.xml'))"/>-->
	
	<xsl:variable name="debug" select="false()"/>
    <xsl:variable name="relish-ll-lmf-template" select="//lexus/meta/template"/>
    <xsl:variable name="relish-ll-lmf-lex-template" select="(if ($templates instance of node()) then ($templates) else (document($templates)))//lexus:template[@id=$relish-ll-lmf-template]"/>
    
	<xsl:variable name="relish-ll-lmf-schema" select="'https://raw.githubusercontent.com/TheLanguageArchive/RELISH-LMF/master/schema/RELISH-LL-LMF/RELISH-LL-LMF.rng'"/>
    
    <xsl:variable name="relish-ll-lmf-classes" as="element()*">
        <class name="Lemma" type="Form"/>
        <class name="FormRepresentation" type="Representation"/>
        <class name="Sense"/>
        <class name="Definition"/>
        <class name="Statement"/>
        <class name="TextRepresentation" type="Representation"/>
        <class name="Context"/>
        <class name="SenseRelation"/>
        <class name="RelatedForm"/>
    </xsl:variable>
    
    <xsl:template match="text()" mode="relish-ll-lmf"/>
        
    <xsl:template name="relish-ll-lmf-id">
        <xsl:if test="exists(@id)">
            <xsl:attribute name="xml:id" select="@id"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="relish-ll-lmf-targets">
        <xsl:if test="exists(data[@name='target'])">
            <xsl:choose>
                <xsl:when test="exists(data[@name='target']/resource[@type='entry-link'])">
                    <xsl:attribute name="targets" select="string-join(data[@name='target']/resource/@id,'')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="relish-ll-lmf-language">
        <xsl:if test="exists(../data[@name='language'])">
            <xsl:attribute name="xml:lang" select="../data[@name='language']/value"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="lexicon" mode="relish-ll-lmf">
    	<xsl:if test="$debug">
    		<xsl:message>?INFO: template[<xsl:value-of select="$relish-ll-lmf-template"/>][<xsl:value-of select="$relish-ll-lmf-lex-template/descendant-or-self::lexus:template/@id"/>]</xsl:message>
    		<xsl:message>?INFO: templates[<xsl:value-of select="string-join($templates//lexus:template/@id,', ')"/>]</xsl:message>
    	</xsl:if>
        <xsl:processing-instruction name="xml-model">href="<xsl:value-of select="$relish-ll-lmf-schema"/>" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:value-of select="system-property('line.separator')"/>
        <xsl:processing-instruction name="xml-model">href="<xsl:value-of select="$relish-ll-lmf-schema"/>" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <xsl:value-of select="system-property('line.separator')"/>
        <lmf:LexicalResource xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
            xmlns:lmf="http://www.lexicalmarkupframework.org/"
            xmlns:dcr="http://www.isocat.org/ns/dcr"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:relish="http://www.mpi.nl/relish"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:dcterms="http://purl.org/dc/terms/"
            xmlns:olac="http://www.language-archives.org/OLAC/1.0/"
            xmlns:lego="http://purl.org/linguistics/lego/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance/"
            lmfVersion="ISO 24613:2008">
            <lmf:GlobalInformation>
                <tei:f name="languageCoding" dcr:datcat="http://www.isocat.org/datcat/DC-2482">
                    <tei:string>ISO639-3</tei:string>
                </tei:f>
            </lmf:GlobalInformation>
            <lmf:Lexicon>
                <xsl:variable name="lex">
                    <xsl:apply-templates mode="#current"/>
                </xsl:variable>
                <xsl:apply-templates select="$lex" mode="relish-ll-lmf-fsr-cleanup"/>
            </lmf:Lexicon>
        </lmf:LexicalResource>
    </xsl:template>
    
    <xsl:template match="lexical-entry" mode="relish-ll-lmf">
        <lmf:LexicalEntry xml:id="{@id}">
            <xsl:apply-templates mode="#current">
                <xsl:with-param name="context" select="$relish-ll-lmf-lex-template//lexus:container[@type='lexical-entry']/@id" tunnel="yes"/>
            </xsl:apply-templates>
        </lmf:LexicalEntry>
    </xsl:template>
    
    <xsl:template match="container" mode="relish-ll-lmf">
        <xsl:param name="context" tunnel="yes"/>
    	<xsl:if test="$debug">
    		<xsl:message>DBG: context[<xsl:value-of select="$context"/>] container[<xsl:value-of select="@name"/>][<xsl:value-of select="lower-case(replace(current()/@name,'\s+',''))"/>]</xsl:message>
    	</xsl:if>
        <xsl:variable name="schema-context" select="$relish-ll-lmf-lex-template//lexus:container[@id=$context]"/>
        <xsl:variable name="schema-entry" select="$schema-context/lexus:container[@type='container'][lower-case(replace(@name,'\s+',''))=lower-case(replace(current()/@name,'\s+',''))]"/>
    	<xsl:if test="$debug">
    		<xsl:message>DBG: schema[<xsl:value-of select="count($schema-context)"/>/<xsl:value-of select="count($schema-entry)"/>]</xsl:message>
    	</xsl:if>
        <xsl:choose>
            <xsl:when test="exists($schema-entry)">
                <!-- known LMF class element -->
            	<xsl:if test="$debug">
            		<xsl:message>DBG: classes[<xsl:value-of select="string-join($relish-ll-lmf-classes/@name,', ')"/>] class[<xsl:value-of select="replace($schema-entry/@name,'\s+','')"/>]?[<xsl:value-of select="$relish-ll-lmf-classes[@name=replace($schema-entry/@name,'\s+','')]/@name"/>]</xsl:message>
            	</xsl:if>
                <xsl:variable name="class" select="$relish-ll-lmf-classes[@name=replace($schema-entry/@name,'\s+','')]"/>
                <xsl:element name="lmf:{replace($schema-entry/@name,'\s+','')}" namespace="http://www.lexicalmarkupframework.org/">
                    <xsl:copy-of select="$class/@type"/>
                    <xsl:call-template name="relish-ll-lmf-id"/>
                    <xsl:call-template name="relish-ll-lmf-targets"/>
                    <xsl:apply-templates mode="#current">
                        <xsl:with-param name="context" select="$schema-entry/@id" tunnel="yes"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="relish-ll-lmf-fsr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="data[@name='target']" mode="relish-ll-lmf"/>
    
    <xsl:template match="data[@name='language']" mode="relish-ll-lmf">
        <xsl:if test="empty((preceding-sibling::data,following-sibling::data)[@name!='language'][@name!='target'])">
            <tei:f name="{@name}">
                <tei:string>
                    <xsl:value-of select="value"/>
                </tei:string>
            </tei:f>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="data" mode="relish-ll-lmf">
        <tei:f name="{@name}">
            <tei:string>
                <xsl:call-template name="relish-ll-lmf-language"/>
                <xsl:value-of select="value"/>
            </tei:string>
        </tei:f>
    </xsl:template>

	<!--  Feature Structure Representation -->    
    
    <xsl:template match="text()" mode="relish-ll-lmf-fsr"/>
    
    <xsl:template match="container" mode="relish-ll-lmf-fsr">
        <tei:f name="{@name}">
            <tei:fs>
                <xsl:apply-templates mode="#current"/>
            </tei:fs>
        </tei:f>
    </xsl:template>
    
    <xsl:template match="data[@name='language']" mode="relish-ll-lmf-fsr">
        <xsl:if test="empty((preceding-sibling::data,following-sibling::data)[@name!='language'][@name!='target'])">
            <tei:f name="{@name}">
                <tei:string>
                    <xsl:value-of select="value"/>
                </tei:string>
            </tei:f>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="data" mode="relish-ll-lmf-fsr">
        <tei:f name="{@name}">
            <tei:string>
                <xsl:call-template name="relish-ll-lmf-language"/>
                <xsl:value-of select="value"/>
            </tei:string>
        </tei:f>
    </xsl:template>

    <!-- FSR cleanup: if there is a redundant tei:f/@name group their content in a tei:f/tei:vColl -->
    
    <xsl:template match="@*|node()" mode="relish-ll-lmf-fsr-cleanup">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>        
    
    <xsl:template match="lmf:*|tei:fs" mode="relish-ll-lmf-fsr-cleanup">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="* except tei:*" mode="#current"/>
            <xsl:for-each-group select="tei:f" group-by="@name">
                <xsl:choose>
                    <xsl:when test="count(current-group()) gt 1">
                        <tei:f name="{current-grouping-key()}">
                            <tei:vColl>
                                <xsl:apply-templates select="current-group()/*" mode="#current"/>
                            </tei:vColl>
                        </tei:f>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template> 

</xsl:stylesheet>