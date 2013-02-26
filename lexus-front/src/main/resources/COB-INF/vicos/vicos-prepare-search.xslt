<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:util="java:java.util.UUID" exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Transform a wordlist request to a query.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:include href="../util/identity.xslt"/>

    <!-- 
        
        <REQUEST:=    
            {"parameters":
                {"id":"uuid:2c9090a212d67e360112f6a690060711",
                 "dataCategory_id":"uuid:2c9090a212d67e360112f6a69005070b",
                 "startLetter":"A",
                 "condition":"begins with",
                 "pageNumber":0,
                 "pageSize":20}
            }
        
        
        Return the proper query format.
    -->

    <xsl:template match="json">
        <lexus:search>
            <query id="no-id" name="vicos-wordlist" description="generated from vicos wordlist request">
                <expression>
                    <lexicon id="{parameters/id}" name="name unknown in vicos wordlist request">
                        <datacategory schema-ref="{parameters/dataCategory_id}" name="name unknown in vicos wordlist request"
                            value="{parameters/startLetter}" condition="{parameters/condition}"
                            negation="false">
                        </datacategory>
                    </lexicon>
                </expression>
            </query>
            <refiner>
            	<startLetter><xsl:value-of select="parameters/startLetter"/></startLetter>
                <startPage><xsl:value-of select="parameters/pageNumber"/></startPage>
                <pageSize><xsl:value-of select="parameters/pageSize"/></pageSize>
            </refiner>
        </lexus:search>
    </xsl:template>

</xsl:stylesheet>
