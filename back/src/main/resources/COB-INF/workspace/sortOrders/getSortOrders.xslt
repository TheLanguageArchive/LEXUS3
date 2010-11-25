<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="users-collection"/>

    <xsl:template match="/">
        <xsl:copy>
<!--            <xsl:apply-templates select="@*"/>-->
            <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>
                
                let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                return collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]/workspace/sortorders
            </lexus:text>
            <properties>
                <property name="pretty-print" value="no"/>
            </properties>
            </lexus:query>
            </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
