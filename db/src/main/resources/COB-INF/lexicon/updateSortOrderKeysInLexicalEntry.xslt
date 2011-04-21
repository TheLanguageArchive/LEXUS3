<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    <xsl:include href="../util/sort-order.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:update-sort-order-keys-in-lexical-entry">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
              
              <!--             
                  Save a Lexical Entry.                
                -->
              <lexus:text>
                  
                  (: <xsl:value-of select="base-uri(document(''))"/> :)
                  <xsl:call-template name="declare-namespace"/>
                  <xsl:call-template name="permissions"/>
                  <xsl:call-template name="sort-order">
                      <xsl:with-param name="sortorders" select=".//sortorder"/>
                  </xsl:call-template>
                  
                  let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                  let $lexiconId:= '<xsl:value-of select="@lexicon"/>'
                  let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                  let $leId := '<xsl:value-of select="lexical-entry/@id"/>'
                  return 
                      if (lexus:canWrite($lexus/meta, $user))
                          then lexus:sort-order-processLexicalEntryChanged($lexiconId, $leId, $user/@id) 
                          else ()
              </lexus:text>
              </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
