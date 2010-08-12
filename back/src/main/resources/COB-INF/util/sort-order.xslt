<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">

    <xsl:template name="sort-order">       
        
        (: return the position of the first regex in sort order $so that matches :)
        declare function lexus:getPosition($data as xs:string, $som as item()*) as xs:integer {
            if (empty($som))
                then 0
                else
                    let $mapping := subsequence($som, 1, 1)
                    return
                        if (fn:matches($data, concat('^', $mapping)))        (: always match at the beginning, cos we're sorting :)
                           then 1
                           else 1 + lexus:getPosition($data, remove($som, 1))
        };
        
        (: raise $x to the power of $y :)
        declare function lexus:power($x as xs:integer, $y as xs:integer) as xs:integer {
            let $d := if ($y le 1) then $x else $x * lexus:power($x, $y -1)
            return $d
        };
        
        (: Calculate the sorting number for a data value, see Lexus Architecture document, Appendix A :)
        declare function lexus:calculateSortorderNumber($data as xs:string, $y as xs:integer, $x as xs:integer, $som as item()*) as xs:integer {
            if ($data ne '')
                then
                    if ($x eq 1)
                        then ($y + 1)
                        else (lexus:power(($y + 1), $x) * lexus:getPosition($data, $som)) +
                             lexus:calculateSortorderNumber(substring($data, 2), $y, $x - 1, $som)
                else 0
        };
        
        (: Process one data node :)
        declare function lexus:processDataNode($data as node(), $sort-order as node()) as xs:integer {
            let $y := count($sort-order/mappings/mapping)    (: nr of mappings :)
            let $x := 10                                     (: number of characters of data value to use in calculation :)
            return lexus:calculateSortorderNumber(data($data/value), $y, $x, $sort-order/mappings/mapping)
        };
        
        (: Process a sequence of data nodes :)
        declare function lexus:processDataNodes($data as node()*, $sort-order as node()) as node() {
            let $processedData :=
                for $d in $data return lexus:processDataNode($d, $sort-order)
                return element node { $processedData }
        };
        
        (: A sort order has changed, so all data nodes in all lexica using it must be updated :)
        declare function lexus:sort-order-processAllData($sortOrderId as xs:string, $userId as xs:string) as item() {
            let $data := collection('<xsl:value-of select="$lexica-collection"/>')/lexus/lexicon/lexical-entry//data[@schema-ref = collection('<xsl:value-of select="$lexica-collection"/>')/lexus/meta/schema/component[@sort-order eq $sortOrderId]/@id]
            return lexus:processDataNode($data, collection('<xsl:value-of select="$lexica-collection"/>')/user[@id eq $userId]/workspace/sort-orders/sort-order[@id eq $sortOrderId])
        };

        (: A schema changed, so process all data from the lexicon that have a sort order :)
        declare function lexus:sort-order-processSchemaChanged($lexiconId as xs:string, $userId as xs:string) as node() {
            let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
            let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
            let $sortOrders := distinct-values($lexus/meta/schema//component[@sort-order ne '']/@sort-order)
            return element sort-orders { for $sortOrderId in $sortOrders
                      let $data := $lexus/lexicon//data[@schema-ref = $lexus/meta/schema//component[@sort-order eq $sortOrderId]/@id]
                      return
                          if (fn:exactly-one($user/workspace/sortorders/sortorder[@id eq $sortOrderId]))
                              then lexus:processDataNodes($data, $user/workspace/sortorders/sortorder[@id eq $sortOrderId])
                              else ()
                   }
        };

    </xsl:template>
    
</xsl:stylesheet>
