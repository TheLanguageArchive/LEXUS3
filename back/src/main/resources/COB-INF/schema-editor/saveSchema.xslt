<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    <xsl:include href="../util/sort-order.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="/">
        <lexus:query>
            
            <!--(: 
            
                Save a schema.
                
                I think all that is needed in a response here is 'success' or 'failure'. That will save
                hundreds if not thousands of bytes and the client side will function just as well.
            
                The typical response in the old backend was several kilobytes big, depending on the size of the schema,
                the users workspace and other things. Seriously? Yes, seriously.
               
                Guess what the client does with all this info, lexicon info, sortorders, etc.
               
               Guess....
               
               
               guess...
               
               
               OK, you couldn't have guessed it I guess.... watch closely...
               
               this.lexusService.send("LexusSchemaEditor/saveSchema.json", param, this.name, function():void { LexusUtil.removeWait() });
               
               See, the callback for the "saveSchema.json" request does nothing with all that data, it just removes the 'Please wait' box.
               
               Time for optimization.
               
               I'll optimize to:
               
               {
                   "id": "Mon Jun 07 09:14:16 CEST 2010",
                   "status":         {
                       "message": "At your service",
                       "duration": "1874",
                       "insync": true,
                       "success": true
                   },
               }
               
               But that JSON is generated in the front, in the back module we'll just generate
               
               <result><schema>...</schema</result>
            :)-->
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="schema-permissions"/>
                <xsl:call-template name="sort-order"/>
                <xsl:call-template name="log"/>
                
                declare function lexus:updateSchema($newData as node(), $lexus as node()) as node() {
                
                    let $dummy := (
                        update replace $lexus/meta/schema with $newData
                    )
                                            
                    return element result
                    {
                        $lexus/meta/schema
                    }
                };

                let $userId := '<xsl:value-of select="/data/user/@id"/>'       
                let $username := '<xsl:value-of select="/data/user/name"/>'       
                let $newData := <xsl:apply-templates select="/data/lexus:save-schema" mode="encoded"/>
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $newData/@id]
                return
                    if (lexus:canUpdateSchema($lexus, $userId))
                        then let $returnValue := lexus:updateSchema($newData/schema, $lexus)
                             let $dummy := lexus:log($lexus/@id, 'save-schema', $userId, $username, $newData/schema)
                             let $sort-order-processing := lexus:sort-order-processSchemaChanged($newData/@id, $userId)
                             return element boe {$returnValue, element sort-order-processing { $sort-order-processing } }
                        else element exception {attribute id {"LEX001"}, element message {concat("Permission denied, user '<xsl:value-of select="/data/user/name"/>' ('<xsl:value-of select="/data/user/account"/>', ",$userId, ") cannot update schema for lexicon '", $lexus/meta/name, "' (", $newData/component/@id)}}
            </lexus:text>
        </lexus:query>
    </xsl:template>
    
</xsl:stylesheet>
