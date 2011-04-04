<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">

    <xsl:template name="sort-order">       
        <xsl:param name="sortorders" select="()"/>
        
        <xsl:if test="not(empty($sortorders))">    
            <xsl:apply-templates select="$sortorders" mode="xquery-functions"/>
        </xsl:if>
        
        
        <xsl:if test="not(empty($sortorders))">
            (: A sort order has changed, so all data nodes in all lexica using it must be updated :)
            declare updating function lexus:sort-order-processAllData($sortOrderId as xs:string, $userId as xs:string) {
                let $schemaRefs := collection('<xsl:value-of select="$lexica-collection"/>')/lexus/meta/schema//container[@sort-order eq $sortOrderId]/@id
                return 
                    for $d in collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user[@ref eq $userId]]/lexicon/lexical-entry//data[@schema-ref = $schemaRefs]
                        let $sok := <xsl:value-of select="concat('lexus:get-key-for-sort-order-', substring-after($sortorders[1]/@id, 'uuid:'))"/>(data($d/value))
                        let $slk := <xsl:value-of select="concat('lexus:get-start-letter-for-sort-order-', substring-after($sortorders[1]/@id, 'uuid:'))"/>(data($d/value))
                        return (
                            if (exists($d/@sort-key))
                                then replace value of node $d/@sort-key with $sok
                                else insert node attribute sort-key { $sok } into $d,
                            if (exists($d/@start-letter))
                                then replace value of node $d/@start-letter with $slk
                                else insert node attribute start-letter { $slk } into $d
                        )
            };
            
            (: A schema changed, so process all data from the lexicon that have a sort order :)
        declare updating function lexus:sort-order-processSchemaChanged($lexiconId as xs:string, $userId as xs:string) {
            let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
            let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
            return (
            <xsl:for-each select="$sortorders">
                let $schemaRefs := collection('<xsl:value-of select="$lexica-collection"/>')/lexus/meta/schema//container[@sort-order eq '<xsl:value-of select="@id"/>']/@id
                for $d in $lexus/lexicon/lexical-entry//data[@schema-ref = $schemaRefs]
                    let $sok := <xsl:value-of select="concat('lexus:get-key-for-sort-order-', substring-after(@id, 'uuid:'))"/>(data($d/value))
                    let $slk := <xsl:value-of select="concat('lexus:get-start-letter-for-sort-order-', substring-after(@id, 'uuid:'))"/>(data($d/value))
                    return (
                        if (exists($d/@sort-key))
                            then replace value of node $d/@sort-key with $sok
                            else insert node attribute sort-key { $sok } into $d,
                        if (exists($d/@start-letter))
                            then replace value of node $d/@start-letter with $slk
                            else insert node attribute start-letter { $slk } into $d
                    )
                <xsl:if test="position() lt last()"><xsl:text>, </xsl:text></xsl:if>
            </xsl:for-each>
            )
        };
        
        
        (: A schema changed, so select the chunk of lexical entries and process all data that have a sort order :)
        declare updating function lexus:sort-order-processSchemaChanged($lexiconId as xs:string, $userId as xs:string, $start, $chunk-size) {
            let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
            let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
            let $les := $lexus/lexicon/lexical-entry[position() ge $start][position() lt ($start + $chunk-size)]
            return (
            <xsl:for-each select="$sortorders">
                for $le in $les
                    for $d in $le//data[@schema-ref = $lexus/meta/schema//container[@sort-order eq '<xsl:value-of select="@id"/>']/@id]
                        let $sok := <xsl:value-of select="concat('lexus:get-key-for-sort-order-', substring-after(@id, 'uuid:'))"/>(data($d/value))
                        let $slk := <xsl:value-of select="concat('lexus:get-start-letter-for-sort-order-', substring-after(@id, 'uuid:'))"/>(data($d/value))
                        return (
                            if (exists($d/@sort-key))
                                then replace value of node $d/@sort-key with $sok
                                else insert node attribute sort-key { $sok } into $d,
                            if (exists($d/@start-letter))
                                then replace value of node $d/@start-letter with $slk
                                else insert node attribute start-letter { $slk } into $d
                        )
                <xsl:if test="position() lt last()"><xsl:text>, </xsl:text></xsl:if>
            </xsl:for-each>
            )
        };
        
        
            (: A lexical entry was updated, so process all data from the lexical entry that have a sort order :)
        declare updating function lexus:sort-order-processLexicalEntryChanged($lexiconId as xs:string, $leId as xs:string, $userId as xs:string) {
            let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
            let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
            return (
                <xsl:for-each select="$sortorders">
                    for $d in $lexus/lexicon[@id eq $lexiconId]/lexical-entry[@id eq $leId]//data[@schema-ref = $lexus/meta/schema//container[@sort-order eq '<xsl:value-of select="@id"/>']/@id]
                        let $sok := <xsl:value-of select="concat('lexus:get-key-for-sort-order-', substring-after(@id, 'uuid:'))"/>(data($d/value))
                        let $slk := <xsl:value-of select="concat('lexus:get-start-letter-for-sort-order-', substring-after(@id, 'uuid:'))"/>(data($d/value))
                        return (
                            if (exists($d/@sort-key))
                                then replace value of node $d/@sort-key with $sok
                                else insert node attribute sort-key { $sok } into $d,
                            if (exists($d/@start-letter))
                                then replace value of node $d/@start-letter with $slk
                                else insert node attribute start-letter { $slk } into $d
                        )
                    <xsl:if test="position() lt last()"><xsl:text>, </xsl:text></xsl:if>
                </xsl:for-each>
            )        
        };
        </xsl:if>
    </xsl:template>
    
    
    <!--
        Add precalculated xquery functions for generating sort-key and start-letter.
        -->
    <xsl:template match="sortorder" mode="xquery-functions">
        <xsl:value-of select="xquery/functions"/>
    </xsl:template>
    
</xsl:stylesheet>
