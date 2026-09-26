<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<petclinic:layout pageName="error">
    <div class="modern-card" style="max-width: 680px; margin: 40px auto; text-align: center; padding: 48px 32px;">
        <div style="width: 64px; height: 64px; background: var(--danger-light); color: var(--danger); border-radius: 16px; display: inline-flex; align-items: center; justify-content: center; font-size: 32px; margin-bottom: 20px;">
            ⚡
        </div>
        <h2 style="font-size: 24px; font-weight: 800; color: var(--text-main); margin-bottom: 12px;">
            요청 처리 중 예외가 발생했습니다
        </h2>
        <p style="color: var(--text-muted); font-size: 14px; line-height: 1.7; margin-bottom: 24px;">
            애플리케이션 처리 도중 오류가 발생했습니다. 아래 예외 상세 내용을 확인하거나 잠시 후 다시 시도해 주세요.
        </p>
        <div style="background: var(--bg-raised); border: 1px solid #e2e8f0; border-radius: 10px; padding: 14px; font-size: 13px; color: var(--text-muted); margin-bottom: 28px; text-align: left; word-break: break-all;">
            <div style="margin-bottom: 6px;"><strong>상태 코드:</strong> HTTP 500 (Internal Server Error)</div>
            <div style="margin-bottom: 6px;"><strong>예외 클래스:</strong> <code><c:out value="${exception['class'].name}" default="알 수 없음"/></code></div>
            <div><strong>상세 메시지:</strong> <span style="color: var(--danger);"><c:out value="${exception.message}" default="상세 메시지가 없습니다."/></span></div>
        </div>
        <div style="display: flex; justify-content: center; gap: 12px;">
            <a href="/" class="btn btn-primary">
                <span>🏠 메인 화면으로 돌아가기</span>
            </a>
            <a href="<spring:url value="/test.jsp" htmlEscape="true" />" class="btn btn-default">
                <span>📊 3-Tier 상태 진단</span>
            </a>
        </div>
    </div>
</petclinic:layout>
