<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:dcr="http://www.isocat.org/ns/dcr" xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/"
    xmlns:ex="http://apache.org/cocoon/exception/1.0" xmlns:util="java:java.util.UUID"
    xmlns:zip="http://expath.org/ns/zip"
    exclude-result-prefixes="#all" version="2.0">


    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Aug 18, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> andmor</xd:p>
            <xd:p/>
            <xd:p>Reports information about a finished import operation: success -> lexicon information. Failure -> failure errors.</xd:p>
        </xd:desc>
    </xd:doc>

    
    <!--
        If success eq 'true' (and there really really really were no errors), report success, otherwise failure.
    -->
    <xsl:template match="/data">
  
            <xsl:if test="//lexus:result[@success eq 'true'] and not(//ex:exception-report)">
                <result xmlns:lexus="http://www.mpi.nl/lexus" success="true">
                    <success>true</success>
                    <xsl:apply-templates select="//lexus:result[@success eq 'true']/parent::node()"/>
                </result>
            </xsl:if>
            
   
    </xsl:template>
    
    <xsl:template match="lexus:create-lexicon[lexus:result[@success eq 'false']]">
        <message><xsl:text>Failed to create the lexicon.
</xsl:text></message>
    </xsl:template>
    
    <xsl:template match="lexus:replace-lexicon-information[lexus:result[@success eq 'false']]">
        <message><xsl:text>Failed to add lexicon information (name, description, note) the lexicon.
</xsl:text></message>
    </xsl:template>
    
    <xsl:template match="lexus:save-lexical-entries[lexus:result[@success eq 'false']]">
        <message>
            <xsl:text>Failed to insert lexical entries </xsl:text>
            <xsl:value-of select="@first"/>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="@last"/>
            <xsl:text> into the lexicon.
</xsl:text>
        </message>
    </xsl:template>
    
    <xsl:template match="ex:exception-report">
       <result xmlns:lexus="http://www.mpi.nl/lexus" success="false">
       		<success>false</success> 
       		<xsl:choose>
	       		<xsl:when test="contains(ex:message, 'ERROR')">
	       			<message><xsl:value-of select="ex:message"/></message>
	       		
	       		</xsl:when>
	       		<xsl:otherwise>
	       			<message><xsl:text>Unknown error, you may have selected the wrong file foramt for import</xsl:text></message>
	       		</xsl:otherwise>	
	       	</xsl:choose>
       		
       
       </result>
        
    </xsl:template>
    
    
    <!--
        Export some info about the lexicon for the UI.
    -->
    
    <xsl:template match="lexus:replace-lexicon-information[lexus:result[@success eq 'true']]">
        <lexicon>
            <xsl:apply-templates select="../lexicon-information/node()"/>
            <numberOfEntries><xsl:value-of select="sum(../lexus:save-lexical-entries/@count)"></xsl:value-of></numberOfEntries>
        </lexicon>
    </xsl:template>
    
	<xsl:template match="lexus:save-sortorder[lexus:result[@success eq 'true']]">
		<sortorder>
			<xsl:apply-templates select="../sortorder-info/node()"/>
		</sortorder>
	</xsl:template>
    
    
    <xsl:template match="lexus:create-lexicon[lexus:result[@success eq 'true']]"/>
    <xsl:template match="lexus:add-standard-views[lexus:result[@success eq 'true']]"/>
    <xsl:template match="lexus:save-lexical-entries[lexus:result[@success eq 'true']]"/>
    <xsl:template match="lexus:update-sort-keys[lexus:result[@success eq 'true']]"/>
    
    <xsl:template match="lexus:lexicon">
        <size>
            <xsl:value-of select="count(lexus:lexical-entry)"/>
        </size>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
</xsl:stylesheet>