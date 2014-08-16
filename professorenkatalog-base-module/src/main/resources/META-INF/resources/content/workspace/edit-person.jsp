<%@page import="org.mycore.activiti.MCRActivitiMgr"%>
<%@page import="org.activiti.engine.task.Task"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<%-- Subpage of workflow.jsp -> Do not use stripes layout here !!! --%>
<mcr:session method="get" var="username" type="userID" />
<c:set  var="baseURL" value="${applicationScope.WebApplicationBaseURL}"/>
 TASK: ${currentTask.name}
 <c:choose>
 	<c:when test="${currentTask.name eq 'Objekt bearbeiten'}">
   <h4><fmt:message key="WF.professorum.Professorum" /> (<fmt:message key="WF.common.Processnumber" /> ${currentTask.id}): </h4>
     <%request.setAttribute("currentVariables", MCRActivitiMgr.getWorfklowProcessEngine().getRuntimeService().getVariables(((Task)request.getAttribute("currentTask")).getExecutionId())); %>
     MCRObjectID: ${currentVariables.objectID}
     <stripes:submit name="doEditObject-task_${currentTask.id}-${currentVariables.objectID}">Edit Object</stripes:submit>
      <%--><c:import url="/content/workflow/editorButtons.jsp" /> --%>
      <p>
	        <img title="" alt="" src="${baseURL}images/greenArrow.gif">         
            <a href="${baseURL}nav?path=~workflow-professorum&transition=&endTask=taskprocessEditInitialized&processID=${requestScope.task.processID}"><fmt:message key="WF.professorum.taskCompleteDocumentAndSendToLibrary" /></a>
	         
	  </p>  
	    <p>
	        <img title="" alt="" src="${baseURL}images/greenArrow.gif">         
            <a href="${baseURL}nav?path=~workflow-professorum&transition=&endTask=taskprocessEditInitialized&processID=${requestScope.task.processID}">Bearbeitung abbrechen</a>
	         
	  </p>    
   </c:when>
   
  
  
 
  
   <c:otherwise>
    <p> Nothing ToDo for TASK: = ${task.name} </p>
   </c:otherwise>
</c:choose>