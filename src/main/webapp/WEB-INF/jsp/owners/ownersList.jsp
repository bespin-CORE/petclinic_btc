<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<petclinic:layout pageName="owners">
    <div class="page-title-wrap" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
        <div>
            <h2>📋 등록된 보호자 명단</h2>
            <p>검색 조건에 부합하는 보호자와 보유 반려동물 목록입니다.</p>
        </div>
        <a href="<spring:url value="/owners/new" htmlEscape="true"/>" class="btn-primary">
            <span>➕ 신규 보호자 등록</span>
        </a>
    </div>

    <div class="table-card">
        <table id="ownersTable" class="modern-table">
            <thead>
            <tr>
                <th style="width: 20%;">보호자 성명</th>
                <th style="width: 25%;">주소</th>
                <th style="width: 15%;">도시</th>
                <th style="width: 15%;">연락처</th>
                <th style="width: 25%;">반려동물</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${selections}" var="owner">
                <tr>
                    <td>
                        <spring:url value="/owners/{ownerId}" var="ownerUrl">
                            <spring:param name="ownerId" value="${owner.id}"/>
                        </spring:url>
                        <a href="${fn:escapeXml(ownerUrl)}" style="font-weight: 700; color: var(--primary); text-decoration: none;">
                            <c:out value="${owner.firstName} ${owner.lastName}"/>
                        </a>
                    </td>
                    <td><c:out value="${owner.address}"/></td>
                    <td><c:out value="${owner.city}"/></td>
                    <td><c:out value="${owner.telephone}"/></td>
                    <td>
                        <c:forEach var="pet" items="${owner.pets}">
                            <span class="badge-specialty">
                                🐾 <c:out value="${pet.name}"/>
                            </span>
                        </c:forEach>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <div>
        <a href="<spring:url value="/owners/find" htmlEscape="true"/>" class="btn-secondary">
            <span>&larr; 다른 보호자 다시 검색</span>
        </a>
    </div>
</petclinic:layout>
