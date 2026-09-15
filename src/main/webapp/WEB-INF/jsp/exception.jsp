<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<petclinic:layout pageName="error">
    <div class="modern-card" style="max-width: 680px; margin: 40px auto; text-align: center; padding: 48px 32px;">
        <div style="width: 64px; height: 64px; background: #fef2f2; color: #ef4444; border-radius: 16px; display: inline-flex; align-items: center; justify-content: center; font-size: 32px; margin-bottom: 20px;">
            ⚡
        </div>
        <h2 style="font-size: 24px; font-weight: 800; color: #0f172a; margin-bottom: 12px;">
            스프링 예외 처리 &amp; 트랜잭션 롤백 테스트 (Oups)
        </h2>
        <p style="color: #64748b; font-size: 14px; line-height: 1.7; margin-bottom: 24px;">
            고의로 RuntimeException 예외를 발생시켜 Spring MVC의 <code>SimpleMappingExceptionResolver</code>가
            정상 작동하고 글로벌 에러 핸들러로 라우팅되는지 검증했습니다.
        </p>
        <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 14px; font-size: 13px; color: #475569; margin-bottom: 28px; text-align: left;">
            <div><strong>상태 코드:</strong> HTTP 500 (Internal Server Error)</div>
            <div><strong>예외 클래스:</strong> RuntimeException (Expected: controller used to showcase what happens when an exception is thrown)</div>
            <div><strong>처리 방식:</strong> SimpleMappingExceptionResolver &rarr; exception.jsp 뷰 렌더링</div>
        </div>
        <div style="display: flex; justify-content: center; gap: 12px;">
            <a href="<spring:url value="/" htmlEscape="true" />" class="btn btn-primary">
                <span>🏠 메인 화면으로 돌아가기</span>
            </a>
            <a href="<spring:url value="/test.jsp" htmlEscape="true" />" class="btn btn-default">
                <span>📊 3-Tier 상태 진단</span>
            </a>
        </div>
    </div>
</petclinic:layout>
