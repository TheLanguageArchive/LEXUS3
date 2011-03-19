<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:template name="sort-order">       
        
        
        (: replace all characters in $data that match a regex in the sort order $som :)
        declare function lexus:replaceMatchingCharacters($data as xs:string, $som as item()*) as xs:string {
            if (empty($som))
                then $data
                else
                    let $mapping := subsequence($som, 1, 1)
                    return replace(lexus:replaceMatchingCharacters($data, remove($som, 1)), $mapping/from, $mapping/@pos)
        };
        
        
        (: Calculate the sort key for a data value, see Lexus Architecture document, Appendix A,
            data is the string we calculate the sort key for,
            x is the number of characters that is used for calculating the sort key,
            size is the number of digits to use in the sort key per character
            som contains the sort-order mappings as defined by the Lexus user
            Example:
            -in: 
            $data = "test"
            $som = Sort Order Mapping
            $y = 27 (number of mappings + 1)
            $x = 40 (use 20 characters from data/value * sizeof(value-of($y)))
            $zero = "0000000000000000000000000000000000000000"
            
            -out
            "2005192000000000000000000000000000000000" which is the sort order key for "test" (depends
            on the sort order of course, it's an example).
        :)
        declare function lexus:getSortorderKey($data as xs:string, $som as item()*, $y as xs:integer, $size as xs:integer, $zeroes as xs:string) as xs:string {
            let $replacedData := replace(lexus:replaceMatchingCharacters($data, $som), "\D", string($y))
            return substring(concat($replacedData, $zeroes), 1, $size)
        };
        

        (: Process one data node :)
        declare updating function lexus:processDataNode($data as node(), $som as item()*, $y, $size, $zeroes) {
            let $sok := lexus:getSortorderKey(data($data/value), $som, $y, $size, $zeroes)
            return
                if ($data/@sort-key)
                    then replace value of node $data/@sort-key with $sok
                    else insert node attribute sort-key { $sok } into $data
        };
        
        (: Process a sequence of data nodes :)
        declare updating function lexus:processDataNodes($data as node()*, $sort-order as node()) {
            let $x := 20             (: number of characters of data value to use in calculation :)
            let $y := count($sort-order/mappings/mapping) + 1    (: nr of mappings (...+1 is used for characters that have no mapping) :)
            let $sizeOfCharacterMapping := string-length(string($y))
            let $ppso := lexus:preProcessSortorder($sort-order/mappings/mapping, $sizeOfCharacterMapping)
            let $zero := substring("0000", 5 - $sizeOfCharacterMapping)
            let $zeroes := string-join(for $i in 1 to ($x * $sizeOfCharacterMapping) return '0','')
            for $d in $data return lexus:processDataNode($d, $ppso, $y, ($x * $sizeOfCharacterMapping), $zeroes)
        };
        
        
        (:
            Calculate exact string for each position, e.g. 01, 02, 03, 04, 05, etc.
            Also preprocess the matching regex expression by adding ([ and ]) around it.
        :)
        declare function lexus:preProcessSortorder($som as item()*, $size as xs:decimal) as item()* {
            for $mapping at $pos in $som
                return element mapping {
                    attribute pos { substring(concat("0000", $pos), 5 + string-length(string($pos)) - $size) },
                    $mapping/to,
                    element from { concat('([', $mapping/from, '])') }
                }
        };
        
        
        (: A sort order has changed, so all data nodes in all lexica using it must be updated :)
        declare updating function lexus:sort-order-processAllData($sortOrderId as xs:string, $userId as xs:string) {
            let $so := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]/workspace/sortorders/sortorder[@id eq $sortOrderId]
            let $schemaRefs := collection('<xsl:value-of select="$lexica-collection"/>')/lexus/meta/schema//container[@sort-order eq $sortOrderId]/@id
            let $data := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user[@ref eq $userId]]/lexicon/lexical-entry//data[@schema-ref = $schemaRefs]
            return lexus:processDataNodes($data, $so)
        };

        (: A schema changed, so process all data from the lexicon that have a sort order :)
        declare updating function lexus:sort-order-processSchemaChanged($lexiconId as xs:string, $userId as xs:string) {
            let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
            let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
            let $sortOrderIds := distinct-values($lexus/meta/schema//container[@sort-order ne '']/@sort-order)
            return for $sortOrderId in $sortOrderIds
                      let $data := $lexus/lexicon[@id eq $lexiconId]//data[@schema-ref = $lexus/meta/schema//container[@sort-order eq $sortOrderId]/@id]
                      return lexus:processDataNodes($data, $user/workspace/sortorders/sortorder[@id eq $sortOrderId])
        };


        (: A schema changed, so select the chunk of lexical entries and process all data that have a sort order :)
        declare updating function lexus:sort-order-processSchemaChanged($lexiconId as xs:string, $userId as xs:string, $start, $chunk-size) {
            let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
            let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
            let $les := $lexus/lexicon/lexical-entry[position() ge $start][position() lt ($start + $chunk-size)]
            let $sortOrderIds := distinct-values($lexus/meta/schema//container[@sort-order ne '']/@sort-order)
            return for $sortOrderId in $sortOrderIds
                let $data := $les//data[@schema-ref = $lexus/meta/schema//container[@sort-order eq $sortOrderId]/@id]
                return lexus:processDataNodes($data, $user/workspace/sortorders/sortorder[@id eq $sortOrderId])
        };

        (: A schema changed, so process all data from the lexicon that have a sort order :)
        declare updating function lexus:sort-order-processLexicalEntryChanged($lexiconId as xs:string, $leId as xs:string, $userId as xs:string) {
            let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
            let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
            let $sortOrderIds := distinct-values($lexus/meta/schema//container[@sort-order ne '']/@sort-order)
            return
                for $sortOrderId in $sortOrderIds
                    let $data := $lexus/lexicon[@id eq $lexiconId]/lexical-entry[@id eq $leId]//data[@schema-ref = $lexus/meta/schema//container[@sort-order eq $sortOrderId]/@id]
                    return lexus:processDataNodes($data, $user/workspace/sortorders/sortorder[@id eq $sortOrderId])
        
        };
    </xsl:template>
    
</xsl:stylesheet>
