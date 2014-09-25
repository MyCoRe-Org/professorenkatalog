<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/docdetails.tld" prefix="mcrdd" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%-- Parameter: id - the MCR Object ID--%>
<%-- Parameter: url - the MCR Object ID--%>

<mcr:receiveMcrObjAsJdom mcrid="${param.id}" varDom="xml"/>
<c:set var="type" value="${fn:substringBefore(fn:substringAfter(param.id, '_'),'_')}" />
<table class="searchresult-table">
	<tr>
		<td class="searchresult-table-icon" rowspan="10">
			<img src="${applicationScope.WebApplicationBaseURL}images/greenArrow.gif"
			title="Person" />
		</td>
		<td class="searchresult-table-header">
			<c:set var="title"><x:out select="$xml/mycoreobject/metadata/box.surname/surname[1]" />,&#160;
			<x:out select="$xml/mycoreobject/metadata/box.firstname/firstname[1]" />
			<x:if select="string-length($xml/metadata/box.nameaffix/nameaffix)>0">
				&#160;(<x:out select="$xml/mycoreobject/metadata/box.nameaffix/nameaffix" />)
			</x:if></c:set>
			<a href="${param.url}"><b>${title}</b></a>
		</td>
		<td class="searchresult-table-id" rowspan="10">
			[<x:out select="$xml/mycoreobject/@ID" />]
			<br /><br />
			 <mcr:checkAccess var="modifyAllowed" permission="writedb" key="${param.id}" />
			 <c:if test="${modifyAllowed}">
			 	<mcr:isObjectNotLocked var="bhasAccess" mcrObjectID="${param.id}" />
			 	<c:choose>
			 		<c:when test="${bhasAccess}">
			 			<!--  Editbutton -->
			 			<form method="get" action="${applicationScope.WebApplicationBaseURL}StartEdit" class="resort">                 
							<input name="page" value="nav?path=~workflowEditor-${doctype}"  type="hidden">                                       
							<input name="mcrid" value="${param.id}" type="hidden"/>
							<input title="<fmt:message key="WF.common.object.EditObject" />" border="0" 
							       src="${applicationScope.WebApplicationBaseURL}images/workflow1.gif" type="image"  class="imagebutton" height="30" />
						</form> 
					</c:when>
					<c:otherwise>
						<img title="<fmt:message key="WF.common.object.EditObjectIsLocked" />" border="0" 
						     src="${applicationScope.WebApplicationBaseURL}images/workflow_locked.gif" height="30" />
					</c:otherwise>
				</c:choose>         
			</c:if>   
		</td>
	</tr>
 
	<x:set var="data1" select="substring-before(concat($xml/metadata/box.period/period[1]/text,', ',$xml/metadata/box.period/period[2]/text,', ',$xml/metadata/box.period/period[3]/text,', ',$xml/metadata/box.period/period[4]/text,', ',$xml/metadata/box.period/period[5]/text,', ',$xml/metadata/box.period/period[6]/text,', ',$xml/metadata/box.period/period[7]/text,',',$xml/metadata/box.period/period[8]/text,', ,'),', ,')" /> 
	<x:if select="string-length($data1)>0">
		<tr>
			<td class="searchresult-table-value">
				<fmt:message key="OMD.CPR.professorships" />:&#160; <x:out select="$data1" />
			</td>
		</tr>
	</x:if>
	<x:set var="data2" select="$xml/mycoreobject/metadata/box.professorship/professorship[last()]/event" /> 
	<x:if select="string-length($data2)>0">
		<tr>
			<td class="searchresult-table-value">
				<fmt:message key="OMD.common.last" />:&#160; <x:out select="$data2" />
			</td>
		</tr>
	</x:if>
	<x:set var="data3" select="$xml/mycoreobject/metadata/box.faculty/faculty[last()]/classification" /> 
	<x:if select="string-length($data3/@categid)>0">
		<tr>
			<td class="searchresult-table-value">
			    <c:set var="classid"><x:out select="$data3/@classid" /></c:set>
			    <c:set var="categid"><x:out select="$data3/@categid" /></c:set>
			    
				<fmt:message key="OMD.common.last" />:&#160; 
				<mcr:displayClassificationCategory lang="de" classid="${classid}" categid="${categid}"/>
			</td>
		</tr>
	</x:if>
	<x:set var="data4" select="$xml/mycoreobject/metadata/box.state/state" />
	<x:if select="string-length($data4)>0">
		<tr>
			<td class="searchresult-table-value">
			    <c:set var="x"><x:out select="$data4" /></c:set>
				<fmt:message key="OMD.CPR.states" />:&#160; <fmt:message key="OMD.CPR.states.${x}" />
			</td>
		</tr>
	</x:if>
 </table>
