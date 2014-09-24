<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:zip="http://expath.org/ns/zip" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
    xmlns:java="java:org.expath.saxon.Zip" version="2.0">
    <xsl:param name="tempfolder" select="''"/>
    <xsl:param name="format" select="''"/>
<!--     <xsl:output indent="yes"/> -->
    <xsl:function name="zip:entries" as="element(zip:file)">
        <xsl:param name="href" as="xs:string"/>
        <xsl:sequence select="java:entries($href)"/>
    </xsl:function>

    <xsl:function name="zip:xml-entry" as="document-node()">
        <xsl:param name="href" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="java:xml-entry($href, $path)"/>
    </xsl:function>

    <xsl:function name="zip:html-entry" as="document-node()">
        <xsl:param name="href" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="java:html-entry($href, $path)"/>
    </xsl:function>

    <xsl:function name="zip:text-entry" as="xs:string">
        <xsl:param name="href" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="java:text-entry($href, $path)"/>
    </xsl:function>

    <xsl:function name="zip:binary-entry" as="xs:base64Binary">
        <xsl:param name="href" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="java:binary-entry($href, $path)"/>
    </xsl:function>

    <xsl:function name="zip:zip-file">
        <!-- as="empty()" -->
        <xsl:param name="zip" as="element(zip:file)"/>
        <xsl:sequence select="java:zip-file($zip)"/>
    </xsl:function>

    <xsl:function name="zip:update-entries">
        <!-- as="empty()" -->
        <xsl:param name="zip" as="element(zip:file)"/>
        <xsl:param name="output" as="xs:string"/>
        <xsl:sequence select="java:update-entries($zip, $output)"/>
    </xsl:function>

    <xsl:variable name="zipFileId" select="/data/json/parameters"/>
    <xsl:variable name="zip" select="concat('file:', $tempfolder, $zipFileId,'.zip')" />
    <xsl:variable name="zipDir" select="zip:entries(resolve-uri($zip))"/>
    <!-- <xsl:include href="formats/RELISH-LL-LMF-to-LEXUS.xsl"/> -->
	 <xsl:template match="/" >
    
     <xsl:element name="data">
       <xsl:copy-of select="data/user"/>
       <xsl:choose>  
       <xsl:when test="$format = 'Lexus3XML'">
	        <xsl:apply-templates select="$zipDir" mode="LEXUS3XML"/>
		</xsl:when>
		<xsl:when test="$format = 'relish-ll-lmf-to-lexus'">
<!-- 			<xsl:message>DBG: welcome to RELISH-LL-LMF to LEXUS</xsl:message> -->
			<xsl:apply-templates select="$zipDir" mode="relish-ll-lmf"/>
		</xsl:when>
    </xsl:choose>
 	</xsl:element>
    </xsl:template>
    
    <!--  LEXUS3XML -->
    
   <xsl:template match="zip:file" mode="LEXUS3XML">
       <!--<xsl:message>
           DBG:<xsl:copy-of select="."/>
       </xsl:message>-->
   	<xsl:variable name="schema_file" select=".//zip:entry[ends-with(@name, '_internal_schema.xml') or @name eq 'typ-generated-schema.xml'][empty(ancestor::zip:dir[@name='__MACOSX'])]"/>
       <!--<xsl:message>
       	DBG:schema[<xsl:copy-of select="$schema_file"/>][<xsl:copy-of select="zip:xml-entry($zip,concat(string-join($schema_file/ancestor::zip:dir/@name,'/'),if (exists($schema_file/ancestor::zip:dir)) then ('/') else (),$schema_file/@name))"/>]
       </xsl:message>-->
       <xsl:variable name="data_file" select="(.//zip:entry[ends-with(@name, '.xml')][empty(ancestor::zip:dir[@name='__MACOSX'])] except $schema_file)"/>
       <!--<xsl:message>
       	DBG:data[<xsl:copy-of select="$data_file"/>][<xsl:copy-of select="zip:xml-entry($zip,concat(string-join($data_file/ancestor::zip:dir/@name,'/'),if (exists($data_file/ancestor::zip:dir)) then ('/') else (),$data_file/@name))"/>]
       </xsl:message>-->
       <xsl:choose>
          	<xsl:when test="empty($schema_file)">
       		   	<xsl:value-of select="error((),'ERROR: no Lexus schema file has been found!')"/> 
          	</xsl:when>
       		<xsl:when test="empty($data_file)">
          		<xsl:value-of select="error((),'ERROR: no Lexus data file has been found!')"/> ')"/>
       		</xsl:when>
       		<xsl:when test="count($data_file) ne 1">
       			<xsl:value-of select="error((),'ERROR: more then one LEXUS 3 data files were found!')"/> ')"/>
          	</xsl:when>
       		<xsl:otherwise>
       			<xsl:variable name="schema" select="zip:xml-entry($zip,concat(string-join($schema_file/ancestor::zip:dir/@name,'/'),if (exists($schema_file/ancestor::zip:dir)) then ('/') else (),$schema_file/@name))//lexus:meta"/>
       			<xsl:variable name="data"   select="zip:xml-entry($zip,concat(string-join($data_file/ancestor::zip:dir/@name,'/'),if (exists($data_file/ancestor::zip:dir)) then ('/') else (),$data_file/@name))//lexus:lexicon"/>
       			<xsl:choose>
       				<xsl:when test="empty($schema)">
		          		<xsl:value-of select="error((),'ERROR: the LEXUS 3 schema was not found in the scheme file!')"/> ')"/>
       				</xsl:when>
       				<xsl:when test="empty($data)"> 
    					<xsl:value-of select="error((),'ERROR: the LEXUS 3 data was not found in the data file!')"/> ')"/>
		          	</xsl:when>
       				<xsl:otherwise>
				    	<xsl:apply-templates select="$schema" mode="LEXUS3XML"/> 
          				<xsl:apply-templates select="$data" mode="LEXUS3XML"/>
       				</xsl:otherwise>
       			</xsl:choose>
       		</xsl:otherwise>
          </xsl:choose>
    </xsl:template>

    <xsl:template match="lexus:lexicon" mode="LEXUS3XML">
            <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="lexus:meta" mode="LEXUS3XML">
      	<xsl:copy-of select="."/>        
    </xsl:template>
    
    <!-- relish-ll-lmf -->
    
    <xsl:template match="zip:file" mode="relish-ll-lmf">
        <!--<xsl:message>
            DBG:<xsl:copy-of select="."/>
        </xsl:message>-->
        <!--     	<xsl:message>DBG: zip:file[<xsl:value-of select="string-join(zip:entry/@name,', ')"/>][<xsl:value-of select="string-join(zip:entry/zip:xml-entry($zip,@name)/name(*),', ')"/>]</xsl:message> -->
    	<xsl:variable name="xsl" select="saxon:compile-stylesheet(doc('format/RELISH-LL-LMF-to-LEXUS.xsl'))"/>
<!--     	<xsl:message>DBG: compiled stylesheet</xsl:message> -->
    	<xsl:variable name="paramTemplateId">
    		<import-id>
    			<xsl:value-of select="$format"/>
    		</import-id>
    	</xsl:variable>
    	<xsl:variable name="lmf">
    	    <xsl:for-each select=".//zip:entry[empty(ancestor::zip:dir[@name='__MACOSX'])][not(ends-with(@name,'.DS_Store'))]">
    	    	<!--<xsl:message>DBG: entry[<xsl:value-of select="@name"/>]</xsl:message>-->
    	        <xsl:variable name="doc" select="zip:xml-entry($zip,concat(string-join(ancestor::zip:dir/@name,'/'),'/',@name))"/>
                <!--<xsl:message>DBG: root[<xsl:value-of select="$doc/name(*)"/>]</xsl:message> -->
    			<xsl:if test="$doc/name(*)='lmf:LexicalResource'">
                    <!--<xsl:message>DBG: found a RELISH-LL-LMF lexicon</xsl:message>-->
					<xsl:sequence select="$doc"/>
   				</xsl:if>
    		</xsl:for-each>
    	</xsl:variable>
    	<xsl:choose>
    		<xsl:when test="count($lmf) eq 1">
    			<xsl:copy-of select="saxon:transform($xsl,$lmf/*)/data/*"/>
    		</xsl:when>
    		<xsl:when test="count($lmf) gt 1">
    			<!--  ERROR: multiple RELISH LL LMF documents have been found! -->
    			<xsl:value-of select="error((),'ERROR: multiple RELISH LL LMF documents have been found!')"/> ')"/>
    		</xsl:when>
    		<xsl:otherwise>
    			<xsl:value-of select="error((),'ERROR: no RELISH LL LMF document has been found!')"/> ')"/>
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:template>
   
</xsl:stylesheet>