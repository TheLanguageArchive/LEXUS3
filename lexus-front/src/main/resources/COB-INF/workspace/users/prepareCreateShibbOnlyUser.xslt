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

    
    <xsl:param name="RemoteUser" select="''"/>

    <xsl:variable name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/>

    <xsl:template match="/">
    	<data>
         <lexus:create-user>
                        <user>
                            <xsl:attribute name="id" select="$id"/>
                            <account>
                                <xsl:value-of select="$RemoteUser"/>
                            </account>
                            <shiblog>
                            	<xsl:value-of select="$RemoteUser"/>
                            </shiblog>
                            <accesslevel>
                                <xsl:value-of select="10"/>
                            </accesslevel>
                                <workspace>
                                <queries/>
                                <sortorders/>
                            </workspace>
                        </user>
           </lexus:create-user>             
        </data>
    </xsl:template>
</xsl:stylesheet>
