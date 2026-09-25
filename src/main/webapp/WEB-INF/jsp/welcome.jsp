<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<petclinic:layout pageName="home">

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-left">
            <h1 class="hero-title">
                소중한 반려동물의 건강,<br>
                <span>PetClinic</span>이 함께합니다
            </h1>
            <p class="hero-description">
                반려동물 기본 등록부터 전문 수의사 진료, 과거 병력 및 방문 예약까지 체계적으로 관리하세요.
                Tomcat 9 기반 고가용성 WAS 클러스터와 MySQL RDS 연동을 통해 빠르고 안정적인 서비스를 제공합니다.
            </p>
            <div class="hero-buttons">
                <a class="btn-primary" href="<spring:url value="/owners/find" htmlEscape="true" />">
                    <span>📋 보호자 조회 시작</span>
                    <span>&rarr;</span>
                </a>
                <a class="btn-secondary" href="<spring:url value="/test.jsp" htmlEscape="true" />">
                    <span>📊 3-Tier 인프라 진단</span>
                    <span>&rarr;</span>
                </a>
            </div>
        </div>

        <div class="hero-visual">
            <div class="visual-card">
                <div class="card-header-art">
                    <span>🐶 🐱 🩺</span>
                    <span class="hospital-tag">24H 안심 케어</span>
                </div>
                <h3>스마트 동물병원 헬스케어 포털</h3>
                <p style="margin-bottom: 0;">보호자와 반려동물의 행복한 동행을 위해 맞춤형 진료 스케줄과 전문 케어를 제공합니다.</p>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section">
        <div class="section-title-wrap">
            <span class="section-badge">Core Features</span>
            <h2 class="section-title">스마트 펫클리닉의 주요 서비스</h2>
        </div>

        <div class="features-grid">
            <!-- 1. 보호자 조회 -->
            <div class="feature-card">
                <div>
                    <div class="feature-icon icon-blue">📋</div>
                    <h4>보호자 &amp; 반려동물 조회</h4>
                    <p>등록된 보호자와 반려동물 목록을 성(Last Name)으로 검색하고, 진료 이력 및 상세 정보를 실시간으로 확인합니다.</p>
                </div>
                <a href="<spring:url value="/owners/find" htmlEscape="true" />" class="feature-link">
                    <span>보호자 조회 바로가기</span>
                    <span>&rarr;</span>
                </a>
            </div>

            <!-- 2. 수의사 명단 -->
            <div class="feature-card">
                <div>
                    <div class="feature-icon icon-green">🩺</div>
                    <h4>전문 수의사 명단</h4>
                    <p>방사선과, 외과, 치과 등 진료 분과별 전문 의료진과 수의사 명단을 투명하게 실시간 열람합니다.</p>
                </div>
                <a href="<spring:url value="/vets" htmlEscape="true" />" class="feature-link">
                    <span>수의사 목록 보기</span>
                    <span>&rarr;</span>
                </a>
            </div>

            <!-- 3. 신규 등록 -->
            <div class="feature-card">
                <div>
                    <div class="feature-icon icon-amber">🐕</div>
                    <h4>신규 보호자/환자 등록</h4>
                    <p>새로운 보호자와 소중한 반려동물의 기본 프로필, 거주지 주소 및 연락처를 시스템에 신규 등록합니다.</p>
                </div>
                <a href="<spring:url value="/owners/new" htmlEscape="true" />" class="feature-link">
                    <span>새 보호자 등록</span>
                    <span>&rarr;</span>
                </a>
            </div>

            <!-- 4. 장애 복구 테스트 -->
            <div class="feature-card">
                <div>
                    <div class="feature-icon icon-rose">⚡</div>
                    <h4>장애 복구 검증 (Oups)</h4>
                    <p>고의 예외(RuntimeException)를 발생시켜 스프링 에러 핸들러 및 트랜잭션 롤백의 정상 동작을 검증합니다.</p>
                </div>
                <a href="<spring:url value="/oups" htmlEscape="true" />" class="feature-link">
                    <span>장애 처리 검증</span>
                    <span>&rarr;</span>
                </a>
            </div>
        </div>
    </section>

</petclinic:layout>
