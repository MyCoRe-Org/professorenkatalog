<%@page import="org.mycore.activiti.MCRActivitiMgr"%>
<%@page import="org.activiti.engine.task.Task"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<%-- Subpage of workflow.jsp -> Do not use stripes layout here !!! --%>
<c:set  var="baseURL" value="${applicationScope.WebApplicationBaseURL}"/>
 <c:choose>
 	<c:when test="${currentTask.name eq 'Objekt bearbeiten'}">
 		<div class="panel-body">
 	   <%request.setAttribute("currentVariables", MCRActivitiMgr.getWorfklowProcessEngine().getRuntimeService().getVariables(((Task)request.getAttribute("currentTask")).getExecutionId())); %>
  		<c:if test="${not empty currentVariables.validationMessage}">
			<div class="alert alert-danger" role="alert">${currentVariables.validationMessage}</div>
		</c:if> 			
      MCRObjectID: ${currentVariables.mcrObjectID}<br /><br />

     <button name="doEditObject-task_${currentTask.id}-${currentVariables.mcrObjectID}" value="" class="btn btn-default" type="submit">
     	<span class="glyphicon glyphicon-tag"></span> Metadaten bearbeiten
     </button>
     <button name="doEditDerivates-task_${currentTask.id}-${currentVariables.mcrObjectID}" value="" class="btn btn-default" type="submit">
    	 <span class="glyphicon glyphicon-file"></span> Inhalte bearbeiten
     </button>	
     	 <%--><c:import url="/content/workflow/editorButtons.jsp" /> --%>
					</div>
	  						<div class="panel-footer">
	  						
							  <button name="doGoto-task_${currentTask.id}-edit_object.do_save" value="" class="btn btn-default" type="submit"><span class="glyphicon glyphicon-floppy-disk"></span> Speichern</button>
							  <button name="doGoto-task_${currentTask.id}-edit_object.do_cancel" value="" class="btn btn-default" type="submit"><span class="glyphicon glyphicon-remove"></span> Bearbeitung abbrechen</button>
  							  <button name="doGoto-task_${currentTask.id}-edit_object.do_drop" value="" class="btn btn-danger btn-sm pull-right" style="margin-top:0.2em" type="submit"><span class="glyphicon glyphicon-trash"></span> Objekt löschen</button>
  							   <%--
							  <stripes:submit class="btn btn-default" name="doFollow-edit_object.do_save"><span class="glyphicon glyphicon-floppy-disk"></span> Speichern</stripes:submit>
							  <stripes:submit class="btn btn-default" name="doFollow-edit_object.do_cancel "><span class="glyphicon glyphicon-remove"></span> Bearbeitung abbrechen</stripes:submit>
  							  <stripes:submit class="btn btn-danger pull-right" name="doFollow-edit_object.do_delete "><span class="glyphicon glyphicon-trash"></span> Objekt löschen</stripes:submit>
  								--%>
  					</div> 
   </c:when>
   
  
  
 
  
   <c:otherwise>
    <p> Nothing ToDo for TASK: = ${task.name} </p>
   </c:otherwise>
</c:choose>