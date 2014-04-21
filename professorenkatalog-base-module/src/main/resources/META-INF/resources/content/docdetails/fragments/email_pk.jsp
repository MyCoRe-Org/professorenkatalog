<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr"%>
<!-- $data as xml element representing mcrlink object --->

<c:set var="email"><x:out select="$data/text()" /></c:set>
<div style="direction: rtl; unicode-bidi: bidi-override;">
<% String email = pageContext.getAttribute("email").toString();
   			email = email.replace("@", ")at(");
   			for(int i=email.length()-1;i>=0;i--){
   				out.write(email.substring(i,i+1));
   			}%>
</div>