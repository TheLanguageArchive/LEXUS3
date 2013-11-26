<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:util="java:java.util.UUID"
    version="2.0">


    
<xsl:param name="RemoteUser" select="''"/>
    <xsl:template match="user">
        <save-user>
<!--             <xsl:if test="not(id)"> -->
<!--                 <xsl:variable name="id" select="concat('uuid:',util:toString(util:randomUUID()))"/> -->
<!--                 <id> -->
<!--                     <xsl:value-of select="$id"/> -->
<!--                 </id> -->
<!--             </xsl:if> -->
            <xsl:if test="not(shibblog)">
               <shiblog>
                    <xsl:value-of select="$RemoteUser"/>
               </shiblog>
             </xsl:if>
            <id>
                <xsl:value-of select="@id"/>
            </id>
            <xsl:apply-templates select="*"/>
<!--             <xsl:if test="not(role)"> -->
<!--                 <accesslevel>10</accesslevel> -->
<!--             </xsl:if> -->
            <workspace>
                <queries/>
                <sortorders/>
            </workspace>
        </save-user>
    </xsl:template>

    <xsl:template match="account">
        <account>
            <xsl:value-of select="."/>
        </account>
    </xsl:template>

    <xsl:template match="name">
        <name>
            <xsl:value-of select="."/>
        </name>
    </xsl:template>
    
    <xsl:template match="password">
        <password>
            <xsl:value-of select="."/>
        </password>
    </xsl:template>
    
    <xsl:template match="accesslevel">
        <accesslevel>
            <xsl:value-of select="."/>
        </accesslevel>
    </xsl:template>
    
    <xsl:template match="id">
        <id>
            <xsl:value-of select="."/>
        </id>
    </xsl:template>
    
    <xsl:template match="email">
        <email>
            <xsl:value-of select="."/>
        </email>
    </xsl:template>
    <xsl:template match="shibblog">
        <shiblog>
            <xsl:value-of select="."/>
        </shiblog>
    </xsl:template>
  
</xsl:stylesheet>
