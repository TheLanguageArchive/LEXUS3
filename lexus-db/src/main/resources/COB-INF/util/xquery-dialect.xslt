<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xquery="xquery-dialect"
   version="2.0">

    <xsl:include href="identity.xslt"/>
    
    <xsl:param name="xmldb"/>



    <!--
        declare updating function.
    -->
    <xsl:template match="xquery:declare-updating-function">
        <xsl:choose>
            <xsl:when test="$xmldb eq 'exist'">
                <xsl:text>declare function </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>declare updating function </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!--
        Replace node.
    -->
    <xsl:template match="xquery:replace">
        <xsl:choose>
            <xsl:when test="$xmldb eq 'exist'">
                update replace <xsl:value-of select="xquery:node"/> with <xsl:value-of select="xquery:with"/>
            </xsl:when>
            <xsl:otherwise>
                replace node <xsl:value-of select="xquery:node"/> with <xsl:value-of select="xquery:with"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--
        Replace value of node.
        -->
    <xsl:template match="xquery:replace-value">
        <xsl:choose>
            <xsl:when test="$xmldb eq 'exist'">
                update value <xsl:value-of select="xquery:node"/> with <xsl:value-of select="xquery:with"/>
            </xsl:when>
            <xsl:otherwise>
                replace value of node <xsl:value-of select="xquery:node"/> with <xsl:value-of select="xquery:with"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--
        insert ... into ...
        -->
    <xsl:template match="xquery:insert-into">
        <xsl:choose>
            <xsl:when test="$xmldb eq 'exist'">
                update insert <xsl:value-of select="xquery:node"/> into <xsl:value-of select="xquery:into"/>
            </xsl:when>
            <xsl:otherwise>
                insert node <xsl:value-of select="xquery:node"/> into <xsl:value-of select="xquery:into"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--
        insert ... as last into ...
        -->
    <xsl:template match="xquery:insert-as-last-into">
        <xsl:choose>
            <xsl:when test="$xmldb eq 'exist'">
                update insert <xsl:value-of select="xquery:node"/> into <xsl:value-of select="xquery:into"/>
            </xsl:when>
            <xsl:otherwise>
                insert node <xsl:value-of select="xquery:node"/> as last into <xsl:value-of select="xquery:into"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--
        delete node or collection...
    -->
    <xsl:template match="xquery:delete">
        <xsl:choose>
            <xsl:when test="$xmldb eq 'exist'">
            	<xsl:choose>
            		<xsl:when test="xquery:node">
                		update delete <xsl:value-of select="xquery:node"/>
            		</xsl:when>
            		<xsl:when test="xquery:collection and xquery:path">
            			db:delete('<xsl:value-of select="xquery:collection"/>', '<xsl:value-of select="xquery:path"/>')
            		</xsl:when>
            	</xsl:choose>
            </xsl:when>
            <xsl:otherwise>
	            <xsl:choose>
	            	<xsl:when test="xquery:node">
	                	delete node <xsl:value-of select="xquery:node"/>
	                </xsl:when>
            		<xsl:when test="xquery:collection and xquery:path">
	            		db:delete('<xsl:value-of select="xquery:collection"/>', '<xsl:value-of select="xquery:path"/>')
	            	</xsl:when>
	            </xsl:choose>	
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
 
</xsl:stylesheet>
