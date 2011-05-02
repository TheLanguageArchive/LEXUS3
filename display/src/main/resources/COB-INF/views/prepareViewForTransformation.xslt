<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="lexus:get-listview | lexus:get-leview | lexus:get-view">
        <lexus:display>
            <xsl:choose>
                <xsl:when test="lexus:result/view">
                    <xsl:apply-templates select="lexus:result/view"/>
                </xsl:when>
                <xsl:otherwise>
                    
                        <style isBranch="false"/>
                        <structure isBranch="true">
                            <show optional="false" isBranch="true" type="dsl_show" name="Container">
                                <text value="Please create an appropriate view in the Schema Editor" isBranch="false" type="dsl_text" name="text"/>
                            </show>
                        </structure>
                    
                </xsl:otherwise>
            </xsl:choose>
        </lexus:display>
    </xsl:template>

    <xsl:template match="view">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
