<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<petclinic:layout pageName="owners">
    <div class="page-header-card">
        <h2>👤 보호자 및 반려동물 상세 정보</h2>
        <p>보호자 기본 프로필과 등록된 반려동물의 진료 이력을 확인하고 관리합니다.</p>
    </div>

    <!-- Owner Information Card -->
    <div class="modern-card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid var(--border); padding-bottom: 14px;">
            <h3 style="font-size: 18px; font-weight: 800; color: var(--text-main); margin: 0;">
                보호자 기본 프로필
            </h3>
            <div style="display: flex; gap: 8px;">
                <spring:url value="/owners/{ownerId}/edit" var="editUrl">
                    <spring:param name="ownerId" value="${owner.id}"/>
                </spring:url>
                <a href="${fn:escapeXml(editUrl)}" class="btn btn-default" style="font-size: 13px; padding: 8px 14px;">
                    <span>✏️ 정보 수정</span>
                </a>
                <spring:url value="/owners/{ownerId}/pets/new" var="addPetUrl">
                    <spring:param name="ownerId" value="${owner.id}"/>
                </spring:url>
                <a href="${fn:escapeXml(addPetUrl)}" class="btn btn-primary" style="font-size: 13px; padding: 8px 14px;">
                    <span>🐾 신규 반려동물 추가</span>
                </a>
            </div>
        </div>

        <div class="table-responsive-wrapper" style="margin-bottom: 0;">
            <table class="table">
                <tbody>
                <tr>
                    <th style="width: 25%; background: var(--bg-raised); font-weight: 700; color: var(--text-muted);">성명 (Name)</th>
                    <td style="font-weight: 700; color: var(--text-main);"><c:out value="${owner.firstName} ${owner.lastName}"/></td>
                </tr>
                <tr>
                    <th style="background: var(--bg-raised); font-weight: 700; color: var(--text-muted);">주소 (Address)</th>
                    <td><c:out value="${owner.address}"/></td>
                </tr>
                <tr>
                    <th style="background: var(--bg-raised); font-weight: 700; color: var(--text-muted);">도시 (City)</th>
                    <td><c:out value="${owner.city}"/></td>
                </tr>
                <tr>
                    <th style="background: var(--bg-raised); font-weight: 700; color: var(--text-muted);">연락처 (Telephone)</th>
                    <td><c:out value="${owner.telephone}"/></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pets and Visits Section -->
    <div class="modern-card">
        <h3 style="font-size: 18px; font-weight: 800; color: var(--text-main); margin: 0 0 20px 0; border-bottom: 1px solid var(--border); padding-bottom: 14px;">
            반려동물 및 진료/방문 기록
        </h3>

        <c:forEach var="pet" items="${owner.pets}">
            <div style="background: var(--bg-raised); border: 1px solid var(--border); border-radius: 12px; padding: 20px; margin-bottom: 20px;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; margin-bottom: 14px;">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <span style="font-size: 20px;">🐶</span>
                        <div>
                            <span style="font-size: 17px; font-weight: 800; color: var(--text-main);"><c:out value="${pet.name}"/></span>
                            <span class="badge-specialty" style="margin-left: 8px;"><c:out value="${pet.type.name}"/></span>
                            <span style="font-size: 12px; color: var(--text-muted); margin-left: 8px;">생년월일: <petclinic:localDate date="${pet.birthDate}" pattern="yyyy-MM-dd"/></span>
                        </div>
                    </div>
                    <div style="display: flex; gap: 8px;">
                        <spring:url value="/owners/{ownerId}/pets/{petId}/edit" var="petUrl">
                            <spring:param name="ownerId" value="${owner.id}"/>
                            <spring:param name="petId" value="${pet.id}"/>
                        </spring:url>
                        <a href="${fn:escapeXml(petUrl)}" class="btn btn-default" style="font-size: 12px; padding: 6px 12px;">
                            <span>✏️ 정보 수정</span>
                        </a>
                        <spring:url value="/owners/{ownerId}/pets/{petId}/visits/new" var="visitUrl">
                            <spring:param name="ownerId" value="${owner.id}"/>
                            <spring:param name="petId" value="${pet.id}"/>
                        </spring:url>
                        <a href="${fn:escapeXml(visitUrl)}" class="btn btn-primary" style="font-size: 12px; padding: 6px 12px;">
                            <span>🩺 진료 기록 추가</span>
                        </a>
                    </div>
                </div>

                <!-- Visits table for this pet -->
                <div class="table-responsive-wrapper" style="margin-bottom: 0;">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th style="width: 25%;">방문/진료 일자</th>
                            <th>진료 내용 및 소견</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="visit" items="${pet.visits}">
                            <tr>
                                <td style="font-weight: 600; color: var(--text-main);">
                                    <petclinic:localDate date="${visit.date}" pattern="yyyy-MM-dd"/>
                                </td>
                                <td><c:out value="${visit.description}"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty pet.visits}">
                            <tr>
                                <td colspan="2" style="text-align: center; color: var(--text-muted); padding: 18px;">
                                    등록된 진료 및 방문 이력이 없습니다.
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty owner.pets}">
            <div style="text-align: center; padding: 32px; color: var(--text-muted);">
                등록된 반려동물이 없습니다. 상단의 '신규 반려동물 추가' 버튼을 눌러 등록해주세요.
            </div>
        </c:if>
    </div>

    <div>
        <a href="<spring:url value="/owners/find" htmlEscape="true"/>" class="btn btn-default">
            <span>&larr; 보호자 목록으로 돌아가기</span>
        </a>
    </div>
</petclinic:layout>
