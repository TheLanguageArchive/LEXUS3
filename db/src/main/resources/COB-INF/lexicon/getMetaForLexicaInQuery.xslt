<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        <data>
            <lexus:search>
                <query xmlns:json="http://apache.org/cocoon/json/1.0"
                    id="uuid:9c061431-140a-49ea-96e9-3b964fb91884">
                    <description/>
                    <name>testje 2</name>
                    <expression>
                        <lexicon id="uuid:eae8c847-4462-432e-bf95-56eae4831044"
                            name="976b83a2-7bef-4099-9e5f-04f22bd7e98f">
                            <datacategory schema-ref="uuid:6e1f2b5f-778e-4940-b054-dc8f1e0d2dec" name="Lexeme"
                                value="test" condition="is" negation="false"/>
                        </lexicon>
                    </expression>
                </query>
                <refiner>
                    <startLetter/>
                    <searchTerm/>
                    <pageSize>25</pageSize>
                    <startPage>0</startPage>
                </refiner>
            </lexus:search>
            <user>...</user>
        </data>
        
        Add lexus/meta elements inside the lexicon elements.
    -->

    <xsl:include href="../util/identity.xslt"/>

    <xsl:param name="lexica-collection"/>

    <xsl:template match="lexus:search">
        <xsl:copy-of select="."/>
        <lexus:search-lexica>
            <xsl:for-each select="query/expression/lexicon">
                <lexus:query>
                    <lexus:text>
                        (: <xsl:value-of select="base-uri(document(''))"/> :)
                        (: Returns lexus/meta element :)
                        element lexus {
                            attribute id { '<xsl:value-of select="@id"/>' },
                            collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = '<xsl:value-of select="@id"/>']/meta
                        }
                    </lexus:text>
                </lexus:query>
            </xsl:for-each>
        </lexus:search-lexica>

    </xsl:template>

</xsl:stylesheet>
