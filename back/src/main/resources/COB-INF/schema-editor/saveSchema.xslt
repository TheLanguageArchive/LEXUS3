<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:json="http://apache.org/cocoon/json/1.0"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="endpoint"/>
    <xsl:param name="dbpath"/>

    <xsl:template match="/">
        <rest:request target="{$endpoint}{$dbpath}/lexica" method="POST">
            <rest:header name="Content-Type" value="text/xml; charset=UTF-8"/>
            <rest:body>
                <query xmlns="http://exist.sourceforge.net/NS/exist">
                    
                    <!--(: 
                    
                        Save a schema.
                        
                        Believe it or not, but we have to generate the whole shebang again!
                        Schema, lexicon, userinformation and sortorders, everything is 
                        serialised again in JSON!
                        
                        Brrr. So, we didn't choose XML because it used a few more bytes compared to JSON,
                        but THEN we transfer all that stuff that is not needed in JSON. As a professional
                        software developer I would have chosen XML and used a more modular commmunication model
                        where we wouldn't have to transmit all that useless information with EVERY REQUEST.
                        
                        I think all that is needed in a response here is 'success' or 'failure'. That will save
                        hundreds if not thousands of bytes and the client side will function just as well.
                    
                        This is a typical response:
                        
                                               {
                               "id": "Mon Jun 07 09:14:16 CEST 2010",
                               "result":         {
                                   "lexus": null,
                                   "schema":             {
                                       "min": 1,
                                       "adminInfo": "\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tto be filled out\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                       "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MTRhMDE=",
                                       "max": 1,
                                       "description": null,
                                       "name": "lexicon",
                                       "parent": null,
                                       "type": "Lexicon",
                                       "note": null,
                                       "style": null,
                                       "children":                 [
                                                               {
                                               "min": 1,
                                               "adminInfo": null,
                                               "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5OTRhNDA=",
                                               "max": 1,
                                               "description": "Contains administrative information and other general attributes",
                                               "name": "lexiconInformation",
                                               "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MTRhMDE=",
                                               "type": "component",
                                               "note": null,
                                               "style": null,
                                               "children": []
                                           },
                                                               {
                                               "min": 0,
                                               "adminInfo": null,
                                               "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MTRhMDI=",
                                               "max": null,
                                               "description": "Represents a word, a multi-word expression, or an affix in a given language",
                                               "name": "lexicalEntry",
                                               "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MTRhMDE=",
                                               "type": "LexicalEntry",
                                               "note": null,
                                               "style": null,
                                               "children": [                        {
                                                   "min": 0,
                                                   "adminInfo": "\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tto be filled out\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDQ=",
                                                   "max": null,
                                                   "description": "\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tto be filled out\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                                   "name": "lexemeGroup",
                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MTRhMDI=",
                                                   "type": "component",
                                                   "note": null,
                                                   "style": null,
                                                   "children":                             [
                                                                                       {
                                                           "min": 0,
                                                           "max": null,
                                                           "sortOrder":                                     {
                                                               "id": "MmM5MDkwYTIyMjk4MTNhMzAxMjJlZjc2YzM3OTA2Nzc=",
                                                               "description": "azazaz",
                                                               "fill": "?(b?)adcefghijklmnopqrstuvwxyz",
                                                               "name": "azazaz",
                                                               "data":                                         [
                                                                                                               {
                                                                       "startLetter": "?",
                                                                       "characters": "b?"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "a",
                                                                       "characters": "a"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "d",
                                                                       "characters": "d"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "c",
                                                                       "characters": "c"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "e",
                                                                       "characters": "e"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "f",
                                                                       "characters": "f"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "g",
                                                                       "characters": "g"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "h",
                                                                       "characters": "h"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "i",
                                                                       "characters": "i"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "j",
                                                                       "characters": "j"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "k",
                                                                       "characters": "k"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "l",
                                                                       "characters": "l"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "m",
                                                                       "characters": "m"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "n",
                                                                       "characters": "n"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "o",
                                                                       "characters": "o"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "p",
                                                                       "characters": "p"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "q",
                                                                       "characters": "q"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "r",
                                                                       "characters": "r"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "s",
                                                                       "characters": "s"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "t",
                                                                       "characters": "t"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "u",
                                                                       "characters": "u"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "v",
                                                                       "characters": "v"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "w",
                                                                       "characters": "w"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "x",
                                                                       "characters": "x"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "y",
                                                                       "characters": "y"
                                                                   },
                                                                                                               {
                                                                       "startLetter": "z",
                                                                       "characters": "z"
                                                                   }
                                                               ]
                                                           },
                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDQ=",
                                                           "DCRReference": null,
                                                           "type": "data category",
                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhM2E=",
                                                           "adminInfo": "-",
                                                           "valuedomain": [],
                                                           "description": "to be filled out",
                                                           "DCR": "user defined",
                                                           "name": "lexeme",
                                                           "note": null,
                                                           "style":                                     {
                                                               "textColor": "#990000",
                                                               "smallCaps": false,
                                                               "italic": false,
                                                               "fontSize": 14,
                                                               "textBefore": "",
                                                               "bold": true,
                                                               "textAfterUseStyle": "",
                                                               "textBeforeUseStyle": "",
                                                               "textAfterGroup": "",
                                                               "underline": false,
                                                               "textAfter": "",
                                                               "allCaps": false,
                                                               "textBeforeGroup": "",
                                                               "fontFamily": "Verdana",
                                                               "punctuationText": ""
                                                           }
                                                       },
                                                                                       {
                                                           "min": 0,
                                                           "max": null,
                                                           "sortOrder": null,
                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDQ=",
                                                           "DCRReference": "http://www.isocat.org/datcat/DC-1345",
                                                           "type": "data category",
                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMzI=",
                                                           "adminInfo": null,
                                                           "valuedomain": [],
                                                           "description": "Term used to describe how a particular word is used in a sentence.",
                                                           "DCR": "12620",
                                                           "name": "part of speech",
                                                           "note": null,
                                                           "style":                                     {
                                                               "textColor": null,
                                                               "smallCaps": false,
                                                               "italic": false,
                                                               "fontSize": 12,
                                                               "textBefore": null,
                                                               "bold": false,
                                                               "textAfterUseStyle": null,
                                                               "textBeforeUseStyle": null,
                                                               "textAfterGroup": null,
                                                               "underline": false,
                                                               "textAfter": null,
                                                               "allCaps": false,
                                                               "textBeforeGroup": null,
                                                               "fontFamily": null,
                                                               "punctuationText": null
                                                           }
                                                       },
                                                                                       {
                                                           "min": 0,
                                                           "max": null,
                                                           "sortOrder": null,
                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDQ=",
                                                           "DCRReference": "a",
                                                           "type": "data category",
                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMzQ=",
                                                           "adminInfo": null,
                                                           "valuedomain": [],
                                                           "description": null,
                                                           "DCR": "user defined",
                                                           "name": "alternative forms",
                                                           "note": null,
                                                           "style":                                     {
                                                               "textColor": null,
                                                               "smallCaps": false,
                                                               "italic": false,
                                                               "fontSize": 12,
                                                               "textBefore": null,
                                                               "bold": false,
                                                               "textAfterUseStyle": null,
                                                               "textBeforeUseStyle": null,
                                                               "textAfterGroup": null,
                                                               "underline": false,
                                                               "textAfter": null,
                                                               "allCaps": false,
                                                               "textBeforeGroup": null,
                                                               "fontFamily": null,
                                                               "punctuationText": null
                                                           }
                                                       },
                                                                                       {
                                                           "min": 0,
                                                           "max": null,
                                                           "sortOrder": null,
                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDQ=",
                                                           "DCRReference": "u",
                                                           "type": "data category",
                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMzA=",
                                                           "adminInfo": null,
                                                           "valuedomain": [],
                                                           "description": "uuuuuuuu",
                                                           "DCR": "user defined",
                                                           "name": "u",
                                                           "note": null,
                                                           "style":                                     {
                                                               "textColor": null,
                                                               "smallCaps": false,
                                                               "italic": false,
                                                               "fontSize": 12,
                                                               "textBefore": null,
                                                               "bold": false,
                                                               "textAfterUseStyle": null,
                                                               "textBeforeUseStyle": null,
                                                               "textAfterGroup": null,
                                                               "underline": false,
                                                               "textAfter": null,
                                                               "allCaps": false,
                                                               "textBeforeGroup": null,
                                                               "fontFamily": null,
                                                               "punctuationText": null
                                                           }
                                                       },
                                                                                       {
                                                           "min": 0,
                                                           "max": null,
                                                           "sortOrder": null,
                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDQ=",
                                                           "DCRReference": "dt",
                                                           "type": "data category",
                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMzY=",
                                                           "adminInfo": null,
                                                           "valuedomain": [],
                                                           "description": null,
                                                           "DCR": "user defined",
                                                           "name": "date",
                                                           "note": null,
                                                           "style":                                     {
                                                               "textColor": null,
                                                               "smallCaps": false,
                                                               "italic": false,
                                                               "fontSize": 12,
                                                               "textBefore": null,
                                                               "bold": false,
                                                               "textAfterUseStyle": null,
                                                               "textBeforeUseStyle": null,
                                                               "textAfterGroup": null,
                                                               "underline": false,
                                                               "textAfter": null,
                                                               "allCaps": false,
                                                               "textBeforeGroup": null,
                                                               "fontFamily": null,
                                                               "punctuationText": null
                                                           }
                                                       },
                                                                                       {
                                                           "min": 0,
                                                           "adminInfo": "\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tto be filled out\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                           "max": null,
                                                           "description": "\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tto be filled out\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                                           "name": "descriptionGroup",
                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDQ=",
                                                           "type": "component",
                                                           "note": null,
                                                           "style": null,
                                                           "children":                                     [
                                                                                                       {
                                                                   "min": 0,
                                                                   "max": null,
                                                                   "sortOrder": null,
                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                                   "DCRReference": null,
                                                                   "type": "data category",
                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMmU=",
                                                                   "adminInfo": "to be filled out",
                                                                   "valuedomain": [],
                                                                   "description": "to be filled out",
                                                                   "DCR": "user defined",
                                                                   "name": "description",
                                                                   "note": null,
                                                                   "style":                                             {
                                                                       "textColor": "#99",
                                                                       "smallCaps": false,
                                                                       "italic": true,
                                                                       "fontSize": 12,
                                                                       "textBefore": "",
                                                                       "bold": false,
                                                                       "textAfterUseStyle": "",
                                                                       "textBeforeUseStyle": "     ",
                                                                       "textAfterGroup": "",
                                                                       "underline": false,
                                                                       "textAfter": "",
                                                                       "allCaps": false,
                                                                       "textBeforeGroup": "",
                                                                       "fontFamily": "Arial",
                                                                       "punctuationText": ""
                                                                   }
                                                               },
                                                                                                       {
                                                                   "min": 0,
                                                                   "max": null,
                                                                   "sortOrder": null,
                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                                   "DCRReference": "ethnog",
                                                                   "type": "data category",
                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5NzRhMjg=",
                                                                   "adminInfo": null,
                                                                   "valuedomain": [],
                                                                   "description": null,
                                                                   "DCR": "user defined",
                                                                   "name": "ethnographical description",
                                                                   "note": null,
                                                                   "style":                                             {
                                                                       "textColor": null,
                                                                       "smallCaps": false,
                                                                       "italic": false,
                                                                       "fontSize": 12,
                                                                       "textBefore": null,
                                                                       "bold": false,
                                                                       "textAfterUseStyle": null,
                                                                       "textBeforeUseStyle": null,
                                                                       "textAfterGroup": null,
                                                                       "underline": false,
                                                                       "textAfter": null,
                                                                       "allCaps": false,
                                                                       "textBeforeGroup": null,
                                                                       "fontFamily": null,
                                                                       "punctuationText": null
                                                                   }
                                                               },
                                                                                                       {
                                                                   "min": 0,
                                                                   "max": null,
                                                                   "sortOrder": null,
                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                                   "DCRReference": "semset",
                                                                   "type": "data category",
                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMmE=",
                                                                   "adminInfo": null,
                                                                   "valuedomain": [],
                                                                   "description": null,
                                                                   "DCR": "user defined",
                                                                   "name": "semantic set",
                                                                   "note": null,
                                                                   "style":                                             {
                                                                       "textColor": null,
                                                                       "smallCaps": false,
                                                                       "italic": false,
                                                                       "fontSize": 12,
                                                                       "textBefore": null,
                                                                       "bold": false,
                                                                       "textAfterUseStyle": null,
                                                                       "textBeforeUseStyle": null,
                                                                       "textAfterGroup": null,
                                                                       "underline": false,
                                                                       "textAfter": null,
                                                                       "allCaps": false,
                                                                       "textBeforeGroup": null,
                                                                       "fontFamily": null,
                                                                       "punctuationText": null
                                                                   }
                                                               },
                                                                                                       {
                                                                   "min": 0,
                                                                   "max": null,
                                                                   "sortOrder": null,
                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                                   "DCRReference": null,
                                                                   "type": "data category",
                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDUyMjMyMDRhNmQ=",
                                                                   "adminInfo": "to be filled out",
                                                                   "valuedomain": [],
                                                                   "description": "to be filled out",
                                                                   "DCR": "user defined",
                                                                   "name": "image",
                                                                   "note": null,
                                                                   "style":                                             {
                                                                       "textColor": null,
                                                                       "smallCaps": false,
                                                                       "italic": false,
                                                                       "fontSize": 12,
                                                                       "textBefore": null,
                                                                       "bold": false,
                                                                       "textAfterUseStyle": null,
                                                                       "textBeforeUseStyle": null,
                                                                       "textAfterGroup": null,
                                                                       "underline": false,
                                                                       "textAfter": null,
                                                                       "allCaps": false,
                                                                       "textBeforeGroup": null,
                                                                       "fontFamily": null,
                                                                       "punctuationText": null
                                                                   }
                                                               },
                                                                                                       {
                                                                   "min": 0,
                                                                   "max": null,
                                                                   "sortOrder": null,
                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                                   "DCRReference": "note",
                                                                   "type": "data category",
                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5ODRhMmM=",
                                                                   "adminInfo": null,
                                                                   "valuedomain": [],
                                                                   "description": null,
                                                                   "DCR": "user defined",
                                                                   "name": "note",
                                                                   "note": null,
                                                                   "style":                                             {
                                                                       "textColor": null,
                                                                       "smallCaps": false,
                                                                       "italic": false,
                                                                       "fontSize": 12,
                                                                       "textBefore": null,
                                                                       "bold": false,
                                                                       "textAfterUseStyle": null,
                                                                       "textBeforeUseStyle": null,
                                                                       "textAfterGroup": null,
                                                                       "underline": false,
                                                                       "textAfter": null,
                                                                       "allCaps": false,
                                                                       "textBeforeGroup": null,
                                                                       "fontFamily": null,
                                                                       "punctuationText": null
                                                                   }
                                                               },
                                                                                                       {
                                                                   "min": 0,
                                                                   "max": null,
                                                                   "sortOrder": null,
                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                                   "DCRReference": null,
                                                                   "type": "data category",
                                                                   "id": "MmM5MDkwYTIyMTc4MmI5YjAxMjE4YmY1ZjExZTAzZjU=",
                                                                   "adminInfo": "",
                                                                   "valuedomain": [],
                                                                   "description": "",
                                                                   "DCR": null,
                                                                   "name": "video",
                                                                   "note": "",
                                                                   "style":                                             {
                                                                       "textColor": "",
                                                                       "smallCaps": false,
                                                                       "italic": false,
                                                                       "fontSize": 12,
                                                                       "textBefore": "",
                                                                       "bold": false,
                                                                       "textAfterUseStyle": "",
                                                                       "textBeforeUseStyle": "",
                                                                       "textAfterGroup": "",
                                                                       "underline": false,
                                                                       "textAfter": "",
                                                                       "allCaps": false,
                                                                       "textBeforeGroup": "",
                                                                       "fontFamily": "",
                                                                       "punctuationText": ""
                                                                   }
                                                               },
                                                                                                       {
                                                                   "min": 0,
                                                                   "adminInfo": "\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tto be filled out\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDg=",
                                                                   "max": null,
                                                                   "description": "\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tto be filled out\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                                                   "name": "VGroup",
                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                                   "type": "component",
                                                                   "note": null,
                                                                   "style": null,
                                                                   "children":                                             [
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDg=",
                                                                           "DCRReference": "V",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMTA=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "V",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       },
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDg=",
                                                                           "DCRReference": "CI",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMTY=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "CI",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       },
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDg=",
                                                                           "DCRReference": "followed",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMTg=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "followed",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       },
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDg=",
                                                                           "DCRReference": "imp",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMTQ=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "imperative",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       },
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDg=",
                                                                           "DCRReference": "proxpast",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMTI=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "proxpast",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       },
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDg=",
                                                                           "DCRReference": "rempast",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMWE=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "rempast",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       },
                                                                                                                       {
                                                                           "min": 0,
                                                                           "adminInfo": "\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tto be filled out\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMGE=",
                                                                           "max": null,
                                                                           "description": "\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tto be filled out\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                                                           "name": "gGroup",
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDg=",
                                                                           "type": "component",
                                                                           "note": null,
                                                                           "style": null,
                                                                           "children":                                                     [
                                                                                                                                       {
                                                                                   "min": 0,
                                                                                   "max": null,
                                                                                   "sortOrder": null,
                                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMGE=",
                                                                                   "DCRReference": "g",
                                                                                   "type": "data category",
                                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMGU=",
                                                                                   "adminInfo": null,
                                                                                   "valuedomain": [],
                                                                                   "description": null,
                                                                                   "DCR": "user defined",
                                                                                   "name": "g",
                                                                                   "note": null,
                                                                                   "style":                                                             {
                                                                                       "textColor": null,
                                                                                       "smallCaps": false,
                                                                                       "italic": false,
                                                                                       "fontSize": 12,
                                                                                       "textBefore": null,
                                                                                       "bold": false,
                                                                                       "textAfterUseStyle": null,
                                                                                       "textBeforeUseStyle": null,
                                                                                       "textAfterGroup": null,
                                                                                       "underline": false,
                                                                                       "textAfter": null,
                                                                                       "allCaps": false,
                                                                                       "textBeforeGroup": null,
                                                                                       "fontFamily": null,
                                                                                       "punctuationText": null
                                                                                   }
                                                                               },
                                                                                                                                       {
                                                                                   "min": 0,
                                                                                   "max": null,
                                                                                   "sortOrder": null,
                                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMGE=",
                                                                                   "DCRReference": "code",
                                                                                   "type": "data category",
                                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMGM=",
                                                                                   "adminInfo": null,
                                                                                   "valuedomain": [],
                                                                                   "description": null,
                                                                                   "DCR": "user defined",
                                                                                   "name": "codes for verbs",
                                                                                   "note": null,
                                                                                   "style":                                                             {
                                                                                       "textColor": null,
                                                                                       "smallCaps": false,
                                                                                       "italic": false,
                                                                                       "fontSize": 12,
                                                                                       "textBefore": null,
                                                                                       "bold": false,
                                                                                       "textAfterUseStyle": null,
                                                                                       "textBeforeUseStyle": null,
                                                                                       "textAfterGroup": null,
                                                                                       "underline": false,
                                                                                       "textAfter": null,
                                                                                       "allCaps": false,
                                                                                       "textBeforeGroup": null,
                                                                                       "fontFamily": null,
                                                                                       "punctuationText": null
                                                                                   }
                                                                               }
                                                                           ]
                                                                       }
                                                                   ]
                                                               },
                                                                                                       {
                                                                   "min": 0,
                                                                   "adminInfo": null,
                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMWM=",
                                                                   "max": null,
                                                                   "description": null,
                                                                   "name": "example sentenceGroup",
                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                                   "type": "component",
                                                                   "note": null,
                                                                   "style": null,
                                                                   "children":                                             [
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMWM=",
                                                                           "DCRReference": "e",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5NDRhMWU=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "example sentence",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       },
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MzRhMWM=",
                                                                           "DCRReference": "f",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5NDRhMjA=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "translation of example",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       }
                                                                   ]
                                                               },
                                                                                                       {
                                                                   "min": 0,
                                                                   "adminInfo": null,
                                                                   "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5NzRhMjI=",
                                                                   "max": null,
                                                                   "description": null,
                                                                   "name": "iGroup",
                                                                   "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5MjRhMDY=",
                                                                   "type": "component",
                                                                   "note": null,
                                                                   "style": null,
                                                                   "children":                                             [
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5NzRhMjI=",
                                                                           "DCRReference": "i",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5NzRhMjQ=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "i",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       },
                                                                                                                       {
                                                                           "min": 0,
                                                                           "max": null,
                                                                           "sortOrder": null,
                                                                           "parent": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5NzRhMjI=",
                                                                           "DCRReference": "j",
                                                                           "type": "data category",
                                                                           "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ2OTg5NzRhMjY=",
                                                                           "adminInfo": null,
                                                                           "valuedomain": [],
                                                                           "description": null,
                                                                           "DCR": "user defined",
                                                                           "name": "translation of i",
                                                                           "note": null,
                                                                           "style":                                                     {
                                                                               "textColor": null,
                                                                               "smallCaps": false,
                                                                               "italic": false,
                                                                               "fontSize": 12,
                                                                               "textBefore": null,
                                                                               "bold": false,
                                                                               "textAfterUseStyle": null,
                                                                               "textBeforeUseStyle": null,
                                                                               "textAfterGroup": null,
                                                                               "underline": false,
                                                                               "textAfter": null,
                                                                               "allCaps": false,
                                                                               "textBeforeGroup": null,
                                                                               "fontFamily": null,
                                                                               "punctuationText": null
                                                                           }
                                                                       }
                                                                   ]
                                                               }
                                                           ]
                                                       }
                                                   ]
                                               }]
                                           }
                                       ]
                                   },
                                   "lexicon":             {
                                       "id": "MmM5MDkwYTIxNjdjMjFkNzAxMTY4MDQ3ZmRjZTRhNDU=",
                                       "todos": [],
                                       "description": "???? ?????????????",
                                       "administrator": false,
                                       "writable": true,
                                       "name": "???????? 89 ?? Yeli D'nye!",
                                       "type": "myLexicon",
                                       "note": "???? ???? ??? ??????????? ??asdf asdf asdf asdf asdf asdf asf??? ,????? ,???? ??????? ?????? "
                                   },
                                   "sortOrders":             [
                                                       {
                                           "id": "MmM5MDk5YjEyODNhYTFlNzAxMjgzYWEzMTlkOTAwMDE=",
                                           "description": "qwqwqwqwqwqw",
                                           "fill": "abcdefghijklmnopqrstuvwxyz",
                                           "name": "qwqwqwqwqw",
                                           "data":                     [
                                                                       {
                                                   "startLetter": "a",
                                                   "characters": "a"
                                               },
                                                                       {
                                                   "startLetter": "b",
                                                   "characters": "b"
                                               },
                                                                       {
                                                   "startLetter": "c",
                                                   "characters": "c"
                                               },
                                                                       {
                                                   "startLetter": "d",
                                                   "characters": "d"
                                               },
                                                                       {
                                                   "startLetter": "e",
                                                   "characters": "e"
                                               },
                                                                       {
                                                   "startLetter": "f",
                                                   "characters": "f"
                                               },
                                                                       {
                                                   "startLetter": "g",
                                                   "characters": "g"
                                               },
                                                                       {
                                                   "startLetter": "h",
                                                   "characters": "h"
                                               },
                                                                       {
                                                   "startLetter": "i",
                                                   "characters": "i"
                                               },
                                                                       {
                                                   "startLetter": "j",
                                                   "characters": "j"
                                               },
                                                                       {
                                                   "startLetter": "k",
                                                   "characters": "k"
                                               },
                                                                       {
                                                   "startLetter": "l",
                                                   "characters": "l"
                                               },
                                                                       {
                                                   "startLetter": "m",
                                                   "characters": "m"
                                               },
                                                                       {
                                                   "startLetter": "n",
                                                   "characters": "n"
                                               },
                                                                       {
                                                   "startLetter": "o",
                                                   "characters": "o"
                                               },
                                                                       {
                                                   "startLetter": "p",
                                                   "characters": "p"
                                               },
                                                                       {
                                                   "startLetter": "q",
                                                   "characters": "q"
                                               },
                                                                       {
                                                   "startLetter": "r",
                                                   "characters": "r"
                                               },
                                                                       {
                                                   "startLetter": "s",
                                                   "characters": "s"
                                               },
                                                                       {
                                                   "startLetter": "t",
                                                   "characters": "t"
                                               },
                                                                       {
                                                   "startLetter": "u",
                                                   "characters": "u"
                                               },
                                                                       {
                                                   "startLetter": "v",
                                                   "characters": "v"
                                               },
                                                                       {
                                                   "startLetter": "w",
                                                   "characters": "w"
                                               },
                                                                       {
                                                   "startLetter": "x",
                                                   "characters": "x"
                                               },
                                                                       {
                                                   "startLetter": "y",
                                                   "characters": "y"
                                               },
                                                                       {
                                                   "startLetter": "z",
                                                   "characters": "z"
                                               }
                                           ]
                                       },
                                                       {
                                           "id": "MmM5MDkwYTIyMjk4MTNhMzAxMjJlZjc2YzM3OTA2Nzc=",
                                           "description": "azazaz",
                                           "fill": "?(b?)adcefghijklmnopqrstuvwxyz",
                                           "name": "azazaz",
                                           "data":                     [
                                                                       {
                                                   "startLetter": "?",
                                                   "characters": "b?"
                                               },
                                                                       {
                                                   "startLetter": "a",
                                                   "characters": "a"
                                               },
                                                                       {
                                                   "startLetter": "d",
                                                   "characters": "d"
                                               },
                                                                       {
                                                   "startLetter": "c",
                                                   "characters": "c"
                                               },
                                                                       {
                                                   "startLetter": "e",
                                                   "characters": "e"
                                               },
                                                                       {
                                                   "startLetter": "f",
                                                   "characters": "f"
                                               },
                                                                       {
                                                   "startLetter": "g",
                                                   "characters": "g"
                                               },
                                                                       {
                                                   "startLetter": "h",
                                                   "characters": "h"
                                               },
                                                                       {
                                                   "startLetter": "i",
                                                   "characters": "i"
                                               },
                                                                       {
                                                   "startLetter": "j",
                                                   "characters": "j"
                                               },
                                                                       {
                                                   "startLetter": "k",
                                                   "characters": "k"
                                               },
                                                                       {
                                                   "startLetter": "l",
                                                   "characters": "l"
                                               },
                                                                       {
                                                   "startLetter": "m",
                                                   "characters": "m"
                                               },
                                                                       {
                                                   "startLetter": "n",
                                                   "characters": "n"
                                               },
                                                                       {
                                                   "startLetter": "o",
                                                   "characters": "o"
                                               },
                                                                       {
                                                   "startLetter": "p",
                                                   "characters": "p"
                                               },
                                                                       {
                                                   "startLetter": "q",
                                                   "characters": "q"
                                               },
                                                                       {
                                                   "startLetter": "r",
                                                   "characters": "r"
                                               },
                                                                       {
                                                   "startLetter": "s",
                                                   "characters": "s"
                                               },
                                                                       {
                                                   "startLetter": "t",
                                                   "characters": "t"
                                               },
                                                                       {
                                                   "startLetter": "u",
                                                   "characters": "u"
                                               },
                                                                       {
                                                   "startLetter": "v",
                                                   "characters": "v"
                                               },
                                                                       {
                                                   "startLetter": "w",
                                                   "characters": "w"
                                               },
                                                                       {
                                                   "startLetter": "x",
                                                   "characters": "x"
                                               },
                                                                       {
                                                   "startLetter": "y",
                                                   "characters": "y"
                                               },
                                                                       {
                                                   "startLetter": "z",
                                                   "characters": "z"
                                               }
                                           ]
                                       },
                                                       {
                                           "id": "MmM5MDk5YjQyODI2MzQ3ZTAxMjgyNjNiZjBhNzAwMDE=",
                                           "description": "descr",
                                           "fill": "abcdefghijklmnopqrstuvwxyz",
                                           "name": "nummer twee",
                                           "data":                     [
                                                                       {
                                                   "startLetter": "a",
                                                   "characters": "a"
                                               },
                                                                       {
                                                   "startLetter": "b",
                                                   "characters": "b"
                                               },
                                                                       {
                                                   "startLetter": "c",
                                                   "characters": "c"
                                               },
                                                                       {
                                                   "startLetter": "d",
                                                   "characters": "d"
                                               },
                                                                       {
                                                   "startLetter": "e",
                                                   "characters": "e"
                                               },
                                                                       {
                                                   "startLetter": "f",
                                                   "characters": "f"
                                               },
                                                                       {
                                                   "startLetter": "g",
                                                   "characters": "g"
                                               },
                                                                       {
                                                   "startLetter": "h",
                                                   "characters": "h"
                                               },
                                                                       {
                                                   "startLetter": "i",
                                                   "characters": "i"
                                               },
                                                                       {
                                                   "startLetter": "j",
                                                   "characters": "j"
                                               },
                                                                       {
                                                   "startLetter": "k",
                                                   "characters": "k"
                                               },
                                                                       {
                                                   "startLetter": "l",
                                                   "characters": "l"
                                               },
                                                                       {
                                                   "startLetter": "m",
                                                   "characters": "m"
                                               },
                                                                       {
                                                   "startLetter": "n",
                                                   "characters": "n"
                                               },
                                                                       {
                                                   "startLetter": "o",
                                                   "characters": "o"
                                               },
                                                                       {
                                                   "startLetter": "p",
                                                   "characters": "p"
                                               },
                                                                       {
                                                   "startLetter": "q",
                                                   "characters": "q"
                                               },
                                                                       {
                                                   "startLetter": "r",
                                                   "characters": "r"
                                               },
                                                                       {
                                                   "startLetter": "s",
                                                   "characters": "s"
                                               },
                                                                       {
                                                   "startLetter": "t",
                                                   "characters": "t"
                                               },
                                                                       {
                                                   "startLetter": "u",
                                                   "characters": "u"
                                               },
                                                                       {
                                                   "startLetter": "v",
                                                   "characters": "v"
                                               },
                                                                       {
                                                   "startLetter": "w",
                                                   "characters": "w"
                                               },
                                                                       {
                                                   "startLetter": "x",
                                                   "characters": "x"
                                               },
                                                                       {
                                                   "startLetter": "y",
                                                   "characters": "y"
                                               },
                                                                       {
                                                   "startLetter": "z",
                                                   "characters": "z"
                                               }
                                           ]
                                       }
                                   ],
                                   "user":             {
                                       "id": "MmM5MDkwYTIyMjk4MTNiOTAxMjJkZjQ0MDNiNTAwMDg=",
                                       "accesslevel": 10,
                                       "administrator": false,
                                       "name": "Huib Verweij"
                                   }
                               },
                               "requester": "SchemaEditor1642",
                               "status":         {
                                   "message": "At your service",
                                   "duration": "1874",
                                   "insync": true,
                                   "success": true
                               },
                               "requestId": "6EBB4656-4DF9-EFDB-E096-11427AD57204"
                           }
                           
                       Seriously? Yes, seriously.
                       
                       And... "The best is yet to come!"
                       
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
                    <text>
                        
                        <xsl:call-template name="declare-namespace"/>
                        <xsl:call-template name="schema-permissions"/>
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
                        let $newData := <xsl:apply-templates select="/data/lexus:save-schema/schema" mode="encoded"/>
                        let $lexus := collection('<xsl:value-of select="$dbpath"/>/lexica')/lexus[@id eq $newData/component[1]/@id]
                        return
                            if (lexus:canUpdateSchema($lexus, $userId))
                                then let $returnValue := lexus:updateSchema($newData, $lexus)
                                     let $dummy := lexus:log($lexus/@id, 'save-schema', $userId, $username, $newData)
                                     return $returnValue
                                else element exception {attribute id {"LEX001"}, element message {concat("Permission denied, user '<xsl:value-of select="/data/user/name"/>' ('<xsl:value-of select="/data/user/account"/>', ",$userId, ") cannot update schema for lexicon '", $lexus/meta/name, "' (", $newData/component/@id)}}
                    </text>
                    <properties>
                        <property name="pretty-print" value="no"/>
                    </properties>
                </query>
            </rest:body>
        </rest:request>
    </xsl:template>
    
</xsl:stylesheet>
