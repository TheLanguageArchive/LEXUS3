<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="java:java.util.UUID"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:template match="data">
        <xsl:copy>
            <lexus:delete-user>
                <user id="{json/parameters/id}"/>
            </lexus:delete-user>
            <xsl:copy-of select="json|user"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
