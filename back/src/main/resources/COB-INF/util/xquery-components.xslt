<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:json="http://apache.org/cocoon/json/1.0" version="2.0">


    <xsl:template name="declare-namespace">
        declare namespace lexus="http://www.mpi.nl/lat/lexus";
    </xsl:template>
    
    <xsl:template name="users">
        declare function lexus:user-sequence($users as element()*)  as element()* {
            for $user in $users
                order by $user/name
                return element user {$user/@*, $user/*[local-name() = ('name', 'account', 'accesslevel', 'workspace')] }
        };
        declare function lexus:users($users as element()*)  as element()* {
            element users {lexus:user-sequence($users)}
        };
    </xsl:template>
    
    
    <xsl:template name="user-permissions">
        declare function lexus:canUpdateOrCreateUser($user as node()) as xs:boolean {
            (number($user/accesslevel) ge 30)
        };
        
        declare function lexus:isAdministrator($user as node()) as xs:boolean {
            (number($user/accesslevel) ge 30)
        };
    </xsl:template>
    
    
    <xsl:template name="schema-permissions">
        declare function lexus:canUpdateSchema($lexus as node(), $userId as xs:string) as xs:boolean {
            ($lexus/meta/users/user[@ref eq $userId]/permissions/write eq "true")
        };
    </xsl:template>

    <!-- 
        Given a list of lexus meta data nodes,
        return the list of lexica with the same ids, order by name.
    -->
    <xsl:template name="lexica">
        declare function lexus:lexica($lexica as node()*, $lexi as node()*) as node()* {
            element lexica {
                for $lexicon in $lexica
                    order by $lexi[@id eq $lexicon/@id]/meta/name
                    return element lexicon {
                        $lexicon/@*,
                        $lexi[@id eq $lexicon/@id]/meta,
                        element size {count($lexicon/lexical-entry)}
                    }
            }
        };
        
        declare function lexus:lexica2($lexi as node()*) as node()* {
            element lexica {
                for $lex in $lexi
                    let $lexicon := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexicon[@id eq $lex/@id]
                    order by $lex/meta/name
                    return element lexicon {
                        $lexicon/@*,
                        $lex/meta,
                        element size {count($lexicon/lexical-entry)
                    }
            }
        }
        };
    </xsl:template>
    
    
    <!-- 
        Return a lexicon's attributes (id) and meta data.
    -->
    <xsl:template name="lexicon">
        declare function lexus:lexicon($lexicon as node(), $lexi as node()*) as node()* {
            element lexicon {
                $lexicon/@*,
                $lexi[@id eq $lexicon/@id]/meta
            }
        };
    </xsl:template>
    
    
    <xsl:template name="log">
        declare function lexus:log($lexiconId as xs:string, $type as xs:string, $userId as xs:string, $username as xs:string, $logEntry as node()*) {
            let $log := collection('<xsl:value-of select="$dbpath"/>/lexica')/log[@id eq $lexiconId]
            let $entry :=  element entry {
                                attribute type {$type}, attribute date-time {current-dateTime()},
                                attribute user {$userId}, attribute username {$username},
                                $logEntry
                           }
            return update insert $entry into $log
        };        
    </xsl:template>
</xsl:stylesheet>
