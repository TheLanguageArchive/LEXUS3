<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="data">
        <xsl:copy>
            <xsl:apply-templates select="json"/>
            <xsl:copy-of select="user"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="json">
        <lexicon>
            <xsl:apply-templates select="parameters/*"/>
            <meta>
                <users>
                    <xsl:for-each-group group-by="id"
                        select="parameters//readers | parameters//writers">
                        <xsl:if test="not(preceding-sibling::*[id eq current()/id])">
                            <user ref="{id}">
                                <permissions>
                                    <xsl:apply-templates
                                        select="//json/parameters//readers[id eq current()/id]"/>
                                    <xsl:apply-templates
                                        select="//json/parameters//writers[id eq current()/id]"/>
                                </permissions>
                            </user>
                        </xsl:if>
                    </xsl:for-each-group>
                </users>
            </meta>
        </lexicon>
    </xsl:template>

    <!-- 
        Cast readers & writers to the right format for the database.
    -->
    <xsl:template match="readers/readers | readers[not(readers)]" priority="1">
        <read>true</read>
    </xsl:template>
    <xsl:template match="writers/writers | writers[not(writers)]" priority="1">
        <write>true</write>
    </xsl:template>
    <xsl:template match="parameters/readers"/>
    <xsl:template match="parameters/writers"/>

</xsl:stylesheet>
