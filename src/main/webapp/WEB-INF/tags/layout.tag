<%@ tag pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<%@ attribute name="pageName" required="true" %>
<%@ attribute name="customScript" required="false" fragment="true"%>

<!doctype html>
<html lang="ko">
<petclinic:htmlHeader/>

<body>
<petclinic:bodyHeader menuName="${pageName}"/>

<main class="main-wrapper">
    <div class="xd-container">
        <jsp:doBody/>
    </div>
</main>

<petclinic:pivotal/>
<petclinic:footer/>
<jsp:invoke fragment="customScript" />

</body>
</html>
