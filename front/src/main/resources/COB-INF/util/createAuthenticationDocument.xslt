<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

    <!-- 
        Create a valid authentication element for the cauth framework.
    -->
    <xsl:template match="/">
        <authentication>
            <ID>
                <xsl:value-of select="/user/@id"/>
            </ID>
            <data>
                <user-id>
                    <xsl:value-of select="/user/@id"/>
                </user-id>
                <xsl:apply-templates select="/user/account | /user/name | /user/accesslevel "/>
            </data>
        </authentication>
    </xsl:template>

    <xsl:template match="account">
        <user-account>
            <xsl:value-of select="."/>
        </user-account>
    </xsl:template>
    <xsl:template match="name">
        <user-name>
            <xsl:value-of select="."/>
        </user-name>
    </xsl:template>
    <xsl:template match="accesslevel">
        <user-accesslevel>
            <xsl:value-of select="."/>
        </user-accesslevel>
    </xsl:template>
</xsl:stylesheet>
