<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:json="http://apache.org/cocoon/json/1.0" version="2.0">


    <!--
        Declare the lexus namespace in an XQuery
        -->
    <xsl:template name="declare-namespace">
        declare namespace lexus="http://www.mpi.nl/lat/lexus";
    </xsl:template>
    
    <!--
        XQuery functions for handling users.
    -->
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
    
    <!--
        XQuery functions for checking permissions.
    -->    
    <xsl:template name="permissions">        
        declare function lexus:isAdministrator($user as node()) as xs:boolean {
            (number($user/accesslevel) ge 30)
        };
        
        
        declare function lexus:canRead($lexusMeta as node()*, $user as node()) as xs:boolean {
            if (lexus:isAdministrator($user)) then true()
            else
                $lexusMeta/users/user[@ref eq $user/@id]/permissions/read eq "true" 
        };
        
        
        declare function lexus:canWrite($lexusMeta as node()*, $user as node()) as xs:boolean {
            if (lexus:isAdministrator($user))
                then true()
                else
                    if (empty($lexusMeta))
                        then false()
                        else
                            let $write := $lexusMeta/users/user[@ref eq $user/@id]/permissions/write
                            return
                                if (empty($write))
                                    then false()
                                    else $write eq "true"
        };
        
        
        declare function lexus:isOwner($lexusMeta as node()*, $user as node()) as xs:boolean {
            if (empty($lexusMeta))
                then false()
                else $lexusMeta/owner/@ref eq $user/@id
        };
    </xsl:template>
    
    <!--
        XQuery functions for checking user management permissions.
    -->    
    <xsl:template name="user-permissions">
        declare function lexus:canUpdateOrCreateUser($user as node()) as xs:boolean {
            lexus:isAdministrator($user)
        };
    </xsl:template>
    
    <!--
        XQuery functions for checking schema management permissions.
    -->
    <xsl:template name="schema-permissions">
        declare function lexus:canUpdateSchema($lexusMeta as node()*, $user as node()) as xs:boolean {
            lexus:canWrite($lexusMeta, $user)
        };
    </xsl:template>
    
    <!--
        XQuery functions for checking lexicon management permissions.
    -->
    <xsl:template name="lexicon-permissions">
        declare function lexus:canDeleteLexicon($lexusMeta as node()*, $user as node()) as xs:boolean {
            lexus:isOwner($lexusMeta, $user) or lexus:isAdministrator($user)
        };
    </xsl:template>
    <!--
        XQuery functions for checking view management permissions.
    -->    
    <xsl:template name="view-permissions">
        declare function lexus:canCreateView($lexusMeta as node()*, $user as node()) as xs:boolean {
            lexus:canWrite($lexusMeta, $user)
        };
        
        
        declare function lexus:canDeleteView($lexusMeta as node()*, $user as node()) as xs:boolean {
            lexus:canCreateView($lexusMeta, $user)
        };
        
        
        declare function lexus:canReadViews($lexusMeta as node()*, $user as node()) as xs:boolean {
            if (lexus:isAdministrator($user)) then true()
            else
                $lexusMeta/users/user[@ref eq $user/@id]/permissions/read eq "true" or
                $lexusMeta/users/user[@ref eq $user/@id]/permissions/write eq "true" 
        };
    </xsl:template>
    
    <!-- 
        Given a list of lexus nodes,
        return the list of lexica with the same ids, order by name.
    -->
    <xsl:template name="lexica">
        
        (: return a list of lexica (lexicon is inside lexus element next to meta element) :)
        declare function lexus:lexica($lexi as node()*) as node()* {
            lexus:lexica($lexi, false())
        };
        declare function lexus:lexica($lexi as node()*, $admin as xs:boolean) as node()* {
            element lexica {
                for $lexus in $lexi
                    order by $lexus/meta/name
                    return element lexicon {
                        $lexus/lexicon/@*,
                        element meta {$lexus/meta/*[local-name() ne 'schema']},
                        element size {if ($admin) then '' else count($lexus/lexicon/lexical-entry)}
                    }
            }
        };
        
        
    </xsl:template>
    
    
    <xsl:template name="lexicon3">
        
        (: return a lexicon in the lexus:lexica format :)
        declare function lexus:lexicon($lexus as node()) as node() {
        element lexicon {
            $lexus/lexicon/@*,
            element meta { $lexus/meta/*[local-name() ne 'schema']},
            element size {count($lexus/lexicon/lexical-entry)}
        }
        };
        
        
    </xsl:template>
    
    <!-- 
        Return a lexicon's attributes (id) and meta data.
    -->
    <xsl:template name="lexicon">
        declare function lexus:lexicon($lexus as node()) as node()* {
            element lexicon {
                $lexus/lexicon/@*,
                $lexus/meta
            }
        };
    </xsl:template>
    
    
    <!--
        XQuery functions for logging changes to a lexicon.
    -->
    <xsl:template name="log">
        
        (: declare updating function lexus:log-entry($log as node(), $entry as node()) {
            insert node $entry into $log
            };  :)
            
            
        declare function lexus:log($lexiconId as xs:string, $type as xs:string, $userId as xs:string, $username as xs:string, $logEntry as node()*) {
            let $log := collection('<xsl:value-of select="$lexica-collection"/>')/log[@id eq $lexiconId]
            let $entry :=  element entry {
                                attribute type {$type}, attribute date-time {current-dateTime()},
                                attribute user {$userId}, attribute username {$username},
                                $logEntry
                           }
            return () (: lexus:log-entry($log, $entry) :)
        };        
    </xsl:template>
</xsl:stylesheet>
