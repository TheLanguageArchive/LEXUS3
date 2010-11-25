<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    
    <xsl:param name="users-collection"/>

    <xsl:template match="/">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            <lexus:text>
                let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                let $users := for $user in collection('<xsl:value-of select="$users-collection"/>/users')/user
                    order by $user/name
                    return $user
                return element result { element users { $users } }
            </lexus:text>
        </lexus:query></xsl:copy>
    </xsl:template>

</xsl:stylesheet>
