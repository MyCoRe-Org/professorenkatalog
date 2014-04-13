<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>
<stripes:layout-render name="../WEB-INF/layout/default.jsp">
    <stripes:layout-component name="contents">
		<h2><fmt:message key="Webpage.editor.title.${fn:replace(param.editor,'/','.')}" /></h2>
		<table>
 			<tr>
    			<td valign="top">
					<mcr:includeEditor editorPath="${param.editor}"/>
    			</td>
 			</tr>  
		</table>
    </stripes:layout-component>
</stripes:layout-render>