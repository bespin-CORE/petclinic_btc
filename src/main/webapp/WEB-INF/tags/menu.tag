<%@ tag pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="name" required="true" rtexprvalue="true"
              description="Name of the active menu: home, owners, vets or error" %>

<header>
    <div class="nav-container">
        <a href="<spring:url value="/" htmlEscape="true" />" class="logo-group">
            <div class="logo-icon">🐾</div>
            <div class="logo-text">
                <span class="logo-title">PetClinic</span>
                <span class="logo-subtitle">Smart Animal Hospital · WAS Tier</span>
            </div>
        </a>

        <!-- Mobile Hamburger Toggle Button -->
        <button type="button" class="mobile-menu-toggle" id="mobile-toggle" aria-label="메뉴 토글" onclick="toggleMobileNav()">
            <span class="toggle-bar"></span>
            <span class="toggle-bar"></span>
            <span class="toggle-bar"></span>
        </button>

        <!-- Navigation Links and Status Badge -->
        <div class="header-nav-wrap" id="header-nav">
            <nav class="nav-menu">
                <a href="<spring:url value="/" htmlEscape="true" />" class="nav-item ${name eq 'home' ? 'active' : ''}">
                    <span>🏠 홈</span>
                </a>
                <a href="<spring:url value="/owners/find" htmlEscape="true" />" class="nav-item ${name eq 'owners' ? 'active' : ''}">
                    <span>📋 보호자 &amp; 환자</span>
                </a>
                <a href="<spring:url value="/vets" htmlEscape="true" />" class="nav-item ${name eq 'vets' ? 'active' : ''}">
                    <span>🩺 수의사 명단</span>
                </a>
                <a href="<spring:url value="/oups" htmlEscape="true" />" class="nav-item ${name eq 'error' ? 'active' : ''}">
                    <span>⚡ 장애 검증</span>
                </a>
                <a href="<spring:url value="/test.jsp" htmlEscape="true" />" class="nav-item">
                    <span>📊 3-Tier 진단</span>
                </a>
                <a href="<spring:url value="/index.html" htmlEscape="true" />" class="nav-item nav-item-web">
                    <span>🌐 WEB 메인</span>
                </a>
            </nav>
            <div class="status-badge">
                <span class="status-dot"></span>
                <span>WAS Tier 정상 서빙 중</span>
            </div>
        </div>
    </div>
</header>

<script>
function toggleMobileNav() {
    var nav = document.getElementById('header-nav');
    var btn = document.getElementById('mobile-toggle');
    if (nav) nav.classList.toggle('open');
    if (btn) btn.classList.toggle('open');
}
</script>
