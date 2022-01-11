<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/docdetails.tld" prefix="mcrdd" %>
<%@ taglib prefix="search" tagdir="/WEB-INF/tags/search"%>
<%-- Parameter: id - the MCR Object ID--%>
<%-- Parameter: fromWF - from Workflow or database --%>


	<%--Tab bar (begin) --%>
	<c:set var="tab" value="${param.tab}" />
	<c:if test="${empty tab}"><c:set var="tab" value="data" /></c:if>
	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	<mcr:retrieveObject mcrid="${param.id}" varDOM="mcrobj" cache="true" fromWorkflow="${param.fromWF}" />
    
    <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/header.xsl" />
	
    <c:if test="${not(param.print eq 'true')}">
		<c:if test="${param.fromWF eq 'true'}">
				<div class="alert alert-info" style="margin-top:20px" role="alert">
					<h4 style="margin:5px 0px">
						<a class="btn btn-secondary btn-sm float-right" href="${WebApplicationBaseURL}showWorkspace.action?mode=profkat"><fmt:message key="WF.Preview.return" /></a>
						<fmt:message key="WF.Preview" />
					</h4>
				</div>
		</c:if>
		<div  class="tabbar docdetails-tabbar" style="position:relative">
			<c:set var="msgKeyStatus">OMD.profkat.state.<x:out select="$mcrobj/mycoreobject/metadata/box.status/status"/></c:set>
			
			<c:set var="tabtokens" value="data|article|documents" />
			<ul id="tabs_on_page" class="nav nav-tabs" style="position:relative">
			 
				
				<c:forTokens items="${tabtokens}" delims="|" var="current" varStatus="status">
      				<c:set var="tabstyle" value="" /> 
					<c:if test="${current eq tab}">
						<c:set var="tabstyle" value="active" />
					</c:if>
					<c:if test="${current eq 'data'}">
						<li class="nav-item">
							<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${param.id}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${param.fromWF eq 'true' ? '&fromWF=true' : ''}">
								<i class="fas fa-user docdetails-tabbar-icon"></i>
								<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
						</li>
					</c:if>
					<c:if test="${current eq 'article'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject[@xlink:title='display_biography']">
							<li class="nav-item">
								<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${param.id}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${param.fromWF eq 'true' ? '&fromWF=true' : ''}">
									<i class="fas fa-book docdetails-tabbar-icon"></i>
									<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
							</li>
						</x:if>		
					</c:if>
					<c:if test="${current eq 'documents'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
							<li class="nav-item">
								<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${param.id}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${param.fromWF eq 'true' ? '&fromWF=true' : ''}">
									<i class="far fa-file docdetails-tabbar-icon"></i>
									<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
							</li>
						</x:if>
					</c:if>
				</c:forTokens>
			</ul>
			<div class="docdetails-tabbar-info" style="position:absolute; top:5px; right:15px">
					<fmt:message key="${msgKeyStatus}" />
			</div>
		</div>
	</c:if>
	<%--Tab bar (end) --%>
  
  
   <c:if test="${(tab eq 'data') or (param.print eq 'true')}">
     <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/metadata.xsl" />
   </c:if>

<mcrdd:docdetails mcrID="${param.id}" lang="de" fromWorkflow="${param.fromWF}" var="doc" outputStyle="headlines"> 
	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	 
   	 <c:if test="${(tab eq 'data') or (param.print eq 'true')}">

        <x:if select="not(starts-with($mcrobj/mycoreobject/@ID,'cpb_'))">   
   		<mcrdd:row select="/mycoreobject/metadata/box.epoch/epoch" 
   		           labelkey="OMD.profkat.classification" showInfo="true"  colWidths="8em">
   		    <mcrdd:outputitem select="." var="current">
   		       <x:if select="local-name($current)='epoch'">
   		       	<fmt:message key="OMD.profkat.epoch" />:
   		       </x:if>
   			</mcrdd:outputitem> 
   		              
   			<mcrdd:outputitem select="." var="current">
   				<x:if select="local-name($current)='epoch'">
   			    	<c:set var="classid"><x:out select="$current/@classid" /></c:set>
    				<c:set var="categid"><x:out select="$current/@categid" /></c:set>
   					<mcr:displayCategory categid="${categid}" classid="${classid}" lang="de"/>
   				</x:if>
   		   </mcrdd:outputitem>
   		</mcrdd:row>
        </x:if> 	
	</c:if> 	
  	
	<c:if test="${(tab eq 'article') or (param.print eq 'true')}">
  		<mcrdd:row select="/mycoreobject/structure/derobjects/derobject[@xlink:title='display_biography']" labelkey="OMD.profkat.documents" showInfo="true" >
  			<mcrdd:derivatecontent select="." width="100%" encoding="UTF-8" />
  		</mcrdd:row>	
	</c:if>

	<c:if test="${(tab eq 'documents') or (param.print eq 'true')}">
		<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
			<div class="docdetails-block">
				<div class="card card-sm panel-copyright">
					<div class="card-body">
  						<fmt:message key="OMD.derivate.copyright.notice" />
	               </div>
				</div>
			</div>
		</x:if>
		<mcrdd:row select="/mycoreobject/structure/derobjects[./derobject]" labelkey="OMD.profkat.derobjects" showInfo="true" >
			<x:forEach var="x" select="$doc/mycoreobject/structure/derobjects/derobject/@xlink:href">
	 			 <c:set var="id"><x:out select="$x" /></c:set>
 				 <search:derivate-list derid="${id}" showSize="true" />
 		  </x:forEach>
	  	</mcrdd:row>
	</c:if>	
  	
  	<mcrdd:separator showLine="true" />
    
    <mcrdd:row select="/mycoreobject" labelkey="OMD.profkat.created_changed" showInfo="true" >
   		<%-- 06.10.2006, editorCP  /  17.06.2009, editorCP --%>
   		<mcrdd:item select="./service/servdates/servdate[@type='createdate']" datePattern ="dd.MM.yyyy" var="createdate"/>
   		<mcrdd:item select="./service/servdates/servdate[@type='modifydate']" datePattern ="dd.MM.yyyy" var="modifydate" />
   		<x:if select="not(starts-with($mcrobj/mycoreobject/@ID,'cpb_'))">
   			<mcrdd:item select="./service/servflags/servflag[@type='createdby']" var="createdBy"/>
   			<mcrdd:item select="./service/servflags/servflag[@type='modifiedby']" var="modifiedBy" />
   		</x:if>
   		<mcrdd:outputitem select="." var="current">
   			${createdate}${empty createdBy ? '' : ',&#160;'.concat(createdBy)}&#160;&#160;/&#160;&#160;${modifydate}${empty modifiedBy ? '' : ',&#160;'.concat(modifiedBy)}
   		</mcrdd:outputitem>  
   	</mcrdd:row>
   	
   	<x:if select="not(starts-with($mcrobj/mycoreobject/@ID,'cpb_'))">
   	<mcrdd:row select="/mycoreobject" labelkey="OMD.profkat.quoting" showInfo="true" >
   		<mcrdd:item select="/mycoreobject/metadata/box.surname/surname" var="last"/>
   		<mcrdd:item select="/mycoreobject/metadata/box.firstname/firstname" var="first" />
   		<jsp:useBean id="now" class="java.util.Date" scope="page" />
   		<mcrdd:outputitem select="./@ID" var="current">
   			<%-- OMD.profkat.quoting.text=Eintrag von &quot;{0}&quot; im Rostocker Professorenkatalog, URL: <a href="{1}">{1}</a> (abgerufen am {2})  --%> 
   			<c:set var="currentID"><x:out select="string($current)"/></c:set>
   			<c:url var="url" value="${WebApplicationBaseURL}resolve/id/${currentID}" />
   			<c:if test="${fn:startsWith(currentID, 'cpr_')}">
   				<c:url var="url" value="http://purl.uni-rostock.de/cpr/${fn:substringAfter(currentID,'cpr_person_')}" />
   			</c:if>
   			<fmt:message key="OMD.profkat.quoting.text">
      			<fmt:param>${first}&#160;${last}</fmt:param>
      			<fmt:param>${url}</fmt:param>
      			<fmt:param>${url}</fmt:param>
      			<fmt:param><fmt:formatDate value="${now}" pattern="dd.MM.yyyy" /></fmt:param>
      		</fmt:message>      			
   		</mcrdd:outputitem>
   	</mcrdd:row>
   	</x:if>
   	
   	<c:if test="${param.fromWF eq 'true'}">
		<div class="alert alert-info" style="margin-top:20px" role="alert">
			<h4 style="margin:5px 0px">
				<a class="btn btn-secondary btn-sm float-right" href="${WebApplicationBaseURL}showWorkspace.action?mode=profkat"><fmt:message key="WF.Preview.return" /></a>
				<fmt:message key="WF.Preview" />
			</h4>
		</div>
	</c:if>	
  </mcrdd:docdetails>