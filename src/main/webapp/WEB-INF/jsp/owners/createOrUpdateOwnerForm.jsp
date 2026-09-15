<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<petclinic:layout pageName="owners">
    <div class="page-header-card">
        <h2>
            <c:if test="${owner['new']}">➕ 신규 보호자 등록</c:if>
            <c:if test="${!owner['new']}">✏️ 보호자 정보 수정</c:if>
        </h2>
        <p>보호자의 성명, 거주지 주소 및 비상 연락처를 입력해주세요.</p>
    </div>

    <div class="modern-card" style="max-width: 680px;">
        <form:form modelAttribute="owner" class="form-horizontal" id="add-owner-form">
            <div class="form-group has-feedback">
                <petclinic:inputField label="이름 (First Name)" name="firstName"/>
                <petclinic:inputField label="성 (Last Name)" name="lastName"/>
                <petclinic:inputField label="상세 주소 (Address)" name="address"/>
                <petclinic:inputField label="도시 (City)" name="city"/>
                <petclinic:inputField label="전화번호 (Telephone)" name="telephone"/>
            </div>
            <div class="form-group" style="margin-bottom: 0;">
                <div class="col-sm-offset-2 col-sm-10" style="display: flex; gap: 10px;">
                    <button class="btn btn-primary" type="submit">
                        <c:if test="${owner['new']}"><span>보호자 등록 완료</span></c:if>
                        <c:if test="${!owner['new']}"><span>수정사항 저장</span></c:if>
                    </button>
                    <a href="<spring:url value="/owners/find" htmlEscape="true" />" class="btn btn-default">
                        <span>취소</span>
                    </a>
                </div>
            </div>
        </form:form>
    </div>
</petclinic:layout>
