<%@ tag pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="name" required="true" rtexprvalue="true"
              description="Name of the active menu: home, owners, vets or error" %>

<%-- WEB 티어 랜딩(web/index.html)의 헤더와 동일한 마크업/클래스를 사용한다.
     스타일은 css/style.css의 "Shared Header" 섹션(landing.css와 동일 규칙)에 있다. --%>
<header class="mv-header" id="mvHeader">
    <div class="mv-header-inner">
        <a href="/" class="mv-logo">
            <span class="mv-logo-mark">🐾</span>
            <span class="mv-logo-text">
                <strong>Vetcore</strong>
                <span>Smart Animal Hospital</span>
            </span>
        </a>

        <button type="button" class="mv-nav-toggle" id="mvNavToggle" aria-label="메뉴 토글">
            <span></span><span></span><span></span>
        </button>

        <nav class="mv-gnb" id="mvGnb">
            <a href="/">홈</a>
            <a href="<spring:url value="/owners/find" htmlEscape="true" />" class="${name eq 'owners' ? 'on' : ''}">보호자 &amp; 환자</a>
            <a href="<spring:url value="/vets" htmlEscape="true" />" class="${name eq 'vets' ? 'on' : ''}">수의사 명단</a>
            <a href="<spring:url value="/oups" htmlEscape="true" />" class="${name eq 'error' ? 'on' : ''}">장애 검증</a>
            <a href="<spring:url value="/test.jsp" htmlEscape="true" />">3-Tier 진단</a>
        </nav>
    </div>
</header>

<script>
(function () {
    var gnb = document.getElementById('mvGnb');
    var toggle = document.getElementById('mvNavToggle');
    if (toggle && gnb) {
        toggle.addEventListener('click', function () {
            gnb.classList.toggle('open');
        });
    }
})();
</script>
