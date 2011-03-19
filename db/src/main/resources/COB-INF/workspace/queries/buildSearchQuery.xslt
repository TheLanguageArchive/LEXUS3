<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">


    <!--
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
    
    /lexus[@id eq "uuid:eae8c847-4462-432e-bf95-56eae4831044"]/lexicon/
    lexical-entry[(.//data[@schema-ref eq "uuid:6e1f2b5f-778e-4940-b054-dc8f1e0d2dec" and value eq "test"])]) 

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
        1   DC starts with same number as the position of startLetter in the sort-order/mappings/mapping/to sequence
        2   DC starts with startLetter
        3   DC starts with same number as the position of startLetter in the sort-order/mappings/mapping/to sequence
        4   DC starts with startLetter
        
    -->

    <xsl:template match="query" mode="build-query">
        <xsl:param name="lexica" select="()"/>
        <xsl:text>declare function lexus:search() {
            (
        </xsl:text>
        <xsl:for-each select="expression/lexicon">
            <xsl:apply-templates select="." mode="build-query">
                <xsl:with-param name="meta" select="$lexica[@id eq current()/@id]/meta"/>
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
        /lexus[@id eq "uuid:eae8c847-4462-432e-bf95-56eae4831044"]/lexicon/lexical-entry[...]
        -->
    <xsl:template match="lexicon" mode="build-query">
        <xsl:param name="meta" select="()"/>
        <xsl:variable name="firstDC">
            <xsl:call-template name="determineFirstDC">
                <xsl:with-param name="meta" select="$meta"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="matchText">
            <xsl:call-template name="determineMatchText">
                <xsl:with-param name="firstDC" select="$firstDC"/>
                <xsl:with-param name="meta" select="$meta"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:text>element lexicon {
            </xsl:text>
        <xsl:text> attribute id {'</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>'},
                </xsl:text>
        <xsl:text> attribute name {'</xsl:text>
        <xsl:value-of select="$meta/name"/>
        <xsl:text>'},
                </xsl:text>
            <xsl:text>let $lexus := collection('</xsl:text>
            <xsl:value-of select="$lexica-collection"/>
            <xsl:text>')</xsl:text>
            <xsl:text>/lexus[@id eq "</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>"]
            
            let $firstDC := </xsl:text><xsl:apply-templates select="$firstDC" mode="encoded"/>
            <xsl:text>
            
               </xsl:text>
                   <xsl:if test=".//datacategory[@ref eq 'lexus:start-letter-search']">
                        <xsl:text>let $matchText := '</xsl:text><xsl:value-of select="$matchText"/>
                       <xsl:text>'
                        </xsl:text>
               </xsl:if>
            <xsl:text>
            return (element firstDC { </xsl:text><xsl:apply-templates select="$firstDC" mode="encoded"/><xsl:text> },</xsl:text>
                    <xsl:if test=".//datacategory[@ref eq 'lexus:start-letter-search']"> element matchText { '<xsl:value-of select="$matchText"/>' },</xsl:if>
                    <xsl:text> element lexical-entries {
                        for $l in $lexus/lexicon/lexical-entry</xsl:text>
                    <xsl:if test="ancestor::query/../refiner/searchTerm ne ''">
                        <xsl:text>[.//value[text() contains text {'.*</xsl:text><xsl:value-of select="ancestor::query/../refiner/searchTerm"/><xsl:text>.*'} using wildcards]]</xsl:text>
                    </xsl:if>
                    <xsl:if test="datacategory">
                        <xsl:text>[
                        </xsl:text>
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
                        <xsl:text>
                            ]</xsl:text>
                    </xsl:if>
                    <xsl:text>
                        order by </xsl:text>
                        <xsl:choose>
                            <xsl:when test="$firstDC/container/@sort-order">
                                ($l//data[@schema-ref eq '<xsl:value-of select="$firstDC/container/@id"/>'])[1]/@sort-key
                            </xsl:when>
                            <xsl:otherwise>
                                ($l//data[@schema-ref eq '<xsl:value-of select="$firstDC/container/@id"/>'])[1]/value 
                            </xsl:otherwise>
                        </xsl:choose> 
        <xsl:text>
                        return $l
                    }
                )
            </xsl:text>
        <xsl:text> }</xsl:text>
    </xsl:template>

    <!--
        StartLetter searching is a special simple case.
        -->
    <xsl:template match="datacategory[@ref eq 'lexus:start-letter-search']" mode="build-query"  priority="1">
        <xsl:param name="firstDC"/>
        <xsl:param name="matchText"/>
        <xsl:text>.//data[@schema-ref eq '</xsl:text><xsl:value-of select="$firstDC/container/@id"/><xsl:text>' and </xsl:text>
        <!-- Now we either check the @sort-key or the first caharacter of the value element -->
        <xsl:choose>
            <xsl:when test="$firstDC/container/@sort-order">
                <xsl:text>starts-with(@sort-key, $matchText)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>starts-with(upper-case(value), $matchText)</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <!--
        .//data[@schema-ref eq "uuid:6e1f2b5f-778e-4940-b054-dc8f1e0d2dec" and value eq "test"]
        -->
    <xsl:template match="datacategory" mode="build-query">
        <xsl:param name="firstDC"/>
        <xsl:param name="matchText"/>
        <xsl:text>.//data[@schema-ref eq &quot;</xsl:text><xsl:value-of select="@schema-ref"/><xsl:text>&quot;</xsl:text>
        <xsl:apply-templates select="." mode="condition"/>
        <xsl:text>]
        </xsl:text>
        <xsl:if test="datacategory">
            <xsl:text> and
                (</xsl:text>
            <xsl:apply-templates select="datacategory" mode="build-query"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>

    <!--
        Generate eq, not(eq), contains(), not(contains()) etc.
    -->
    <xsl:template match="datacategory" mode="condition">
        <xsl:variable name="uc" select="replace(upper-case(@value), '&quot;', '&amp;quot;')"/>
        <!-- Prevent meaningless checking -->
        <xsl:if test="$uc ne '' or @condition eq 'is'">
            <xsl:text> and </xsl:text>
            
            <xsl:if test="@negation eq 'true'">not(</xsl:if>
            <xsl:choose>
                <xsl:when test="@condition eq 'is'"> upper-case(value) eq '<xsl:value-of select="$uc"/>' </xsl:when>
                <xsl:when test="@condition eq 'contains'"> contains(upper-case(value), '<xsl:value-of
                        select="$uc"/>') </xsl:when>
                <xsl:when test="@condition eq 'begins with'"> starts-with(upper-case(value), '<xsl:value-of select="$uc"/>') </xsl:when>
                <xsl:when test="@condition eq 'ends with'"> ends-with(upper-case(value), '<xsl:value-of
                        select="$uc"/>') </xsl:when>
            </xsl:choose>
            <xsl:if test="@negation eq 'true'">)</xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- Determines datacategori element that is used for filtering and sorting. -->
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
        <xsl:choose>
            <xsl:when test="$firstDC/container/@sort-order">
                <xsl:variable name="sortOrder" select="$meta/sort-orders/sort-order[@id eq $firstDC/container/@sort-order]"/>
                <xsl:variable name="nrOfMappings" select="count($sortOrder/mappings/mapping)"/>
                <xsl:variable name="pos" select="count($sortOrder/mappings/mapping/to[. eq .//datacategory[@ref eq 'lexus:start-letter-search']/@value]/../preceding::mapping) + 1"/>
                <xsl:variable name="paddedValue" select="concat('000', string($pos))"/>
                <!-- Need to pad it with zeroes! -->
                <xsl:value-of select="substring($paddedValue, string-length($paddedValue) - string-length(string($nrOfMappings)))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="replace(upper-case(.//datacategory[@ref eq 'lexus:start-letter-search']/@value), '&quot;', '&amp;quot;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
