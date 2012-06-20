<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:get-all-lexicon-ids">
        <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>                        
                
                element lexica {
                    for $lexus in collection('<xsl:value-of select="$lexica-collection"/>')/lexus
                        return element lexus {$lexus/@*}
                }
            </lexus:text>
        </lexus:query>
    </xsl:template>

</xsl:stylesheet>
