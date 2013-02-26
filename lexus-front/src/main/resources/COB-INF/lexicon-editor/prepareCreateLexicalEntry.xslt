<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <!-- 
        {
        "parameters": {"id": "MmM5MDkwYTIxMmQ2N2UzNjAxMTJmNmE2OTI5NTA3MTQ="},
        "id": "F3E6B50D-1FD9-A6B3-BE57-3516797ABB8A",
        "requester": "LexiconBrowser1003"
        }
    -->
    <xsl:template match="json">
        <!-- 
            Create Lexical Entry.
        -->
        <lexus:create-lexical-entry lexicon="{parameters/id}">
        </lexus:create-lexical-entry>
    </xsl:template>

</xsl:stylesheet>
