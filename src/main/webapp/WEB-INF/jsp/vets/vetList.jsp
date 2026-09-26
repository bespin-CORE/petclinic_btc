<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<petclinic:layout pageName="vets">
    <div class="page-title-wrap" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
        <div>
            <h2>🩺 전문 수의사 명단</h2>
            <p>Vetcore에서 진료를 담당하는 전문 의료진과 세부 진료 분과입니다.</p>
        </div>
        <div style="display: flex; gap: 8px;">
            <a href="<spring:url value="/vets.xml" htmlEscape="true" />" class="btn-secondary" style="font-size: 13px; padding: 8px 16px;">
                📄 XML 데이터
            </a>
            <a href="<spring:url value="/vets.json" htmlEscape="true" />" class="btn-secondary" style="font-size: 13px; padding: 8px 16px;">
                ⚙️ JSON API
            </a>
        </div>
    </div>

    <div class="table-card">
        <table id="vetsTable" class="modern-table">
            <thead>
            <tr>
                <th style="width: 40%;">수의사 성명 (Veterinarian)</th>
                <th>전문 진료 분과 (Specialties)</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${vets.vetList}" var="vet">
                <tr>
                    <td style="font-weight: 700; color: var(--text-main);">
                        🩺 Dr. <c:out value="${vet.firstName} ${vet.lastName}"/>
                    </td>
                    <td>
                        <c:forEach var="specialty" items="${vet.specialties}">
                            <span class="badge-specialty">
                                <c:out value="${specialty.name}"/>
                            </span>
                        </c:forEach>
                        <c:if test="${vet.nrOfSpecialties == 0}">
                            <span class="badge-general">일반 진료 (General Medicine)</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</petclinic:layout>
