<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>

    <xsl:template match="lexus:get-data">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
                <lexus:text>
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                    <xsl:call-template name="declare-namespace"/> 
                    
                    let $id := '<xsl:value-of select="/data/lexus:get-data/id"/>'
                    let $lexicon-id := '<xsl:value-of select="/data/lexus:get-data/lexicon"/>'
                    let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                    let $data :=
                        if ($lexicon-id ne '' and $lexicon-id ne 'undefined')
                            then collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $lexicon-id]//data[@id = $id]
                            else
                                let $lexica := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user/@ref = $user-id]
                                return $lexica/lexicon//data[@id = $id]
                    
                    return element result {
                        attribute lexicon { $lexicon-id },
                        $data
                    }
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
