<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<petclinic:layout pageName="owners">
    <div class="page-title-wrap">
        <h2>📋 보호자 &amp; 환자 조회</h2>
        <p>등록된 보호자의 성(Last Name)을 입력하여 환자 정보 및 진료 이력을 검색하세요. (빈칸으로 검색 시 전체 목록 조회)</p>
    </div>

    <div class="content-card" style="max-width: 680px;">
        <spring:url value="/owners" var="formUrl"/>
        <form:form modelAttribute="owner" action="${fn:escapeXml(formUrl)}" method="get" id="search-owner-form">
            <div class="form-row">
                <label class="form-label" for="lastName">보호자 성 (Last Name)</label>
                <form:input class="modern-input" path="lastName" size="30" maxlength="80" placeholder="예: Franklin, Davis 등 (전체 조회는 빈칸 입력)"/>
                <span style="color: var(--danger); font-size: 13px; margin-top: 4px; display: inline-block;"><form:errors path="*"/></span>
            </div>
            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                <button type="submit" class="btn-primary">
                    <span>🔍 보호자 검색</span>
                </button>
                <a class="btn-secondary" href='<spring:url value="/owners/new" htmlEscape="true"/>'>
                    <span>➕ 신규 보호자 등록</span>
                </a>
            </div>
        </form:form>
    </div>
</petclinic:layout>
