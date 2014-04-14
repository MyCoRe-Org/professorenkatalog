<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml"  prefix="x" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<fmt:message var="pageTitle" key="WF.professorum.info" />
<mcr:session method="get" var="username" type="userID" />


<c:choose>
   <c:when test="${empty param.workflowType}">
      <c:set var="workflowType" value="professorum" />
   </c:when>
   <c:otherwise>
      <c:set var="workflowType" value="${param.workflowType}" />
   </c:otherwise>
</c:choose>


<mcr:initWorkflowProcess userid="${username}" status="status" 
    workflowProcessType="${workflowType}" 	 
	processidVar="pid" 	 
	transition="go2professorInitialized"	 scope="request" />
	
<c:choose>
<c:when test="${fn:contains(status,'errorPermission')}">
	<stripes:layout-render name="WEB-INF/layout/default.jsp" pageTitle="${pageTitle}">
    	<stripes:layout-component name="contents">
			<h3><fmt:message key="Webpage.intro.professorum.Subtitle1" /></h3>
			<p><fmt:message key="WF.professorum.errorUserGuest" /></p>
		</stripes:layout-component>
		</stripes:layout-render>
</c:when>
<c:when test="${fn:contains(status,'errorWFM')}">
	<stripes:layout-render name="WEB-INF/layout/default.jsp" pageTitle="${pageTitle}">
    	<stripes:layout-component name="contents">
			<h3><fmt:message key="Webpage.intro.professorum.Subtitle1" /></h3>
			<p><fmt:message key="WF.xmetadiss.errorWfM" /></p>
			<p><fmt:message key="WF.xmetadiss.errorWfM2" /></p>
		</stripes:layout-component>
	</stripes:layout-render>
</c:when>
<c:otherwise>
    <c:import url="/content/workflow/${workflowType}/workflow.jsp" />  
</c:otherwise>
</c:choose>
