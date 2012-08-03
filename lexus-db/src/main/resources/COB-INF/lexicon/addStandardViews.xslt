<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xquery="xquery-dialect"
    xmlns:util="java:java.util.UUID"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:variable name="standard-views">
        <views listView="{$listView}" lexicalEntryView="{$lexicalEntryView}">
            <view id="{$listView}" name="List view"
                description="This view has been generated during import. It is used when displaying a list of entries in the lexicon editor."
                type="dsl_view">
                <style/>
                <structure isBranch="true">
                    <show type="dsl_show" name="Decorator" color="0x333333" fontSize="12"
                        fontFamily="Arial" isBranch="true" dsl_class="lexeme" optional="false"
                        localStyle="true">
                        <data id="{$lexemeId}" name="Lexeme" type="data category"
                            isBranch="false"/>
                    </show>
                </structure>
            </view>
            <view id="{$lexicalEntryView}" type="dsl_view" isBranch="true" name="Lexical Entry view" description="This view has been generated during import. It is used when displaying one entry in the lexicon editor.">
                <style isBranch="false">
.lexeme {
  font-family: Arial;
  font-weight: bold;
  font-size: 20pt;
  color:#333333;
}
.base {
}
      </style>
                <structure isBranch="true" dsl_class="base">
                    <show optional="false" isBranch="true" type="dsl_show" name="Container" dsl_class="lexeme" localStyle="false">
                        <data isBranch="false" type="data category" name="Lexeme" id="{$lexemeId}"/>
                    </show>
                </structure>
            </view>
        </views>
    </xsl:variable> 
    
    <xsl:template match="lexus:add-standard-views">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
                <lexus:query>
                
                <!--             
                    Add the standard views when needed.                
                  -->
                <lexus:text>
                    
                    (: <xsl:value-of select="base-uri(document(''))"/> :)
                    <xsl:call-template name="declare-namespace"/>
                    declare namespace dcr="http://www.isocat.org/ns/dcr";
                    declare namespace mdf="http://lexus.mpi.nl/datcat/mdf/";
                    
                    <xsl:call-template name="permissions"/>
                    
                    (: add the views :)
                    <xquery:declare-updating-function/> lexus:addStandardViews($lexus, $standard-views as node()) {
                        (
                            <xquery:insert-into>
                                <xquery:node>$standard-views</xquery:node>
                                <xquery:into>$lexus/meta</xquery:into>
                            </xquery:insert-into>
                        )
                    };
                    
                    let $userId := '<xsl:value-of select="@user"/>'
                    let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id = $userId]
                    let $lexiconId := '<xsl:value-of select="@lexicon"/>'
                    let $lexicon := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $lexiconId]
                    (: new ids for new views :)
                    let $listView := concat('uuid:','<xsl:value-of select="util:toString(util:randomUUID())"/>')
                    let $lexicalEntryView := concat('uuid:','<xsl:value-of select="util:toString(util:randomUUID())"/>')
                    (: determine lexeme id :)
                    let $lexeme :=
                        if (
                            exists($lexicon/meta//container[@type = 'data'][@dcr:datcat = 'http://www.isocat.org/datcat/DC-3723'])
                        ) then (
                            (: /lexeme/ datcat :)
                            ( ($lexicon/meta//container[@type = 'data'][@dcr:datcat = 'http://www.isocat.org/datcat/DC-3723'])[1]/@id,
                              ($lexicon/meta//container[@type = 'data'][@dcr:datcat = 'http://www.isocat.org/datcat/DC-3723'])[1]/@name )
                        ) else (
                            if (
                                exists($lexicon/meta//container[@type = 'data'][@mdf:marker = 'lx'])
                            ) then (
                                (: original \lx MDF marker :)
                              ( ($lexicon/meta//container[@type = 'data'][@mdf:marker = 'lx'])[1]/@id,
                                ($lexicon/meta//container[@type = 'data'][@mdf:marker = 'lx'])[1]/@name )
                            ) else (
                                if (
                                    exists($lexicon/meta//container[@type = 'data'][lower-case(@name) = 'lexeme'])
                                ) then (
                                    (: /lexeme/ LEXUS data category :)
                                    ( ($lexicon/meta//container[@type = 'data'][lower-case(@name) = 'lexeme'])[1]/@id,
                                      ($lexicon/meta//container[@type = 'data'][lower-case(@name) = 'lexeme'])[1]/@name )
                                ) else (
                                    if (
                                        exists($lexicon/meta//container[@type = 'data'][lower-case(@name) = 'headword'])
                                    ) then (
                                        (: /headword/ LEXUS data category :)
                                        ( ($lexicon/meta//container[@type = 'data'][lower-case(@name) = 'headword'])[1]/@id,
                                          ($lexicon/meta//container[@type = 'data'][lower-case(@name) = 'headword'])[1]/@name )
                                    ) else (
                                        (: first LEXUS data category :)
                                        ( ($lexicon/meta//container[@type = 'data'])[1]/@id,
                                          ($lexicon/meta//container[@type = 'data'])[1]/@name )
                                    )
                                )
                            )
                        )
                        let $lexemeId := $lexeme[1]
                        let $lexemeName := $lexeme[2]
                        
                        
                        
                        (: the standard views :)
                        let $standard-views := element views {  attribute listView { $listView },
                 attribute lexicalEntryView { $lexicalEntryView },
                element view {  attribute id { $listView },
                 attribute name { "List view" },
                 attribute description { "This view has been generated during import. It is used when displaying a list of entries in the lexicon editor." },
                 attribute type { "dsl_view" },
                element style {  },
                element structure {  attribute isBranch { "true" },
                element show {  attribute type { "dsl_show" },
                 attribute name { "Decorator" },
                 attribute color { "0x333333" },
                 attribute fontSize { "12" },
                 attribute fontFamily { "Arial" },
                 attribute isBranch { "true" },
                 attribute optional { "false" },
                 attribute localStyle { "true" },
                element data {  attribute id { $lexemeId },
                 attribute name { $lexemeName },
                 attribute type { "data category" },
                 attribute isBranch { "false" } } } } },
                element view {  attribute id { $lexicalEntryView },
                 attribute type { "dsl_view" },
                 attribute isBranch { "true" },
                 attribute name { "Lexical Entry view" },
                 attribute description { "This view has been generated during import. It is used when displaying one entry in the lexicon editor." },
                element style {  attribute isBranch { "false" },
                 text { "
.lexeme {
  font-family: Arial;
  font-weight: bold;
  font-size: 20pt;
  color:#333333;
}
.base {
}
      " } },
                element structure {  attribute isBranch { "true" },
                 attribute dsl_class { "base" },
                element show {  attribute optional { "false" },
                 attribute isBranch { "true" },
                 attribute type { "dsl_show" },
                 attribute name { "Container" },
                 attribute dsl_class { $lexemeName },
                 attribute localStyle { "false" },
                element data {  attribute isBranch { "false" },
                 attribute type { "data category" },
                 attribute name { $lexemeName },
                 attribute id { $lexemeId } } } } } }
                    return 
                        if (lexus:canWrite($lexicon/meta, $user) and empty($lexicon/meta/views))
                            then lexus:addStandardViews($lexicon, $standard-views) 
                            else ()
                </lexus:text>
                </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
