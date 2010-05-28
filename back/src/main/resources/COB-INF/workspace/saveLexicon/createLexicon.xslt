<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0" version="2.0">

    <!-- 
        Prepare to create a new lexicon, using the JSON input:
    
    <create-lexicon>
        <lexicon id="{$id}">
            <lexicon-information>
                 <feat name="name">
                 <xsl:value-of select="/data/json/parameters/name"/>
                 </feat>
                 <feat name="description">
                 <xsl:value-of select="/data/json/parameters/description"/>
                 </feat>
                 <feat name="note">
                 <xsl:value-of select="/data/json/parameters/note"/>
                 </feat>
            </lexicon-information>
            <lexical-entries/>
        </lexicon>
        <lexus id="{$id}">
            <meta>
                <schema>                                
                </schema>
            </meta>
            <log/>
        </lexus>        
        <log id="{$id}">
        </log>
    </create-lexicon>
    
    -->

    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>

    <xsl:param name="endpoint"/>
    <xsl:param name="dbpath"/>
    <xsl:param name="username"/>
    <xsl:param name="password"/>


    <xsl:template match="/data">
        <xsl:variable name="id">
            <xsl:value-of select="substring-after(lexicon/@id, 'uuid:')"/>
        </xsl:variable>
        <rest:request target="{$endpoint}{$dbpath}/lexica" method="POST">
            <rest:header name="Content-Type" value="text/xml; charset=UTF-8"/>
            <rest:body>
                <query xmlns="http://exist.sourceforge.net/NS/exist">
                    <text>
                        <xsl:call-template name="declare-namespace"/>                       
                        <xsl:call-template name="users"/>
                        
                        let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                        
                        let $access := xmldb:authenticate('<xsl:value-of select="$dbpath"/>/lexica', '<xsl:value-of select="$username"/>', '<xsl:value-of select="$password"/>')
                        return
                            if ($access)
                            then 
                                let $lexicon := <xsl:apply-templates select="lexicon" mode="encoded"/>
                                let $lexiconSave := xmldb:store('<xsl:value-of select="$dbpath"/>/lexica', '<xsl:value-of select="$id"/>.xml', $lexicon)
                                let $lexus := <xsl:apply-templates select="lexus" mode="encoded"/>
                                let $lexusSave := xmldb:store('<xsl:value-of select="$dbpath"/>/lexica', '<xsl:value-of select="$id"/>_lexus.xml', $lexus)
                                let $log := <xsl:apply-templates select="log" mode="encoded"/>
                                let $logSave := xmldb:store('<xsl:value-of select="$dbpath"/>/lexica', '<xsl:value-of select="$id"/>_log.xml', $log)
                                let $users := lexus:users(collection('<xsl:value-of select="$dbpath"/>/users')/user[@id = distinct-values($lexus/meta/users/user/@ref)])
                                return
                                    if ($lexiconSave eq '' or $lexusSave eq '' or $logSave eq '')
                                    then element exception {'failed to create lexicon'}
                                    else element result {$lexicon, $lexus, $users, $user}
                            else 
                                element exception {'access denied for user <xsl:value-of select="$username"/>'}
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
