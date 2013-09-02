<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="java:java.util.UUID"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
  
   <xsl:variable name="templateId" select="/data/json/parameters"/>
   
       
    <xsl:template match="text()"/>
    <xsl:template match="//lexus:templates">
    	<object>
			<array key="exports">
				<xsl:apply-templates/>
			</array>
		</object>
	</xsl:template>
	
	<xsl:template match="lexus:template[@id=$templateId]/lexus:export">
	
  
     <object>
     	<string key="name"><xsl:value-of select="@name"/> 
		</string>
		<string key="description"><xsl:value-of select="@description"/> 
		</string>
		<string key="format"><xsl:value-of select="@id"/> 
		</string>
        </object>
 
	</xsl:template>
	
</xsl:stylesheet>
