<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" version="2.0">

    <xsl:template name="sort-order">       
        
        
        (: return a sequence of the characters of the sort order in the right order, for one mapping :)
        declare function lexus:getCharacters($s as xs:string) {
            ()
        };
        
        (: return a sequence of the characters of the sort order in the right order, for all mappings :)
        declare function lexus:getMappings($mps as node()*) {
            if (empty($so)) then ()
            else
               let $mapping := subsequence($so, 1, 1)
               return (lexus:getCharacters($mapping), lexus:getMappings(remove($mps, 1)))
        };
        
        (: raise $x to the power of $y :)
        declare function lexus:power($x as xs:integer, $y as xs:integer) {
            if ($y le 1) then $x else $x * lexus:power($x, $y -1)
        };
        
        (: Calculate the sorting number for a data value, see Lexus Architecture document, Appendix A :)
        declare function lexus:calculateSortorderNumber($data as xs:string, $y, $x) as xs:integer {
            if ($data ne '')
            then
                if ($x eq 1)
                    then ($y + 1)
                    else lexus:power(($y + 1), $x) + lexus:calculateSortorderNumber(substring($data, 2), $y, $x - 1)
            else 0
        };
        
        (: Process one data node :)
        declare function lexus:processDataNode($data as node(), $sort-order as node()) as xs:integer {
            let $y := count($sort-order/mappings/mapping)    (: nr of mappings :)
            let $x := 4                                     (: number of characters of data value to use in calculation :)
            return lexus:calculateSortorderNumber($data, $y, $x, lexus:getMappings($sort-order/mappings/mapping))
        };
        
        (: Process a sequence of data nodes :)
        declare function lexus:processDataNodes($data as node()*, $sort-order as node()) as item()* {
            let $data := for $d in $data return lexus:processDataNode($d, $sort-order)
            return element sn { $sort-order, $data }
        };
        
        (: A sort order has changed, so all data nodes in all lexica using it must be updated :)
        declare function lexus:sort-order-processAllData($sortOrderId as xs:string, $userId as xs:string) as item() {
            let $data := collection('<xsl:value-of select="$lexica-collection"/>')/lexicon/lexical-entry//data[@ref = collection('<xsl:value-of select="$lexica-collection"/>')/lexus/meta/schema/component[@sort-order eq $sortOrderId]/@id]
            return lexus:processDataNode($data, collection('<xsl:value-of select="$lexica-collection"/>')/user[@id eq $userId]/workspace/sort-orders/sort-order[@id eq $sortOrderId])
        };

        (: A schema changed, so process all data from the lexicon that have a sort order :)
        declare function lexus:sort-order-processSchemaChanged($lexiconId as xs:string, $userId as xs:string) as item()* {
            let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
            let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
            let $lexicon := collection('<xsl:value-of select="$lexica-collection"/>')/lexicon[@id eq $lexiconId]
            let $sortOrders := distinct-values($lexus/meta/schema//component[@sort-order ne '']/@sort-order)
            return element sort-orders { $lexus, $lexicon, for $sortOrderId in $sortOrders
                      let $data := $lexicon//data[@ref = $lexus/meta/schema//component[@sort-order eq $sortOrderId]/@id]
                      return element sort-order { element data {$data}, lexus:processDataNodes($data, $user/workspace/sortorders/sortorder[@id eq $sortOrderId]) }
                   }
        };

    </xsl:template>
    
</xsl:stylesheet>
