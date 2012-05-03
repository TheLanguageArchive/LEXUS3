<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        <data>
            <lexus:search>
                <query xmlns:json="http://apache.org/cocoon/json/1.0"
                    id="uuid:9c061431-140a-49ea-96e9-3b964fb91884">
                    <description/>
                    <name>testje 2</name>
                    <expression>
                        <lexicon id="uuid:eae8c847-4462-432e-bf95-56eae4831044"
                            name="976b83a2-7bef-4099-9e5f-04f22bd7e98f">
                            <datacategory schema-ref="uuid:6e1f2b5f-778e-4940-b054-dc8f1e0d2dec" name="Lexeme"
                                value="test" condition="is" negation="false"/>
                        </lexicon>
                    </expression>
                </query>
                <refiner>
                    <startLetter/>
                    <searchTerm/>
                    <pageSize>25</pageSize>
                    <startPage>0</startPage>
                </refiner>
            </lexus:search>
            <user>...</user>
        </data>
        
        -->
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    <xsl:include href="../workspace/queries/buildSearchQuery.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>

    <xsl:template match="lexus:search">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
               <lexus:text>
                   (: <xsl:value-of select="base-uri(document(''))"/> :)
                   <xsl:call-template name="declare-namespace"/>                        
                   <xsl:call-template name="users"/>                       
                   <xsl:call-template name="lexicon"/>                       
                   <xsl:call-template name="lexica"/>

                   <!-- Insert lexus:search() function here. --> 
                   <xsl:apply-templates select="query" mode="build-query">
                       <xsl:with-param name="lexica" select="../lexus:search-lexica/lexus"/>
                       <xsl:with-param name="user" select="../lexus:search-lexica/user"/>
                   </xsl:apply-templates>
                   
                   let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                   let $lexiconId := '<xsl:value-of select="replace(replace(replace(query/expression/lexicon/@id, '&amp;', '&amp;amp;'), '&quot;', '&amp;quot;') ,'''', '''''')"/>'
                   let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                   let $startLetter := '<xsl:value-of select="replace(replace(replace(refiner/startLetter, '&amp;', '&amp;amp;'), '&quot;', '&amp;quot;') ,'''', '''''')"/>'
                   let $searchTerm := '<xsl:value-of select="replace(replace(replace(refiner/searchTerm, '&amp;', '&amp;amp;'), '&quot;', '&amp;quot;') ,'''', '''''')"/>'
                   let $caseSensitive := <xsl:choose>
                       <xsl:when test="refiner/caseSensitive eq 'true'">
                           <xsl:text>true()</xsl:text>
                       </xsl:when>
                       <xsl:otherwise>
                           <xsl:text>false()</xsl:text>
                       </xsl:otherwise>
                   </xsl:choose>
                   let $pageSize := number('<xsl:value-of select="replace(refiner/pageSize,'''','''''')"/>')
                   let $startPage := number('<xsl:value-of select="replace(refiner/startPage,'''','''''')"/>')
                   let $lexi := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user/@ref = $user-id]
                   let $listView := $lexus/meta/views/view[@id eq $lexus/meta/views/@listView]
                   
                   <!--
                       Possible situations:
                       1   There is a listview with a DC, DC has sort-order
                       2   There is a listview with a DC, DC has NO sort-order
                       3   There is no listview, but there is a (first) DC that has a sort-order
                       4   There is no listview, NO DC that has a sort-order
                       
                       DC to use:
                       1   Use DC from listview
                       2   Use DC from listview
                       3   Use first DC with @sort-order
                       4   Use first DC in schema.
                       
                       Having determined the DC to use for filtering/ordering:
                       
                       The startLetter list is dependent on the presence of a sort-order:
                       1   sort-order/mappings/to
                       2   unique first characters of data/value elementen
                       3   sort-order/mappings/to
                       4   unique first characters of data/value elementen
                       
                       Ordering of lexical entries:
                       1   Use data[@schema-ref eq DC]/@sort-key
                       2   Use data[@schema-ref eq DC]/value
                       3   Use data[@schema-ref eq DC]/@sort-key
                       4   Use data[@schema-ref eq DC]/value
                       
                       The startLetter filter is also dependent on the presence of a sort-order:
                       1   data[@schema-ref eq DC]/@start-letter
                       2   DC starts with startLetter
                       3   data[@schema-ref eq DC]/@start-letter
                       4   DC starts with startLetter
                       
                   -->
                   
                   let $sortOrders := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $user-id]/workspace/sortorders
                   
                    (: Returns a list of lexicon elements, containing ($firstDC, (lexical-entry)*) :)
                   let $search-results := lexus:search($startLetter, $searchTerm, $startPage, $pageSize) 


                    (: Return $sortOrder//mapping/to character(s) when a sort order is defined,
                        otherwise return distinct-values(first characters of all data values) :)
                   
                   let $firstDC := $search-results/firstDC/container
                   let $sortOrderId := $firstDC/@sort-order
                   let $startLetters := if ($sortOrderId ne '')
                        then for $sl in $sortOrders/sortorder[@id eq $sortOrderId]/mappings/mapping/to  return element startLetter { $sl/text() }
                        else 
                            (: Look for data elements with the same schema-ref as the first data element :)
                            let $sortOrderDCs := for $le in $lexus/lexicon/lexical-entry return ($le//data[@schema-ref eq $firstDC/@id])[1]
                            (: Return their values :)
                            let $sLValues := for $sodc in $sortOrderDCs return upper-case(substring($sodc/value, 1, 1))
                            (: Create a list of startLetters from the values :)
                            return for $sl in distinct-values($sLValues) return element startLetter { $sl }
                   
                   let $schema := $lexus/meta/schema
                   let $users := lexus:users(collection('<xsl:value-of select="$users-collection"/>')/user[@id = distinct-values($lexus/meta/users/user/@ref)])
                   
                   let $firstDCId := $firstDC/@id
                   
                   
                   return element result {
                       element results {
                           element startLetter { $startLetter },
                           lexus:lexicon($lexus),
                           element startPage { $startPage },
                           element searchTerm { $searchTerm },
                           element caseSensitive { $caseSensitive },
                           element count {count(collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]/lexicon/lexical-entry) },
                           element pageSize { $pageSize },
                           $search-results/lexical-entries,
                           element query { attribute id { '<xsl:value-of select="query/@id"/>' } }
                            },                                        
                       lexus:lexica($lexi),
                       element startLetters { $startLetters },
                       $lexus/meta/queries,
                       $schema,
                       $users
                   }
                   (: subsequence($search-results/lexical-entries/lexical-entry,($startPage * $pageSize) + 1, $pageSize)  :)
                   (: $search-results/lexical-entries/lexical-entry[position() ge ($startPage * $pageSize) + 1][position() le (($startPage+1) *  $pageSize)] :)
               </lexus:text>
          </lexus:query>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
