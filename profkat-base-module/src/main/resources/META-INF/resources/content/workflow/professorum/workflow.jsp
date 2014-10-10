<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<fmt:message var="pageTitle" key="WF.professorum.info" />
<stripes:layout-render name="./../../../WEB-INF/layout/default.jsp" pageTitle="${pageTitle}" layout="2columns">
    <stripes:layout-component name="contents">

<c:set  var="baseURL" value="${applicationScope.WebApplicationBaseURL}"/>

<!--  debug handling -->
<c:choose>
   <c:when test="${!empty param.debug}">
      <c:set var="debug" value="true" />
   </c:when>
   <c:otherwise>
      <c:set var="debug" value="false" />
   </c:otherwise>
</c:choose>

<!--  handle task ending parameters -->
<c:if test="${!empty param.endTask}">
    <mcr:endTask success="success" processID="${param.processID}" taskName="${param.endTask}" transition="${param.transition}"/>
</c:if>

<!--  task management part -->

<mcr:getWorkflowTaskBeanList var="myTaskList" mode="activeTasks" workflowTypes="professorum" varTotalSize="total1" size="30" />
<mcr:getWorkflowTaskBeanList var="myProcessList" mode="initiatedProcesses" workflowTypes="professorum"    varTotalSize="total2" size="30" />

    <mcr:session var="sessionID" method="get" type="ID" />
	<h2><fmt:message key="WF.professorum.info" /></h2>
	<p>
	<table>
	<tr><td>  
	      <img title="" alt="" src="${baseURL}images/greenArrow.gif">
	      <a target="_self" href="${baseURL}nav?path=~workflow-professorum-begin"><fmt:message key="WF.professorum.StartWorkflow" /></a>
	      <br/>&#160;<br>	      
	    </td>  
	<tr>
		<td><img title="" alt="" src="${baseURL}images/greenArrow.gif"><fmt:message key="WF.professorum.SearchToEdit" /> </td>
	</tr>
	<tr>
		<td style="padding-left:16px;padding-top:4px;">
			<%--<c:url var="url" value="${WebApplicationBaseURL}editor/searchmasks/SearchMask_ProfessorumEdit.xml">
				<c:param name="XSL.editor.source.new" value="true" />
				<c:param name="XSL.editor.cancel.url" value="${WebApplicationBaseURL}" />
			    <c:param name="MCRSessionID" value="${sessionID}"/>
				<c:param name="lang" value="${requestScope.lang}" />
			</c:url>
			<c:import url="${url}" /> --%>
			<mcr:includeEditor editorPath="editor/searchmasks/SearchMask_ProfessorumEdit.xml"/>
			<br/>        
		</td>
	</tr> 
	</table>
	</p>
<c:choose>
   <c:when test="${empty myTaskList && empty myProcessList}">   
   		<fmt:message key="WF.common.EmptyWorkflow" />   
      	<hr/>
      
      	<h3><fmt:message key="Webpage.intro.professorum.Subtitle1" /></h3>
	  		<p><fmt:message key="Webpage.intro.professorum.Text1" /></p>   
   </c:when>
   <c:otherwise>
        <h3><fmt:message key="WF.common.MyTasks" /></h3>           
        <div class="tasklist">       
	        <c:forEach var="task" items="${myTaskList}">
	        <div class="task">
	           <c:set var="task" scope="request" value="${task}" />
	           <c:import url="/content/workflow/${task.workflowProcessType}/getTasks.jsp" />
		    </div>       
	        </c:forEach>
	        <c:if test="${empty myTaskList}">
	               <span style="color:#00ff00;"><fmt:message key="WF.common.NoTasks" /></span>
	        </c:if>
        </div>
        
             
        <h3><fmt:message key="WF.professorum.MyInititiatedProcesses" /></h3>
        
        <div class="processlist">
	        <c:forEach var="task" items="${myProcessList}">
	        <div class="process">
	           <c:set var="task" scope="request" value="${task}" />
	           <c:import url="/content/workflow/${task.workflowProcessType}/getTasks.jsp" />
		    </div>       
    	    </c:forEach>
	        <c:if test="${empty myProcessList}">
	        	  <span style="color:#00ff00;"><fmt:message key="WF.common.NoTasks" /></span>
		    </c:if>
        </div>   
   </c:otherwise>
</c:choose>       
</stripes:layout-component>
</stripes:layout-render>
