<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="java:java.util.UUID"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <xsl:template match="/lexus:templates">
    	<object>
			<array key="templates">
				<xsl:apply-templates/>
			</array>
		</object>
	</xsl:template>
	<xsl:template match="lexus:template">
     <object>
     	<string key="name"><xsl:value-of select="@name"/> 
		</string>
		<string key="description"><xsl:value-of select="@description"/> 
		</string>
		<xsl:if test="lexus:export">
			<array key="export">
				<xsl:apply-templates select="lexus:export" mode="template"/>
    		</array>
    	</xsl:if>    
     </object>
     </xsl:template>
     <xsl:template match="lexus:export" mode="template">	
	 <object>	
		<string key="id"><xsl:value-of select="@id"/></string>
		<string key="name"><xsl:value-of select="@name"/></string>
		<string key="description"><xsl:value-of select="@description"/></string>
	</object>
	</xsl:template>
     
     
</xsl:stylesheet>
