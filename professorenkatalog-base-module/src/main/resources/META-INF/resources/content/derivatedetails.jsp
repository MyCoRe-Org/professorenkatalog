<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<fmt:message var="pageTitle" key="Nav.DigitalisatDetails" /> 
<stripes:layout-render name="../WEB-INF/layout/default.jsp" pageTitle = "${pageTitle}">
	<stripes:layout-component name="contents">
<c:catch var="e">

<c:set var="WebApplicationBaseURL" value="${applicationScope.WebApplicationBaseURL}" />

<c:set var="mcrdir" value="${requestScope.jDomMcrDir}" />


<x:forEach select="$mcrdir//mcr_directory" >
 <x:set var="mainfile" select="string(./details/@mainDoc)" />
 <x:set var="derivid" select="string(./ownerID)" /> 
 <x:set var="host" select="local" /> 
 <x:set var="mcrid" select="string(./details/@mcrid)" />
   
 <h2><fmt:message key="IFS.header" /></h2>

  <table id="metaHeading" cellpadding="0" cellspacing="0">
       <tr>
          <td class="titles">
           <c:out value="${derivid}" /> 
          </td>
       </tr>
    </table>
    <!-- IE Fix for padding and border -->
    <hr/>
    <table  id="metaData" cellpadding="0" cellspacing="0" >
       <tr>
	      <th colspan="2" class="metahead"><fmt:message key="IFS.common" /></th>
	   </tr>
	   <tr>   
          <td class="metaname"><fmt:message key="IFS.location" /></td>
	      <td class="matavalue"> local</td>
       </tr>
	   <tr>   
          <td class="metaname"><fmt:message key="IFS.filesize" /></td>
	      <td class="matavalue"> <x:out select="string(./size)"/> Bytes </td>
       </tr>
	   <tr>   
          <td class="metaname"><fmt:message key="IFS.total" /></td>
	      <td class="matavalue"> <x:out select="string(./numChildren/total/files)"/> 
	      	/<x:out select="string(./numChildren/total/directories)"/> 	      	
	      </td>
       </tr>
	   <tr>   
          <td class="metaname"><fmt:message key="IFS.startfile" /></td>
	      <td class="matavalue"> <c:out value="${mainfile}" /></td>
       </tr>
	   <tr>   
          <td class="metaname"><fmt:message key="IFS.lastchanged" /></td>
	      <td class="matavalue"> <x:out select="string(./children/child/date)"/></td>
       </tr>
	   <tr>   
          <td class="metaname"><fmt:message key="IFS.title" /></td>
	      <td class="matavalue"> 
	         <a href="${WebApplicationBaseURL}receive/${mcrid}">
		         <x:out select="string(./details/@objTitle)"/>
	         </a>
	      </td>
       </tr>       
       
    </table>

    <table id="files" cellpadding="0" cellspacing="0">
      <tr>
        <th class="metahead"></th>
        <th class="metahead"><fmt:message key="IFS.filename"/></th>
        <th class="metahead"><fmt:message key="IFS.filesize"/></th>
        <th class="metahead"><fmt:message key="IFS.filetype"/></th>
        <th class="metahead"><fmt:message key="IFS.lastchanged"/></th>
      </tr>    
    <x:forEach select="./children/child">
      <x:set var="filename" select="string(./name)" />
      <x:set var="type" select="./@type" />
      <tr valign="top" >      			              
              <td class="metavalue" >                  
              <c:if test="${filename eq mainfile}">
              		<img src="${WebApplicationBaseURL}images/greenArrow.gif" alt="Main file" border="0" />
              </c:if>
              </td>
              <td class="metavalue" >  
	               <x:set var="filename" select="string(./name)" />
				   <x:set var="URL" select="concat($WebApplicationBaseURL,'file/',$derivid,'/',$filename,'?hosts=',$host)" />
				   <a href="${URL}" target="_new"><c:out value="${filename}"/></a>
              </td>
              <td class="metavalue" >  <x:out select="string(./size)" /> Bytes</td>
              <td class="metavalue" >  <x:out select="string(./contentType)" /></td>
              <td class="metavalue" >  <x:out select="string(./date)" /></td>              
      </tr>       
      </x:forEach>
    </table>  
	<hr/>
</x:forEach>    
</c:catch>
<c:if test="${e!=null}">
An error occured, hava a look in the logFiles!
<% 
  Logger.getLogger("deviatedetails.jsp").error("error", (Throwable) pageContext.getAttribute("e"));   
%>
</c:if>
	</stripes:layout-component>
</stripes:layout-render>    
       