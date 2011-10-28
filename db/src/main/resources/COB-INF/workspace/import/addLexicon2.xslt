<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:json="http://apache.org/cocoon/json/1.0"
    xmlns:util="java:java.util.UUID" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="endpoint"/>
    <xsl:param name="lexica-collection"/>

    <xsl:template match="/">
        <rest:request target="{$endpoint}" method="PUT">
            <rest:header name="Content-Type" value="application/xml"/>
            <rest:body>
                <query xmlns="http://exist.sourceforge.net/NS/exist">
                    <text>                        
                        <xsl:call-template name="declare-namespace"/>
                        
                        declare function lexus:addLexicon() as node() {
                            let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                            let $id :=  util:uuid()
                            let $contents :=
                            <![CDATA[
                                <lexus id="{$id}">]]>
                                    <xsl:apply-templates select="/" mode="encoded"/>
                            <![CDATA[<meta>
                                        <owner ref="{$user/@id}"/>
                                        <users>
                                            <user ref="{$user/@id}">
                                                <permissions>
                                                    <lexicon>
                                                        <read>true</read>
                                                        <write>true</write>
                                                    </lexicon>
                                                </permissions>
                                            </user>
                                        </users>
                                    </meta>
                                </lexus>
                            ]]>
                            
                            let $path := xmldb:store('<xsl:value-of select="$lexica-collection"/>', $id, $contents)
                        
                            return element result
                            {
                                for $lexicon in $contents/lexus
                                    return element lexicon
                                        {$lexicon/@*,
                                        $lexicon/lexicon/lexiconInformation,
                                        $lexicon/meta,
                                        element size {count($lexicon/lexicon/lexicalEntry)}},
                                $user
                            }
                        };

                        lexus:addLexicon()
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>
    
</xsl:stylesheet>
