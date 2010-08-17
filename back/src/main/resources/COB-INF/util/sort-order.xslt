<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">

    <xsl:template name="sort-order">       
        
        (: return the position of the first regex in sort order $so that matches :)
        declare function lexus:getPosition($data as xs:string, $som as item()*) as xs:decimal {
            if (empty($som))
                then -1
                else
                    let $mapping := subsequence($som, 1, 1)
                    return
                        if (fn:matches($data, concat('[', $mapping/from, ']')))
                           then 1
                           else 
                               let $pos := lexus:getPosition($data, remove($som, 1))
                               return if ($pos gt 0) then 1 + $pos else $pos
        };        


        declare function lexus:pad-string-to-length($s as xs:string, $length as xs:integer) as xs:string {
            if (string-length($s) lt $length)
                then concat('0', lexus:pad-string-to-length($s, $length - 1))
                else $s
        };
        
        (: Calculate the sort key for a data value, see Lexus Architecture document, Appendix A,
            data is the string we calculate the sort key for,
            x is the number of characters that is used for calculating the sort key,
            size is the number of digits to use in the sort key per character
            som contains the sort-order mappings as defined by the Lexus user
            :)
            declare function lexus:calculateSortorderString($data as xs:string, $size as xs:decimal, $x  as xs:decimal, $som as item()*) as xs:string {
                if ($data ne '')
                    then
                        let $pos := lexus:getPosition(substring($data, 1, 1), $som)
                        let $paddedString :=
                            if ($pos eq -1)
                                then lexus:pad-string-to-length('', $size)
                                else lexus:pad-string-to-length(string($pos), $size)
                        return
                            if ($x eq 1)
                                then $paddedString 
                                else concat($paddedString,
                                    lexus:calculateSortorderString(substring($data, 2), $size, $x - 1, $som))
                    else lexus:pad-string-to-length('', $size * $x)
        };

        (: Process one data node :)
        declare updating function lexus:processDataNode($data as node(), $sort-order as node()) {
            let $y := count($sort-order/mappings/mapping)    (: nr of mappings :)
            let $x := 20                                      (: number of characters of data value to use in calculation :)
            let $sok := lexus:calculateSortorderString(data($data/value), string-length(string($y)), $x, $sort-order/mappings/mapping)
            return
                if ($data/@sort-key)
                    then replace value of node $data/@sort-key with $sok (: fn:matches($data/value, concat('^', $sort-order/mappings/mapping[1]/from)) :)
                    else insert node attribute sort-key { $sok } into $data
        };
        
        (: Process a sequence of data nodes :)
        declare updating function lexus:processDataNodes($data as node()*, $sort-order as node()) {
            for $d in $data return lexus:processDataNode($d, $sort-order)
        };
        
        (: A sort order has changed, so all data nodes in all lexica using it must be updated :)
        declare updating function lexus:sort-order-processAllData($sortOrderId as xs:string, $userId as xs:string) {
            let $so := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]/workspace/sortorders/sortorder[@id eq $sortOrderId]
            let $schemaRefs := collection('<xsl:value-of select="$lexica-collection"/>')/lexus/meta/schema//component[@sort-order eq $sortOrderId]/@id
            let $data := collection('lexus')/lexus/lexicon/lexical-entry//data[@schema-ref = $schemaRefs]
            return lexus:processDataNodes($data, $so)
        };

        (: A schema changed, so process all data from the lexicon that have a sort order :)
        declare updating function lexus:sort-order-processSchemaChanged($lexiconId as xs:string, $userId as xs:string) {
            let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
            let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
            let $sortOrders := distinct-values($lexus/meta/schema//component[@sort-order ne '']/@sort-order)
            return for $sortOrderId in $sortOrders
                      let $data := $lexus/lexicon//data[@schema-ref = $lexus/meta/schema//component[@sort-order eq $sortOrderId]/@id]
                      return
                          if (fn:exactly-one($user/workspace/sortorders/sortorder[@id eq $sortOrderId]))
                              then lexus:processDataNodes($data, $user/workspace/sortorders/sortorder[@id eq $sortOrderId])
                              else ()
        };

    </xsl:template>
    
</xsl:stylesheet>
