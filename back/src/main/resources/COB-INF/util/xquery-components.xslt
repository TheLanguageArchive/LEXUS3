<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:json="http://apache.org/cocoon/json/1.0" version="2.0">


    <xsl:template name="declare-namespace">
        declare namespace lexus="http://www.mpi.nl/lat/lexus";
    </xsl:template>
    
    <xsl:template name="users">
        declare function lexus:user-sequence($users as element()*)  as element()* {
            for $user in $users
                order by $user/name
                return element user {$user/@*, $user/*[local-name() = ('name', 'account', 'accesslevel', 'workspace')] }
        };
        declare function lexus:users($users as element()*)  as element()* {
            element users {lexus:user-sequence($users)}
        };
    </xsl:template>
    
</xsl:stylesheet>
