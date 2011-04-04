<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>


    <!-- 
        1. Create a XQUery function to generate the @sort-key attribute for data elements in lexical entries.
        2. Create a XQUery function to generate the @start-letter attribute for data elements in lexical entries.
        
        A sort order needs to be transformed into a xquery statement to search the database for matching
        lexical entries and sort them in the right order. Rather than taking the sort order in the database xquery
        and constructing the xquery there this stylesheet precompiles a sort-key generating function
        and a start-letter generating function.
        
        When a sort order is saved, a schema is saved or a lexical entry is saved, these functions
        are used to generate @sort-key and @start-letter attributes.
        
        During sarching then, the @sort-key and @start-letter attributes are simply matched.
        -->
    <xsl:template match="lexus:save-sortorder/sortorder">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xquery>
                <functions>
                    <xsl:apply-templates select="." mode="sort-key"/>
                    <xsl:text>
                        
                    </xsl:text>
                    <xsl:apply-templates select="." mode="start-letter"/>
                </functions>
            </xquery>
        </xsl:copy>
    </xsl:template>


    <!--
        Create a XQuery function that generates @sort-key attributes for data elements based on this sort order.
    -->
    <xsl:template match="sortorder" mode="sort-key">
        <xsl:variable name="x" select="20"/>
        <xsl:variable name="y" select="count(mappings/mapping) + 1"/>
        <xsl:variable name="sizeOfCharacterMapping" select="string-length(string($y))"/>
        <xsl:variable name="zeroes"
            select="string-join(for $i in 1 to ($x * $sizeOfCharacterMapping) return '0','')"/>

        <xsl:variable name="function-name"
            select="concat('lexus:get-key-for-sort-order-', substring-after(@id, 'uuid:'))"/>
        
        <xsl:variable name="chars"
            select="lexus:character_sort-key-position_mapping(string-join(mappings/mapping/from, ''))"/>

        <xsl:text>declare function </xsl:text>
        <xsl:value-of select="$function-name"/>
        <xsl:text>($data as xs:string) as xs:string {</xsl:text>
        <xsl:text>substring(concat(replace(</xsl:text>
        <xsl:call-template name="replaceM">
            <xsl:with-param name="chars" select="$chars"/>
            <xsl:with-param name="size" select="$sizeOfCharacterMapping" as="xs:integer"/>
        </xsl:call-template>
        <xsl:text>, '\D', string(</xsl:text>
        <xsl:value-of select="$y"/>
        <xsl:text>)), '</xsl:text>
        <xsl:value-of select="$zeroes"/>
        <xsl:text>'), 1, </xsl:text>
        <xsl:value-of select="$x * $sizeOfCharacterMapping"/>
        <xsl:text>)</xsl:text>
        <xsl:text>};</xsl:text>
    </xsl:template>


    <xsl:template name="replaceM">
        <xsl:param name="chars" as="node()*"/>
        <xsl:param name="size" as="xs:integer" select="2"/>

        <xsl:if test="not(empty($chars))">
            <xsl:variable name="char" select="subsequence($chars, 1, 1)"/>
            <xsl:variable name="pos" select="$char/@pos"/>
            <xsl:variable name="rest" select="subsequence($chars, 2)"/>
            <xsl:variable name="paddedPos"
                select="substring(concat('0000', $pos), 5 + string-length(string($pos)) - $size)"/>

            <xsl:text>replace(</xsl:text>
            <xsl:choose>
                <xsl:when test="not(empty($rest))">
                    <xsl:call-template name="replaceM">
                        <xsl:with-param name="chars" select="$rest"/>
                        <xsl:with-param name="size" select="$size"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>$data</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>, '</xsl:text>
            <xsl:value-of select="replace($char/@value, '''', '''''')"/>
            <xsl:text>', '</xsl:text>
            <xsl:value-of select="$paddedPos"/>
            <xsl:text>') </xsl:text>
        </xsl:if>
    </xsl:template>



    <xsl:template match="sortorder" mode="start-letter">
        <xsl:variable name="y" select="count(mappings/mapping) + 1"/>
        <xsl:variable name="sizeOfCharacterMapping" select="string-length(string($y))"/>

        <xsl:variable name="function-name"
            select="concat('lexus:get-start-letter-for-sort-order-', substring-after(@id, 'uuid:'))"/>

        <xsl:variable name="chars" select="lexus:start-letters_position_mapping(mappings/mapping)"/>
        
        <xsl:text>declare function </xsl:text>
        <xsl:value-of select="$function-name"/>
        <xsl:text>($data as xs:string) as xs:string {</xsl:text>
        <xsl:text>substring(replace(</xsl:text>
        <xsl:call-template name="replaceM">
            <xsl:with-param name="chars" select="$chars"/>
            <xsl:with-param name="size" select="$sizeOfCharacterMapping" as="xs:integer"/>
        </xsl:call-template>
        <xsl:text>, '\D', string(</xsl:text>
        <xsl:value-of select="$y"/>
        <xsl:text>)), 1, 2)</xsl:text>
        <xsl:text>};</xsl:text>
    </xsl:template>

    
    
    <!--
        Create a 'longest character first' mapping of characters to start-letter positions.
    -->
    <xsl:function name="lexus:start-letters_position_mapping">
        <xsl:param name="mapping-sequence" as="node()*"/>
        
        <xsl:sequence select="lexus:longest-first(lexus:start-letters($mapping-sequence, 1)/*)"/>
    </xsl:function>
    
    
    <!--
        Create a mapping of characters to start-letter positions for all mapping elements.
        -->
    <xsl:function name="lexus:start-letters">
        <xsl:param name="mapping-sequence" as="node()*"/>
        <xsl:param name="pos" as="xs:integer"/>
        
        <xsl:if test="not(empty($mapping-sequence))">
            <xsl:variable name="rest" select="subsequence($mapping-sequence, 2)"/>
            <xsl:variable name="chars" select="lexus:character_pos_list(subsequence($mapping-sequence, 1 , 1)/from, $pos, 0)"/>
            <xsl:sequence select="insert-before($chars, 1, lexus:start-letters($rest, $pos + 1))"/>
        </xsl:if>
    </xsl:function>
    
    
    
    <!--
        Return a mapping of characters to sort-key position values, ordered by 'longest character first'.
    -->
    <xsl:function name="lexus:character_sort-key-position_mapping" as="node()*">        
        <xsl:param name="chars" as="xs:string"/>
        
        <xsl:sequence select="lexus:longest-first(lexus:character_pos_list($chars, 1, 1)/*)"/>
    </xsl:function>
    
    

    <!--
        Create a sequence of <char value="{$contractingCharacters}" pos="{$pos}"/> elements,
        remove '[' and ']' around contracting characters.
    -->
    <xsl:function name="lexus:character_pos_list" as="node()*">
        <xsl:param name="chars" as="xs:string"/>
        <xsl:param name="pos" as="xs:integer"/>
        <xsl:param name="increment" as="xs:integer"/>
        
        <xsl:choose>
            <xsl:when test="$chars ne ''">
                <xsl:choose>
                    <xsl:when test="starts-with($chars, '[')">
                        <xsl:variable name="contractingCharacters"
                            select="substring(substring-before($chars, ']'), 2)"/>
                        <xsl:variable name="rest"
                            select="substring($chars, string-length($contractingCharacters) + 3)"/>
                        <xsl:variable name="item">
                            <char value="{$contractingCharacters}" pos="{$pos}"/>
                        </xsl:variable>
                        <xsl:sequence
                            select="insert-before($item, 1, lexus:character_pos_list($rest, $pos + $increment, $increment))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="rest" select="substring($chars, 2)"/>
                        <xsl:variable name="item">
                            <char value="{substring($chars, 1, 1)}" pos="{$pos}"/>
                        </xsl:variable>
                        <xsl:sequence
                            select="insert-before($item, 1, lexus:character_pos_list($rest, $pos + $increment, $increment))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
        Order the sequence of <char value="{$contractingCharacters}" pos="{$pos}"/> elements so that the longest (contracting)
        characters come first. This done so that the longest contracting characters are replaced first and their
        constituent parts are replaced later. If not, the constituent parts are replaced first and the contracting
        character will never be matched.
    -->
    <xsl:function name="lexus:longest-first" as="node()*">
        <xsl:param name="chars" as="node()*"/>
        <xsl:for-each select="$chars">
            <xsl:sort select="string-length(@value)" order="ascending"/>
            <xsl:sequence select="."/>
        </xsl:for-each>
    </xsl:function>

</xsl:stylesheet>
