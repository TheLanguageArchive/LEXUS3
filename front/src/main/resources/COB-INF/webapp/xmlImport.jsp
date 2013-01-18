<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h"%>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f"%>
<%@ taglib uri="http://myfaces.apache.org/tomahawk" prefix="t"%>

<!--
/*
 * Copyright 2005 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//-->
<html>
<%--
<%@include file="inc/head.inc" %>
 --%>
 <head>
 <link rel="stylesheet" type="text/css" href="styles/ConventionsLana.css" />
 <link rel="stylesheet" type="text/css" href="styles/xmlImport.css" />
 <link rel=stylesheet type="text/css" href="styles/contextmenu.css">
 <style type="text/css">
 span{
 	zoom:1;//necessary for IE
 }
</style>
 <script type="text/javascript">
 var lastId = null;
 var cutNodeId=null;	
 var mode = null;
 
 	function selectCutNode(){
 		cutNodeId = lastId;
 		lastId = null;
 		
 	}
 	
 	function selectNode( a_identifier){ 
 		lastId = a_identifier;
 		mode="All";
 	}
 	function selectLMFNode( a_identifier){
		 lastId = a_identifier;
		 mode= "LMF";
 	}
 	function selectDCNode( a_identifier){
 		lastId = a_identifier;
		 mode= "DC";
 	}
 	
 	function pasteNode(){
	 		if( cutNodeId !=null && lastId !=null){
	 			if( cutNodeId.indexOf( lastId) !=-1){
	 				//we are in the direct path here
	 				submitPasteNode( cutNodeId, lastId);
	 			}
	 			else{
	 				//evaluating whether we have a neightbour 
	 				var index = lastId.lastIndexOf("/");
	 				if( cutNodeId.indexOf( lastId.substring(0, index+1)) !=-1){
	 					submitPasteNode( cutNodeId, lastId);
	 				}
	 				else{
	 					alert("You may NOT paste a node here");
	 				}
	 			}
	 			
	 		}
	 		else{
	 			alert("Please select an element to paste.");
	 		}
	 		cutNodeId = null;
	 		lastId = null;
 	}
 	
 	function deleteNode(){
	 	if( confirm("Are you sure you want to delete this element?")){
			submitDeleteNode( lastId);
			lastId = null;
 		}
 	}
 	
 	
 	function submitPasteNode( a_cutNodeId, a_pasteNodeId){
 	
 	
 	
 		var form = document.getElementById("paste");
 		var el = document.createElement("input");
 		el.setAttribute( "name","pasteNode");
 		el.setAttribute( "value", a_pasteNodeId);
 		el.setAttribute( "type","hidden");
 		form.appendChild( el);
 		el = document.createElement("input");
		el.setAttribute( "name","cutNode");
		el.setAttribute( "value", a_cutNodeId);
		el.setAttribute( "type","hidden");
 		form.appendChild( el);
 		
 		
 		var fireOnThis = document.getElementById("pasteLink");
 		
 		if( document.createEvent){
 			
 			var evtObj = document.createEvent("MouseEvents");
 			evtObj.initEvent( 'click', true, false);
 			fireOnThis.dispatchEvent( evtObj);
 		}
 		else if( document.createEventObject){
 			fireOnThis.fireEvent('onclick');
 		}
 		
 	}
 	
 	function submitDeleteNode( a_deleteNodeId){
	 	
	 	
	 	
	 		var form = document.getElementById("paste");
	 		var el = document.createElement("input");
	 		el.setAttribute( "name","deleteNode");
	 		el.setAttribute( "value", a_deleteNodeId);
	 		el.setAttribute( "type","hidden");
	 		form.appendChild( el);
	 			 		
	 		
	 		var fireOnThis = document.getElementById("deleteLink");
	 		
	 		if( document.createEvent){
	 			
	 			var evtObj = document.createEvent("MouseEvents");
	 			evtObj.initEvent( 'click', true, false);
	 			fireOnThis.dispatchEvent( evtObj);
	 		}
	 		else if( document.createEventObject){
	 			fireOnThis.fireEvent('onclick');
	 		}
	 		
 	}
 	
 	
 	function showMenu (evt) {
		 evt=evt?evt:evt=window.event;
		 var srcElem = evt.target?evt.target:window.event.srcElement;
		  if( srcElem==document.body){
			return false;
		  }
	
		  //
		  /*while( !srcElem.getAttribute("_leID") && srcElem !=document.body){
		  	srcElem = srcElem.parentNode;
		  }
	
		  if( !srcElem.getAttribute("_leID") ){
		  	return false;
		  }
	
	
		  elm = srcElem;
		  */
		  customizeMenu();
		  
		  var cntxtMn = document.getElementById("contextMenu");
		  var top = top=document.all?document.body.scrollTop:window.pageYOffset;
		  	
		  var left = document.all?document.body.scrollLeft:window.pageXOffset;
		  cntxtMn.style.left =evt.clientX + left-10;
		  cntxtMn.style.top =evt.clientY + top-10;

		  //cntxtMn.style.left =evt.clientX-10;
		  //cntxtMn.style.top =evt.clientY-10;
		  cntxtMn.style.visibility = 'visible';
		  cntxtMn.style.zIndex=999;
		  if(is_ffox)evt.stopPropagation();
	
		  return false;
	}
	function customizeMenu(){
		
		switch( mode){
				case "LMF":
					document.getElementById("cutMenuItem").style.display="none";
					document.getElementById("pasteMenuItem").style.display="";
					document.getElementById("deleteMenuItem").style.display="none";
					break;
				case "DC":
					document.getElementById("pasteMenuItem").style.display="none";
					document.getElementById("cutMenuItem").style.display="";										
					document.getElementById("deleteMenuItem").style.display="";
					break;
				
				default:
					document.getElementById("cutMenuItem").style.display="";
					document.getElementById("pasteMenuItem").style.display="";
					document.getElementById("deleteMenuItem").style.display="";
					break;
		}
	}
	
	
	var agt = navigator.userAgent.toLowerCase();
	var is_ffox = (agt.indexOf('mozilla')!=-1)&&(agt.indexOf('gecko')!=-1)&&(agt.indexOf('firefox')!=-1);
 	
 	document.oncontextmenu =showMenu;	 
 </script>
 </head>
<body>


<f:view>



    <!-- Expand/Collapse Handled By Client -->

    <%--
    NOTE: There is no commandLink for the folders because the toggling of expand/collapse is handled on the client
    via javascript.  We have a command link for document but that is really application specific.  In a real application
    you would likely specify an action method/listener and do something interesting with the node identifier that is
    submitted.

    First child in the expand/collapse facet should be image (if any)
    --%>
    <h1>XML schema and data import.</h1>
    
    <h:form id="form1" enctype="multipart/form-data" rendered="#{!treeBacker.treeActive}">
	        <p>
	        <h:outputText styleClass='info' value="This page allows you to import a xml lexicon. You may customize the LMF lexicon in the next step."/>
	        </p>
	        
	        <t:div styleClass='groupBox' style="margin:10">
	        <h:outputText styleClass='info' value="Please specify a name and description for the lexicon to import and select the schema and data files."/>
	        <p/>
	        <h:panelGrid columns='3'>
	        
	        <h:outputText styleClass='fieldLabel' value="Lexicon name: "/>
	        <t:inputText id='lexiconName' required='true' value="#{treeBacker.lexiconName}"/>
	        <h:message for="lexiconName" showDetail="true" />
	        
	        <h:outputText styleClass='fieldLabel' value="Description:"/>
	        <t:inputTextarea id='description' value="#{treeBacker.description}"/>
	        <h:message for="description" showDetail="true" />
	        
	        <h:outputText styleClass='fieldLabel' value="Root element: "/>
				        <t:inputText id='rootName' required='true' value="#{treeBacker.rootName}"/>
	        <h:message for="rootName" showDetail="true" />
	        
	        <h:outputText styleClass="info" value="Please select your xml schema and data files to upload."/>
			<h:outputText/>
    		<h:outputText/>       
    		</h:panelGrid>
    		
    		<h:panelGrid columns='3'>
    		
	        <h:outputText styleClass='fieldLabel' value="Please select the schema file."/>
	            <t:inputFileUpload id="schemaupload"
	                               accept="text/xml"
	                               value="#{treeBacker.schemaFile}"
	                               storage="file"
	                               styleClass="fileUploadInput"
	                               required="true"
	                               maxlength="200000"/>
			   <h:message for="schemaupload" showDetail="true" />
			   
			   
			   <h:outputText styleClass='fieldLabel' value="Please select the data file."/>
			   <t:inputFileUpload id="dataupload"
							   accept="text/xml"
							   value="#{treeBacker.dataFile}"
							   storage="file"
							   styleClass="fileUploadInput"
							   required="true"
			   maxlength="200000"/>
	            <h:message for="dataupload" showDetail="true" />
	        </h:panelGrid>
	            <h:commandButton value="Continue" action="#{treeBacker.processSchema}" />
	        </t:div>
	        
        </h:form>
        
        
<h:form id="paste" rendered="#{treeBacker.treeActive}">
	
   
   				    	
   
   
    <t:tree2 id="clientTree" value="#{treeBacker.treeData}" var="node" varNodeToggler="t" >
        <f:facet name="root">
            <h:panelGroup>
                <f:facet name="expand">
                    <t:graphicImage value="images/xmlImport/yellow-folder-open.png" rendered="#{t.nodeExpanded}" border="0"/>
                </f:facet>
                <f:facet name="collapse">
                    <t:graphicImage value="images/xmlImport/yellow-folder-closed.png" rendered="#{!t.nodeExpanded}" border="0"/>
                </f:facet>
                <h:outputText value="#{node.description}" styleClass="nodeFolder"/>
                <t:commandLink id="pasteLink" forceId="true" style="display:none;visibility:hidden" immediate="true" actionListener="#{treeBacker.pasteNode}">
				    	
    			</t:commandLink>
    			<t:commandLink id="deleteLink" forceId="true" style="display:none;visibility:hidden" immediate="true" actionListener="#{treeBacker.deleteNode}">
								    	
    			</t:commandLink>
    			
            </h:panelGroup>
        </f:facet>
        
        <f:facet name="LMF">
            <h:panelGroup>
                <f:facet name="expand">
                    <t:graphicImage value="images/xmlImport/component.gif" rendered="#{t.nodeExpanded}" border="0"/>
                </f:facet>
                <f:facet name="collapse">
                    <t:graphicImage value="images/xmlImport/component.gif" rendered="#{!t.nodeExpanded}" border="0"/>
                </f:facet>
                <h:commandLink styleClass="#{t.nodeSelected ? 'documentSelected':'document'}"
                onmousedown="javascript:selectLMFNode('#{node.identifier}');return false;">
					<h:outputText value="#{node.description}" styleClass="nodeFolder"/>
					<h:outputText value=" (#{node.childCount})" styleClass="childCount" rendered="#{!empty node.children}"/>
				</h:commandLink>
            </h:panelGroup>
        </f:facet>
        <f:facet name="Component">
		            <h:panelGroup>
		                <f:facet name="expand">
		                    <t:graphicImage value="images/xmlImport/dot-green-t.gif" rendered="#{t.nodeExpanded}" border="0"/>
		                </f:facet>
		                <f:facet name="collapse">
		                    <t:graphicImage value="images/xmlImport/dot-green-t.gif" rendered="#{!t.nodeExpanded}" border="0"/>
		                </f:facet>
		                <h:commandLink styleClass="#{t.nodeSelected ? 'documentSelected':'document'}"
		                onmousedown="javascript:selectNode('#{node.identifier}');return false;">
							<h:outputText value="#{node.description}" styleClass="nodeFolder"/>
							<h:outputText value=" (#{node.childCount})" styleClass="childCount" rendered="#{!empty node.children}"/>
						</h:commandLink>
		            </h:panelGroup>
        </f:facet>
        <f:facet name="DataCategory">
            <h:panelGroup>
                <h:commandLink styleClass="#{t.nodeSelected ? 'documentSelected':'document'}" 
                onmousedown="javascript:selectDCNode('#{node.identifier}');return false;">
                    <t:graphicImage value="images/xmlImport/dot-blue-t.gif" border="0"/>
                    <h:outputText value="#{node.description}"/>
                </h:commandLink>
            </h:panelGroup>
        </f:facet>
        <f:facet name="Attribute">
				<h:panelGroup>
					<h:commandLink styleClass="#{t.nodeSelected ? 'documentSelected':'document'}" 
					onmousedown="javascript:selectDCNode('#{node.identifier}');return false;">
						<t:graphicImage value="images/xmlImport/dot-red-t.gif" border="0"/>
						<h:outputText value="#{node.description}"/>
					</h:commandLink>
				</h:panelGroup>
        </f:facet>
    </t:tree2>
    <p>
    <h:commandButton value="Build Model" action="#{treeBacker.buildModel}" />
    <h:commandButton value="Cancel" action="#{treeBacker.reset}" />
    </p>
</h:form>

<div ID="contextMenu"
		     ONMOUSEOUT="menu = this; this.tid = setTimeout
		('menu.style.visibility = \'hidden\'', 20);"
		     ONMOUSEOVER="clearTimeout(this.tid);"
		>

		<div id='cutMenuItem' onclick="javascript:selectCutNode()" CLASS="contextMenu"
		   ONMOUSEOVER="this.className = 'menuOn'"
		   ONMOUSEOUT="this.className = 'menu';"
		   
		>
		Cut
		</div>
	
	<div id='pasteMenuItem' onclick="javascript:pasteNode()" CLASS="contextMenu"
			   ONMOUSEOVER="this.className = 'menuOn'"
			   ONMOUSEOUT="this.className = 'menu';"
			   
			>
			Paste
	</div>
	<div id='deleteMenuItem' onclick="javascript:deleteNode()" CLASS="contextMenu"
			   ONMOUSEOVER="this.className = 'menuOn'"
			   ONMOUSEOUT="this.className = 'menu';"

			>
			Delete
	</div>
</div>
</f:view>
<%--
<%@include file="inc/page_footer.jsp" %>
 --%>
</body>

</html>
