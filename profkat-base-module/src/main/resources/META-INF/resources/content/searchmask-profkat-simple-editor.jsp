<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<fmt:message var="pageTitle" key="Nav.Search.Profkat.Simple" /> 
<stripes:layout-render name="../WEB-INF/layout/default.jsp" currentPath="left.search.simple"  pageTitle = "${pageTitle}" layout="2columns">
    <stripes:layout-component name="contents">
		<h2><fmt:message key="Webpage.editor.title.simple" /></h2>
		<table >
			<tr>
    			<td valign="top">
					<mcr:includeEditor editorPath="editor/searchmasks/SearchMask_ProfkatSimple.xml"/>
    			</td>
    			<td valign="top">
	 				<mcr:includeWebContent file="searchmask_simple_intro.html" />
				</td>
 			</tr>  
		</table>
	</stripes:layout-component>
</stripes:layout-render>