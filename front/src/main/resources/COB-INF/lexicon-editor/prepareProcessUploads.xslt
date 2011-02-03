<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:process-upload="http://www.mpi.nl/lexus/process-upload/1.0"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="multimedia">
                <!-- 
                    <multimedia>
                    <value>38d44d77-e357-463a-9fa0-9d4f7694d331</value>
                    <archive>local</archive>
                    <type>upload</type>
                    <fragmentIdentifier>null</fragmentIdentifier>
                    <url>null</url>
                    </multimedia>
                    -->
        <process-upload:to-resource value="{value}" archive="{archive}" type="{type}" fragmentIdentifier="{if (fragmentIdentifier eq 'null') then '' else fragmentIdentifier}" url="{if (url eq 'null') then '' else url}"/>
    </xsl:template>
</xsl:stylesheet>
