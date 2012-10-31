<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 31, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> andmor</xd:p>
            <xd:p>Process a vicos entry URL request to a JSON response.</xd:p>
        </xd:desc>
    </xd:doc>

    <!--
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


    <xsl:template match="/">
        <object>
            <xsl:apply-templates select="data/result"/>
            <object key="status">
                <xsl:choose>
                    <xsl:when test="not(data/result/url = '')">
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
            <string key="url">
				<xsl:value-of select="./url/text()"/>
            </string>
        </object>
    </xsl:template>
    
</xsl:stylesheet>