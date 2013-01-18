<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        <data>
        <get-data>
        <id>25</id>
        </get-data>
        <user>...</user>
        </data>
        
        Generate the following information from the database:
        <result lexicon="...">
            <data id="uuid:d99c60dd-f316-4919-b18e-0e50556c45ec" schema-refd="uuid:9e1dbc3c-55d1-4ba2-96b8-391f779a16ab" ...>
                <value></value>
                ....
            </data>
        </result>
    -->
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>

    <xsl:template match="lexus:get-data-elements">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
                <lexus:text>
                    <xsl:call-template name="declare-namespace"/> 
                    
                    let $ids := <xsl:apply-templates select="." mode="encoded"/>
                    let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                    let $lexica := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user/@ref = $user-id]
                    let $data := $lexica/lexicon//data[@id = $ids]
                    
                    return element result {
                        element ids {$ids},
                        $data
                    }
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
