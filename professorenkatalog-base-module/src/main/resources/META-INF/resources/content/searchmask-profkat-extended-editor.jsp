<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<fmt:message var="pageTitle" key="Nav.Search.Profkat.Extended" /> 
<stripes:layout-render name="../WEB-INF/layout/default.jsp" currentPath="left.search.extended"  pageTitle = "${pageTitle}" layout="2columns">
	<stripes:layout-component name="contents">
		<h2><fmt:message key="Webpage.editor.title.extended" /></h2>
		<div>
			<mcr:includeEditor editorPath="editor/searchmasks/SearchMask_ProfkatExtended.xml"/>
		</div>			
		<div>
			<mcr:includeWebContent file="searchmask_extended_intro.html" />
		</div>	 	
    </stripes:layout-component>
</stripes:layout-render>