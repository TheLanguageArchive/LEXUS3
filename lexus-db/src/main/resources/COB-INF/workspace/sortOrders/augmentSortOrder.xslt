<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>


    <xsl:variable name="before" select="1" as="xs:integer"/>
    <xsl:variable name="after" select="10000" as="xs:integer"/>

    <!-- 
        1. Create a XQUery function to generate the @sort-key attribute for data elements in lexical entries.
        2. Create a XQUery function to generate the @start-letter attribute for data elements in lexical entries.
        
        A sort order needs to be transformed into a xquery statement to search the database for matching
        lexical entries and sort them in the right order. Rather than taking the sort order in the database xquery
        and constructing the xquery there this stylesheet precompiles a sort-key generating function
        and a start-letter generating function.
        
        When a sort order is saved, a schema is saved or a lexical entry is saved, these functions
        are used to generate @sort-key and @start-letter attributes.
        
        During searching the @sort-key and @start-letter attributes are simply matched.
        
        The sort key function orders words that are exact matches to one of the 'characters' in the from field,
        for other words the matching characters are taken to be the same (e.g. a, Á, ä are all the same in words consisting
        of multiple characters).
        
        Example.
        
        For the mapping
        a -> aAáÁ
        
        the following words:
        
        Á
        a
        ae
        Ád
        
        are sorted as follows:
        
        a
        Á
        Ád
        ae
        
        End of example.
        
        The mapping to numbers therefore assigns sequential numbers to each character, but adds another number for the 
        'match-all' character. That sounds rather vague. What I mean is maybe clear when I give an example:
        
        a -> aAáÁ
        
        generates this mapping:
        a -> 01 when the entire word is "a"
        A -> 02 when the entire word is "A"
        á -> 03 when the entire word is "á"
        Á -> 04 when the entire word is "Á"
        a, A, á, Á -> 05 when the entire word is not exactly one of the characters.
        
        Wow. That's going to be a function you do not want to write yourself.
        
        So how do we do this in one function?
        
        Replace each "^"+character+"$" with the number for the entire word. Do this for all characters in all mappings.
        After replacing entire words, add replace statements for just the characters.
        
        The algorithm for creating the sort-key mapping/replace()-calls goes like this:
        
        (: process all mappings :)
        f(list of mappings (ms), position number (p)):
            (head | tail) = ms
            charmaps = g(head, p)
            = sequence(charmaps | f(tail, p + sizeof(charmaps))
            
        (: process one mapping :)
        g(character mapping (cm), position number p)):
            char-list = character-list(cm)
            char-maps = h(char-list, p)
            = sequence(char-maps | replace(char-list, sizeof(char-maps) + 1))
        
        (: process all characters in a mapping :)
        h(character list (cl),  position number p)):
            (head | tail) = cl
            = sequence(replace( "^" + head + "$",  p) | h(tail, p + 1)
        
        -->
    <xsl:template match="lexus:save-sortorder/sortorder">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <xquery>
        	<functions>
            	<xsl:apply-templates select="." mode="sort-key"/>
               	<xsl:text>                        
                </xsl:text>
                <xsl:apply-templates select="." mode="start-letter"/>
            </functions>
        </xquery>
    </xsl:template>


    <!--
        Create a XQuery function that generates @sort-key attributes for data elements based on this sort order.
    -->
    <xsl:template match="sortorder" mode="sort-key">
        <!-- Nr of characters used for the sort-key -->
        <xsl:variable name="x" select="20"/>
        <!-- Create function name specifically for this sort order -->
        <xsl:variable name="function-name"
            select="concat('lexus:get-key-for-sort-order-', substring-after(@id, 'uuid:'))"/>
        <!-- List of character mappings -->
        <xsl:variable name="chars" select="lexus:f(mappings/mapping, 1)"/>
        <!-- Nr of mappings + 1 -->
        <xsl:variable name="y" select="count($chars) + 1"/>
        <!-- Number of digits needed in the mapping number -->
        <xsl:variable name="sizeOfCharacterMapping" select="string-length(string($y))"/>
        <!-- A string to 'pad out' short sort-key strings -->
        <xsl:variable name="zeroes"
            select="string-join(for $i in 1 to ($x * $sizeOfCharacterMapping) return '0','')"/>
        
        <xsl:text>declare function </xsl:text>
        <xsl:value-of select="$function-name"/>
        <xsl:text>($data as xs:string) as xs:string {</xsl:text>
        <xsl:text>substring(concat(replace(</xsl:text>
        <xsl:call-template name="replaceM">
            <xsl:with-param name="char-list" select="$chars"/>
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
            <xsl:with-param name="char-list" select="$chars"/>
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
            <xsl:variable name="chars"
                select="lexus:character_pos_list(subsequence($mapping-sequence, 1 , 1)/from, $pos, 0)"/>
            <xsl:sequence select="insert-before($chars, 1, lexus:start-letters($rest, $pos + 1))"/>
        </xsl:if>
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
                        <!--
                            HHV: remove silly escape characters (\) in front of (-characters.
                        -->
                        <xsl:variable name="item">
                            <char value="{lexus:safe-char(translate($contractingCharacters, '\', ''))}" pos="{$pos}"
                            />
                        </xsl:variable>
                        <xsl:sequence
                            select="insert-before($item, 1, lexus:character_pos_list($rest, $pos + $increment, $increment))"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="rest" select="substring($chars, 2)"/>
                        <xsl:variable name="item">
                            <char value="{lexus:safe-char(substring($chars, 1, 1))}" pos="{$pos}"/>
                        </xsl:variable>
                        <xsl:sequence
                            select="insert-before($item, 1, lexus:character_pos_list($rest, $pos + $increment, $increment))"
                        />
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




    <!--
        Go through the list of mappings and generate a replace() function from each mapping.
        -->
    <xsl:template name="replaceM">
        <xsl:param name="char-list" as="node()*"/>
        <xsl:param name="size" as="xs:integer" select="2"/>
        
        <xsl:choose>
            <xsl:when test="not(empty($char-list))">
                
                <xsl:variable name="head" select="subsequence($char-list, 1, 1)"/>
                <xsl:variable name="tail" select="subsequence($char-list, 2)"/>
                <xsl:variable name="paddedPos"
                    select="substring(concat('0000', $head/@pos), 5 + string-length(string($head/@pos)) - $size)"/>
                
                <xsl:text>replace(</xsl:text>
                <xsl:call-template name="replaceM">
                    <xsl:with-param name="char-list" select="$tail"/>
                    <xsl:with-param name="size" select="$size"/>
                </xsl:call-template>
                <xsl:text>, '</xsl:text>
                <xsl:value-of select="$head/@value"/>
                <xsl:text>', '</xsl:text>
                <xsl:value-of select="$paddedPos"/>
                <xsl:text>') </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>$data</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    







    <!--
        Create a sort-key mapping.
    -->
    <xsl:function name="lexus:f" as="node()*">
        <xsl:param name="mapping-sequence" as="node()*"/>
        <xsl:param name="pos" as="xs:integer"/>

        <xsl:if test="not(empty($mapping-sequence))">
            <xsl:variable name="head" select="subsequence($mapping-sequence, 1 , 1)" as="node()"/>
            <xsl:variable name="tail" select="subsequence($mapping-sequence, 2)" as="node()*"/>
            <xsl:variable name="charmaps" select="lexus:g($head/from, $pos)" as="node()*"/>
            <xsl:sequence select="insert-before($charmaps, $before, lexus:f($tail, $pos + count($charmaps)))"/>
        </xsl:if>
    </xsl:function>

    <xsl:function name="lexus:g" as="node()*">
        <xsl:param name="chars" as="xs:string"/>
        <xsl:param name="pos" as="xs:integer"/>

<!-- HHV: longest first not needed because we surround the text with ^ and $ anyway for whole matches
    and chunk together all the matches for all other occurrences.
    <xsl:variable name="char-list" select="lexus:longest-string-first(lexus:char-list($chars))" as="xs:string*"/>-->
        <xsl:variable name="char-list" select="lexus:char-list($chars)" as="xs:string*"/>
        <xsl:variable name="charmaps" select="lexus:h($char-list, $pos, 1, '^', '$')" as="node()*"/>
        <xsl:variable name="chars-in-words" as="node()">
            <char value="{string-join($char-list, '|')}" pos="{$pos + count($charmaps)}"/>
        </xsl:variable>
        <xsl:sequence select="insert-before(reverse($charmaps), $before, ($chars-in-words))"/>
    </xsl:function>

    <xsl:function name="lexus:h" as="node()*">
        <xsl:param name="chars" as="xs:string*"/>
        <xsl:param name="pos" as="xs:integer"/>
        <xsl:param name="increment" as="xs:integer"/>
        <xsl:param name="prefix" as="xs:string"/>
        <xsl:param name="postfix" as="xs:string"/>

        <xsl:choose>
            <xsl:when test="not(empty($chars))">
                <xsl:variable name="head" select="subsequence($chars, 1 , 1)" as="xs:string"/>
                <xsl:variable name="tail" select="subsequence($chars, 2)"  as="xs:string*"/>
                <xsl:variable name="char-map" as="node()">
                    <char value="{concat($prefix, $head, $postfix)}" pos="{$pos}"/>
                </xsl:variable>                
                <xsl:sequence
                    select="insert-before(lexus:h($tail, $pos + $increment, $increment, $prefix, $postfix), $before, $char-map)"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


    
    <!--
        Get a sequence of (contracting) characters.
        -->
    <xsl:function name="lexus:char-list" as="xs:string*">
        <xsl:param name="chars" as="xs:string"/>

        <xsl:choose>
            <xsl:when test="$chars ne ''">
                <xsl:choose>
                    <xsl:when test="starts-with($chars, '[')">
                        <xsl:variable name="contractingCharacters"
                            select="substring(substring-before($chars, ']'), 2)" as="xs:string"/>
                        <xsl:variable name="rest"
                            select="substring($chars, string-length($contractingCharacters) + 3)" as="xs:string"/>
                        <!--
                            HHV: remove silly escape characters (\) in front of (-characters.
                        -->
                        <xsl:sequence
                            select="insert-before(lexus:char-list($rest), $before, lexus:safe-char(translate($contractingCharacters, '\', '')))"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="rest" select="substring($chars, 2)" as="xs:string"/>
                        <xsl:sequence
                            select="insert-before(lexus:char-list($rest), $before, lexus:safe-char(substring($chars, 1, 1)))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>



    <!--
        Escape characters that are used in regexes.
        -->
    <xsl:function name="lexus:safe-char" as="xs:string">
        <xsl:param name="s" as="xs:string"/>

        <xsl:value-of
            select="replace(string-join(for $i in string-to-codepoints($s) return if (contains('\|.?*+(){}&#x2D;&#x5B;&#x5D;&#x5E;', codepoints-to-string($i))) then concat('\',codepoints-to-string($i)) else codepoints-to-string($i), ''), '''', '''''')"
        />
    </xsl:function>



    <!--
        Order the sequence of (contracting) characters strings so that the longest (contracting)
        characters come first. This done so that the longest contracting characters are replaced first and their
        constituent parts are replaced later. If not, the constituent parts are replaced first and the contracting
        character will never be matched.
    -->
    <xsl:function name="lexus:longest-string-first" as="xs:string*">
        <xsl:param name="chars" as="xs:string*"/>
        <xsl:for-each select="$chars">
            <xsl:sort select="string-length(.)" order="descending"/>
            <xsl:sequence select="."/>
        </xsl:for-each>
    </xsl:function>
</xsl:stylesheet>
