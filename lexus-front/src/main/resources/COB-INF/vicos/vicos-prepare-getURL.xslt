<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 31, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> andmor</xd:p>
            <xd:p>Prepare ViCoS get URL request. Retrieves the URL for viewing the lexical entry with LEXUS entry viewer.</xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <!--
    INPUT:
    {"parameters":{
    				"type":"lexicalEntryInstance",
    				"id":"OTY1MTMzOTUtNzg0My00ZTkwLTg3N2EtOGU3ZTk2YWE2ZThj"
    				}
    }
    
    OUTPUT:
    {"id":"Wed Oct 31 10:58:03 CET 2012",
    	"result":{
    				"url":"http://corpus1.mpi.nl:80/mpi/lexusDojo/EntryViewer.html?id=OTY1MTMzOTUtNzg0My00ZTkwLTg3N2EtOGU3ZTk2YWE2ZThj"
    			},
    	"requester":"",
    	"status":{
    				"message":"At your service",
    				"duration":"4",
    				"insync":true,
    				"success":true
    			},
    	"requestId":""
    	}
    
    -->
        
    <xsl:param name="contextURL"/>
    <xsl:param name="requester"/>
    
    
    <xsl:template match="/">
    	<xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="json">
    	<data>
    		<result>
    			<url><xsl:value-of select="concat($contextURL, 'EntryViewer.html?id=', ./parameters/id/text())"/></url>
    		</result>
    		<requesterId><xsl:value-of select="$requester"/></requesterId>
    	</data>
    </xsl:template>
    
    
    </xsl:stylesheet>