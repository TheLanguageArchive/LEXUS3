<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:template name="sort-order">       
        
        (: return the position of the first regex in sort order $so that matches :)
        declare function lexus:getPosition($data as xs:string, $som as item()*, $zero as xs:string) as xs:string {
            if (empty($som))
                then $zero
                else
                    let $mapping := subsequence($som, 1, 1)
                    return
                        if (fn:matches($data, $mapping/from))
                           then $mapping/@pos
                           else 
                               lexus:getPosition($data, remove($som, 1), $zero)
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
        declare function lexus:calculateSortorderString($data as xs:string, $x as xs:decimal, $som as item()*, $zero as xs:string) as xs:string {
                if ($data ne '')
                    then
                        let $pos := lexus:getPosition(substring($data, 1, 1), $som, $zero)
                        return
                            if ($x eq 1)
                                then $pos 
                                else concat($pos,
                                    lexus:calculateSortorderString(substring($data, 2), $x - 1, $som, $zero))
                else string-join((for $i in 1 to $x return $zero), '')
        };

        (:
            Calculate exact string for each position, e.g. 01, 02, 03, 04, 05, etc.
            Also preprocess the matching regex expression by adding [] around it.
        :)
        declare function lexus:preProcessSortorder($som as item()*, $size as xs:decimal) as item()* {
            for $mapping at $pos in $som
                return element mapping {
                    attribute pos { lexus:pad-string-to-length(string($pos), $size) },
                    $mapping/to,
                    element from { concat('[', $mapping/from, ']') }
                }
        };


        (: Process one data node :)
        declare updating function lexus:processDataNode($data as node(), $som as item()*, $zero) {
            let $x := 20             (: number of characters of data value to use in calculation :)
            let $sok := lexus:calculateSortorderString(data($data/value), $x, $som, $zero)
            return
                if ($data/@sort-key)
                    then replace value of node $data/@sort-key with $sok
                    else insert node attribute sort-key { $sok } into $data
        };
        
        (: Process a sequence of data nodes :)
        declare updating function lexus:processDataNodes($data as node()*, $sort-order as node()) {
            let $y := count($sort-order/mappings/mapping)    (: nr of mappings :)
            let $size := string-length(string($y))
            let $ppso := lexus:preProcessSortorder($sort-order/mappings/mapping, $size)
            let $zero := lexus:pad-string-to-length('', $size)
            for $d in $data return lexus:processDataNode($d, $ppso, $zero)
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
                      (:
                          if (fn:exactly-one($user/workspace/sortorders/sortorder[@id eq $sortOrderId]))
                              then lexus:processDataNodes($data, $user/workspace/sortorders/sortorder[@id eq $sortOrderId])
                              else ()
                              :)
        };

    </xsl:template>
    
</xsl:stylesheet>
