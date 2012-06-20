<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">


    <!--
        
        
    Build an XQuery function using the search parameters the user specified.
    
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
    
        ==>
    
    declare function lexus:search() {
        (
            (
                let $lexus := collection('lexus')/lexus[@id eq "uuid:2c9090a2134ee53d01136379321006d3"]
    
                return element lexicon {
                    attribute id {'uuid:2c9090a2134ee53d01136379321006d3'}, attribute name {'Main Rossel lexicon'},
    
                    ......
    };
    -->
    
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
        1   DC starts with same number as one of the positions of startLetter in the sort-order/mappings/mapping/to sequence
        2   DC starts with startLetter
        3   DC starts with same number as one of the positions of startLetter in the sort-order/mappings/mapping/to sequence
        4   DC starts with startLetter
        
    -->

    <xsl:template match="query" mode="build-query">
        <xsl:param name="lexica" select="()"/>
        <xsl:param name="user" select="()"/>
        <xsl:text>declare function lexus:search($startLetter as xs:string, $searchTerm as xs:string, $startPage as xs:double, $pageSize as xs:double) {
        (
        </xsl:text>
        <xsl:for-each select="expression/lexicon">
            <xsl:apply-templates select="." mode="build-query">
                <xsl:with-param name="meta" select="$lexica[@id eq current()/@id]/meta"/>
                <xsl:with-param name="sortOrders" select="$user/workspace/sortorders"/>
            </xsl:apply-templates>
            <xsl:if test="position()!=last()">
                <xsl:text>, 
                </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>
        )
    };
        </xsl:text>
    </xsl:template>


    <!--
        Build an XQuery using the search parameters the user specified.
        -->
    <xsl:template match="lexicon" mode="build-query">
        <xsl:param name="meta" select="()"/>
        <xsl:param name="sortOrders" select="()"/>

        <xsl:variable name="sl" select=".//datacategory[@ref eq 'lexus:start-letter-search']/@value"/>
        
        <xsl:variable name="firstDC">
            <xsl:call-template name="determineFirstDC">
                <xsl:with-param name="meta" select="$meta"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="matchText">
            <xsl:choose>
                <xsl:when test="$firstDC/container/@sort-order and $sl ne ''">
                    <xsl:call-template name="determineMatchText">
                        <xsl:with-param name="firstDC" select="$firstDC"/>
                        <xsl:with-param name="meta" select="$meta"/>
                        <xsl:with-param name="sortOrders" select="$sortOrders"/>
                        <xsl:with-param name="sl" select="$sl"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace(ancestor::query/../refiner/startLetter,'''','''''')"></xsl:value-of>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:text>
            (</xsl:text>
                <xsl:text>
                let $les := collection('</xsl:text>
                <xsl:value-of select="$lexica-collection"/>
                <xsl:text>')/lexus[@id = "</xsl:text><xsl:value-of select="@id"/>
                <xsl:text>"]/lexicon/lexical-entry</xsl:text>
                    <xsl:if test="ancestor::query/../refiner/searchTerm ne ''">
                          <xsl:choose>
	           		     <xsl:when test="ancestor::query/../refiner/caseSensitive eq 'true'">
	                 		 <xsl:text>[.//value[contains(text(),'</xsl:text>
   							 <xsl:value-of select="replace(replace(replace(ancestor::query/../refiner/searchTerm, '&amp;', '&amp;amp;'), '&quot;', '&amp;quot;'), '''', '''''')" />
							 <xsl:text>')]]</xsl:text> 
				    	</xsl:when> 
				    	<xsl:when test="ancestor::query/../refiner/caseSensitive eq 'false'">
	                 		 <xsl:text>[.//value[contains(upper-case(text()),upper-case('</xsl:text>
					   		 <xsl:value-of select="replace(replace(replace(ancestor::query/../refiner/searchTerm, '&amp;', '&amp;amp;'), '&quot;', '&amp;quot;'), '''', '''''')" />
				    	     <xsl:text>'))]]</xsl:text> 
				    	</xsl:when> 
				    </xsl:choose>
                    </xsl:if>
                    <xsl:if test="datacategory">
                        <xsl:text>[</xsl:text>
                        <xsl:for-each select="datacategory">
                            <xsl:text>(</xsl:text>
                            <xsl:apply-templates select="." mode="build-query">
                                <xsl:with-param name="firstDC" select="$firstDC"/>
                                <xsl:with-param name="matchText" select="$matchText"/>
                            </xsl:apply-templates>
                            <xsl:text>)</xsl:text>
                            <xsl:if test="position()!=last()">
                                <xsl:text> or 
                                </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                	<xsl:text>
                	return element lexicon {</xsl:text>
                    <xsl:apply-templates select="@id" mode="encoded"/><xsl:text>,
                    attribute name { </xsl:text><xsl:apply-templates select="$meta/name/text()" mode="encoded"/><xsl:text> },</xsl:text>
                    <xsl:text>
                    element firstDC { </xsl:text><xsl:apply-templates select="$firstDC" mode="encoded"/><xsl:text> },</xsl:text>
                    <xsl:text>
                    element matchText { </xsl:text><xsl:apply-templates select="$matchText" mode="encoded"/><xsl:text> },</xsl:text>
                    <xsl:text>
                    element lexical-entries { attribute count {count($les)},</xsl:text>
                    <xsl:text>
                    subsequence(
                        for $l in $les
	                    let $d := $l//data[@schema-ref = "</xsl:text><xsl:value-of select="$firstDC/container/@id" /><xsl:text>"][1]
	                    order by $d/@sort-key, $d/value
                        return $l , ($startPage * $pageSize) + 1, $pageSize)
                    }                
                </xsl:text>
            <xsl:text>
                }
            )</xsl:text>
    </xsl:template>

    <!--
        StartLetter searching is a special simple case. 
        -->
    <xsl:template match="datacategory[@ref eq 'lexus:start-letter-search']" mode="build-query"  priority="1">
        <xsl:param name="firstDC" as="node()*" />
        <xsl:param name="matchText" as="xs:string" />
        <xsl:text>.//data[@schema-ref = &quot;</xsl:text><xsl:value-of select="$firstDC/container/@id"/><xsl:text>&quot; and </xsl:text>
        <!-- Now we either check the @start-letter or the first character of the value element -->
        <xsl:choose>
            <xsl:when test="$firstDC/container/@sort-order">
                <xsl:text>@start-letter = "</xsl:text><xsl:value-of select="replace(replace($matchText, '&amp;', '&amp;amp;'), '&quot;', '&amp;quot;')" /><xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>starts-with(upper-case(value), "</xsl:text><xsl:value-of select="replace(replace($matchText, '&amp;', '&amp;amp;'), '&quot;', '&amp;quot;')" /><xsl:text>")</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
    </xsl:template>
    

    <!--
        Generate eq, not(eq), contains(), not(contains()) etc.
    -->
    <xsl:template match="datacategory" mode="build-query">
        <xsl:variable name="uc" select="replace(upper-case(@value), '&quot;', '&amp;quot;')"/>
            
            <xsl:if test="@caseSensitive eq 'true'">
           		<xsl:choose>
	                <xsl:when test="@condition eq 'is'">
	                	<xsl:text>.//data[@schema-ref = "</xsl:text> 
	                	<xsl:value-of select="@schema-ref"/>
	                	<xsl:text>"]/value[</xsl:text>
	                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
	                	<xsl:text>. = '</xsl:text>                           
						<xsl:value-of select="replace(@value, '&quot;', '&amp;quot;')"/>
                    	<xsl:text>'</xsl:text>
                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
                    	<xsl:text>]</xsl:text>
	                </xsl:when>
	                <xsl:when test="@condition eq 'contains'">
		                <!-- We separatly treat the case where the empty string is specified as search string, so
		                this situation can be used to search for entries which contain (or not) a certain DC -->
		                <xsl:choose>
		                	<xsl:when test="$uc eq ''">
			                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
			                	<xsl:text>.//data[@schema-ref = "</xsl:text> 
			                	<xsl:value-of select="@schema-ref"/>
			                	<xsl:text>"]/value[</xsl:text>
			                	<xsl:text>contains(., '</xsl:text>                           
								<xsl:value-of select="replace(@value, '&quot;', '&amp;quot;')"/>
		                    	<xsl:text>')</xsl:text>
		                    	<xsl:text>]</xsl:text>
		                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
		                	</xsl:when>
		                	<xsl:otherwise>
			                	<xsl:text>.//data[@schema-ref = "</xsl:text> 
			                	<xsl:value-of select="@schema-ref"/>
			                	<xsl:text>"]/value[</xsl:text> 
			                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
			                	<xsl:text>contains(., '</xsl:text>                           
								<xsl:value-of select="replace(@value, '&quot;', '&amp;quot;')"/>
		                    	<xsl:text>')</xsl:text>
		                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
		                    	<xsl:text>]</xsl:text>
	                    	</xsl:otherwise>
	                    </xsl:choose>
	                </xsl:when>
	                <xsl:when test="@condition eq 'begins with'">
	                	<xsl:text>.//data[@schema-ref = "</xsl:text>
	                	<xsl:value-of select="@schema-ref"/>
	                	<xsl:text>"]/value[</xsl:text>
	                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
	                	<xsl:text>starts-with(., '</xsl:text>                           
						<xsl:value-of select="replace(@value, '&quot;', '&amp;quot;')"/>
                    	<xsl:text>')</xsl:text>
                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
                    	<xsl:text>]</xsl:text>
	               	</xsl:when>
	                <xsl:when test="@condition eq 'ends with'">
	                	<xsl:text>.//data[@schema-ref = "</xsl:text>
	                	<xsl:value-of select="@schema-ref"/>
	                	<xsl:text>"]/value[</xsl:text>
	                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
	                	<xsl:text>ends-with(., '</xsl:text>                           
						<xsl:value-of select="replace(@value, '&quot;', '&amp;quot;')"/>
                    	<xsl:text>')</xsl:text>
                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
                    	<xsl:text>]</xsl:text>
	                </xsl:when>
	            </xsl:choose>
            </xsl:if>
            <xsl:if test="@caseSensitive eq 'false' or not(@caseSensitive )">
	            <xsl:choose>
	                <xsl:when test="@condition eq 'is'">
	                	<xsl:text>.//data[@schema-ref = "</xsl:text> 
	                	<xsl:value-of select="@schema-ref"/>
	                	<xsl:text>&quot;]/value[</xsl:text>
	                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
	                	<xsl:text>upper-case(.) = '</xsl:text>                           
                    	<xsl:value-of select="$uc"/>
                    	<xsl:text>'</xsl:text>
                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
                    	<xsl:text>]</xsl:text>
	                </xsl:when>
	                <xsl:when test="@condition eq 'contains'">
		                <!-- We separatly treat the case where the empty string is specified as search string, so
		                this situation can be used to search for entries which contain (or not) a certain DC -->
		                <xsl:choose>
		                	<xsl:when test="$uc eq ''">
			                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
			                	<xsl:text>.//data[@schema-ref = "</xsl:text> 
			                	<xsl:value-of select="@schema-ref"/>
			                	<xsl:text>&quot;]/value[</xsl:text>
			                	<xsl:text>contains(upper-case(.), '</xsl:text>                           
		                    	<xsl:value-of select="$uc"/>
		                    	<xsl:text>')</xsl:text>
		                    	<xsl:text>]</xsl:text>
		                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
		                	</xsl:when>
		                	<xsl:otherwise>
			                	<xsl:text>.//data[@schema-ref = "</xsl:text> 
			                	<xsl:value-of select="@schema-ref"/>
			                	<xsl:text>&quot;]/value[</xsl:text>
			                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
			                	<xsl:text>contains(upper-case(.), '</xsl:text>                           
		                    	<xsl:value-of select="$uc"/>
		                    	<xsl:text>')</xsl:text>
		                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
		                    	<xsl:text>]</xsl:text>
		                	</xsl:otherwise>
		                </xsl:choose>
                    </xsl:when>
	                <xsl:when test="@condition eq 'begins with'">
	                	<xsl:text>.//data[@schema-ref = "</xsl:text> 
	                	<xsl:value-of select="@schema-ref"/>
	                	<xsl:text>&quot;]/value[</xsl:text>
	                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
	                	<xsl:text>starts-with(upper-case(.), '</xsl:text>                           
                    	<xsl:value-of select="$uc"/>
                    	<xsl:text>')</xsl:text>
                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
                    	<xsl:text>]</xsl:text>	                
	                </xsl:when>
	                <xsl:when test="@condition eq 'ends with'">
	                	<xsl:text>.//data[@schema-ref = "</xsl:text> 
	                	<xsl:value-of select="@schema-ref"/>
	                	<xsl:text>&quot;]/value[</xsl:text>
	                	<xsl:if test="@negation eq 'true'"><xsl:text>not(</xsl:text></xsl:if>
	                	<xsl:text>ends-with(upper-case(.), '</xsl:text>                           
                    	<xsl:value-of select="$uc"/>
                    	<xsl:text>')</xsl:text>
                    	<xsl:if test="@negation eq 'true'"><xsl:text>)</xsl:text></xsl:if>
                    	<xsl:text>]</xsl:text>
	                </xsl:when>
	            </xsl:choose>
            </xsl:if>
        <xsl:if test="datacategory">
            <xsl:text> and (</xsl:text>
            <xsl:apply-templates select="datacategory" mode="build-query"/>                
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <!-- Determines datacategory element that is used for filtering and sorting. -->
    <xsl:template name="determineFirstDC">
        <xsl:param name="meta" select="()"/>
        <xsl:variable name="firstListViewId" select="($meta/views/view[@id eq ../@listView]//data[@type eq 'data category'])[1]/@id"/>
        <xsl:choose>
            <xsl:when test="$firstListViewId ne ''">
                <xsl:copy-of select="$meta/schema//container[@id eq $firstListViewId]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$meta/schema//container[@type eq 'data'][@sort-order]">
                        <xsl:copy-of select="$meta/schema//container[@type eq 'data'][@sort-order]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="($meta/schema//container[@type eq 'data'])[1]"/>                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Determine string to match startLetter of firstDC against, e.g.
            -   use position-number in sort order mapping when firstDC has a @sort-order or
            -   use actual startLetter when firstDC does not have a @sort-order (and compare against value element then).
    -->
    <xsl:template name="determineMatchText">
        <xsl:param name="firstDC"/>
        <xsl:param name="meta" select="()"/>
        <xsl:param name="sortOrders" select="()"/>
        <xsl:param name="sl" select="''"/>
        <xsl:choose>
            <xsl:when test="$firstDC/container/@sort-order">
                <xsl:variable name="sortOrder" select="$sortOrders/sortorder[@id eq $firstDC/container/@sort-order]"/>
                <xsl:variable name="nrOfMappings" select="count($sortOrder/mappings/mapping)"/>
                <xsl:variable name="pos" select="count($sortOrder/mappings/mapping[to eq $sl]/preceding-sibling::mapping) + 1"/>
                <xsl:variable name="paddedValue" select="concat('000', string($pos))"/>
                <!-- Need to pad it with zeroes! -->
                <xsl:value-of select="substring($paddedValue, string-length($paddedValue) - string-length(string($nrOfMappings)) + 1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="replace(upper-case(.//datacategory[@ref eq 'lexus:start-letter-search']/@value), '&quot;', '&amp;quot;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
