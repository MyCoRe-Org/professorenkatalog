<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>

<%-- Subpage of workflow.jsp -> Do not use stripes layout here !!! --%>
<mcr:session method="get" var="username" type="userID" />
<c:set  var="baseURL" value="${applicationScope.WebApplicationBaseURL}"/>

<c:set var="debug" value="true" />
<c:set var="dom" value="${requestScope.task.variables}" />

<c:if test="${requestScope.task.taskName ne 'initialization'}">
   <h4><fmt:message key="WF.professorum.Professorum" /> (<fmt:message key="WF.common.Processnumber" /> ${requestScope.task.processID}): </h4>
</c:if>
<c:choose>
   <c:when test="${requestScope.task.taskName eq 'initialization'}">
      <h4><fmt:message key="WF.professorum.ActualStateOfYourDocument" />(<fmt:message key="WF.common.Processnumber" /> ${requestScope.task.processID}):</h4> 
      </p>
      <p><b><fmt:message key="WF.professorum.status.${requestScope.task.workflowStatus}" /></b>
      </p>
   </c:when>
   <c:when test="${requestScope.task.taskName eq 'taskprocessEditInitialized' }" >
      <p><img title="" alt="" src="${baseURL}images/greenArrow.gif"><fmt:message key="WF.professorum.completedocumentandsendtolibrary" />
      </p>
      
      <mcr:checkDecisionNode var="transition" processID="${requestScope.task.processID}" workflowType="professorum" decision="canDocumentBeSubmitted" />
      
      <c:import url="/content/workflow/editorButtons.jsp" />
      <p>
	      <c:if test="${transition eq 'documentCanBeSubmitted'}">
	        <img title="" alt="" src="${baseURL}images/greenArrow.gif">         
            <a href="${baseURL}nav?path=~workflow-professorum&transition=&endTask=taskprocessEditInitialized&processID=${requestScope.task.processID}"><fmt:message key="WF.professorum.taskCompleteDocumentAndSendToLibrary" /></a>
	      </c:if>      
	  </p>    
   </c:when>
   
   <c:when test="${requestScope.task.taskName eq 'taskCompleteDocumentAndSendToLibrary'}">
      <p><img title="" alt="" src="${baseURL}images/greenArrow.gif"><fmt:message key="WF.professorum.completedocumentandsendtolibrary" />
      </p>
      
      <mcr:checkDecisionNode var="transition" processID="${requestScope.task.processID}" workflowType="professorum" decision="canDocumentBeSubmitted" />
      
      <c:import url="/content/workflow/editorButtons.jsp" />
      
	  <p>
	      <c:if test="${transition eq 'documentCanBeSubmitted'}">
		     <img title="" alt="" src="${baseURL}images/greenArrow.gif">         
	         <a href="${baseURL}nav?path=~workflow-professorum&transition=&endTask=taskCompleteDocumentAndSendToLibrary&processID=${requestScope.task.processID}"><fmt:message key="WF.professorum.taskCompleteDocumentAndSendToLibrary" /></a>
	      </c:if>      
	  </p>    
   </c:when>
   <c:when test="${requestScope.task.taskName eq 'taskGetInitiatorsEmailAddress'}">
   	  <h4><fmt:message key="WF.common.getInitiatorsEmailAddress" /></h4>
	      <form action="${baseURL}setworkflowvariable" accept-charset="utf-8">
    	     <input name="dispatcherForward" value="/nav?path=~workflow-professorum" type="hidden" />
        	 <input name="transition" value="" type="hidden" />
	         <input name="endTask" value="taskGetInitiatorsEmailAddress" type="hidden" />
    	     <input name="processID" value="${requestScope.task.processID}" type="hidden" />
    	     <input name="jbpmVariableNames" value="initiatorEmail" type="hidden" />
        	 <input type="text" size="80" name="initiatorEmail">
        	 <br>&nbsp;<br>
         	 <input name=submit" type="submit" value="<fmt:message key="WF.common.Send" />"/>      
	     </form>	
   </c:when>   
   <c:when test="${requestScope.task.taskName eq 'taskCheckCompleteness'}">
      <c:import url="/content/workflow/editorButtons.jsp" />
      <mcr:checkDecisionNode var="transition" processID="${requestScope.task.processID}" workflowType="professorum" decision="canDocumentBeCommitted" />
         <p><fmt:message key="WF.common.AreTheMetadataOK" /></p>
         <p><img title="" alt="" src="${baseURL}images/greenArrow.gif">
         <a href="${baseURL}nav?path=~workflow-professorum&transition=go2canDocumentBeCommitted&endTask=taskCheckCompleteness&processID=${requestScope.task.processID}"><fmt:message key="WF.common.MetadataOk_Continue" /></a>
         </p>
         <p><img title="" alt="" src="${baseURL}images/greenArrow.gif">
         <a href="${baseURL}nav?path=~workflow-professorum&transition=go2sendBackToDocumentCreated&endTask=taskCheckCompleteness&processID=${requestScope.task.processID}"><fmt:message key="WF.common.MetadataNotOk_SendToInitiator" /></a>
         </p>
   </c:when>   
   <c:when test="${requestScope.task.taskName eq 'taskEnterMessageData'}">
     <form action="${baseURL}setworkflowvariable" accept-charset="utf-8">
   	     <input name="dispatcherForward" value="/nav?path=~workflow-professorum" type="hidden" />
         <input name="transition" value="" type="hidden" />
         <input name="endTask" value="taskentermessagedata" type="hidden" />
         <input name="processID" value="${requestScope.task.processID}" type="hidden" />
         <input name="jbpmVariableNames" value="tmpTaskMessage" type="hidden" /> 
	     <textarea name="tmpTaskMessage" cols="50" rows="4">Sie müssen noch...</textarea>  
	     <br>&nbsp;<br>
    	<input name=submit" type="submit" value="<fmt:message key="WF.common.SendTask" />"/>      
      </form>
   </c:when>
   <c:when test="${requestScope.task.taskName eq 'taskCheckIfSignedAffirmationYetAvailable'}">
	  <p><img title="" alt="" src="${baseURL}images/greenArrow.gif">   
      <a href="${baseURL}nav?path=~workflow-professorum&transition=go2canDocumentBeCommitted&endTask=taskCheckIfSignedAffirmationYetAvailable&processID=${requestScope.task.processID}"><fmt:message key="WF.professorum.AffirmationIsAvailableCanBeCommitted" /></a>
      </p>
      <p><img title="" alt="" src="${baseURL}images/greenArrow.gif">      
      <a href="${baseURL}nav?path=~workflow-professorum&transition=go2requireAffirmation&endTask=taskCheckIfSignedAffirmationYetAvailable&processID=${requestScope.task.processID}"><fmt:message key="WF.professorum.RequireAffirmation" /></a>
      </p>
   </c:when>   
   <c:when test="${requestScope.task.taskName eq 'taskAdminCheckCommitmentNotSuccessFull'}">
      <p>
      <a href="${baseURL}nav?path=~workflow-professorum&transition=go2documentCommitted&endTask=taskAdminCheckCommitmentNotSuccessFull&processID=${requestScope.task.processID}"><fmt:message key="Nav.Application.professorum.sendAffirmationOfSubmission" /></a><br>      
      </p>
   </c:when>
   <c:otherwise>
    <p> what else? TASK = ${requestScope.task.taskName} </p>
   </c:otherwise>
</c:choose>