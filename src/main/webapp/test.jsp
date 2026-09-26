<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%
    // =========================================================================
    // 3-Tier 연동 진단 — WEB → WAS → DB 요청 전달 및 연결 확인용
    // 과제 제공 자료(test.jsp)와 동일한 목적. 연동 확인에 필요한 항목만 표시한다.
    // =========================================================================

    // 1. 요청을 처리한 WAS 인스턴스 (ALB 분산 확인용)
    String hostname = "Unknown";
    String hostIp = "Unknown";
    try {
        InetAddress addr = InetAddress.getLocalHost();
        hostname = addr.getHostName();
        hostIp = addr.getHostAddress();
    } catch (Exception e) {
        hostname = "Error: " + e.getMessage();
    }

    // 2. WEB → WAS 요청 전달 경로
    String xff = request.getHeader("X-Forwarded-For");
    String clientIp = xff;
    if (clientIp == null || clientIp.isEmpty() || "unknown".equalsIgnoreCase(clientIp)) {
        clientIp = request.getHeader("Proxy-Client-IP");
    }
    if (clientIp == null || clientIp.isEmpty() || "unknown".equalsIgnoreCase(clientIp)) {
        clientIp = request.getRemoteAddr();
    }
    String proto = request.getHeader("X-Forwarded-Proto");
    if (proto == null) proto = request.getScheme();
    String albTraceId = request.getHeader("X-Amzn-Trace-Id");

    // 3. WAS → DB 연결 (Spring이 구성한 DataSource를 그대로 검증 — 접속정보 하드코딩 없음)
    boolean dbConnected = false;
    String dbStatusMsg = "Checking...";
    long dbPingTimeMs = -1;
    String dbUrl = "Unknown";

    try {
        ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(application);
        DataSource ds = (ac != null) ? ac.getBean(DataSource.class) : null;
        if (ds != null) {
            long startTime = System.currentTimeMillis();
            try (Connection conn = ds.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT 1")) {
                if (rs.next()) {
                    dbConnected = true;
                    dbPingTimeMs = System.currentTimeMillis() - startTime;
                    dbStatusMsg = "연결 성공";
                    try {
                        dbUrl = conn.getMetaData().getURL();
                    } catch (Exception ignore) {
                        dbUrl = "Spring DataSource Connected";
                    }
                }
            }
        } else {
            dbStatusMsg = "Spring DataSource Bean을 찾을 수 없음";
        }
    } catch (Exception e) {
        dbConnected = false;
        dbStatusMsg = "연결 실패 — " + e.getMessage();
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss (z)");
    String currentTimeStr = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3-Tier 연동 진단 · Vetcore</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/pretendard@1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.min.css">
    <style>
        /* WEB/WAS와 동일한 다크·골드 팔레트 */
        :root {
            --gold: #ceac54;
            --gold-light: #eacc7c;
            --on-gold: #241d0c;
            --bg: #050506;
            --card: #121215;
            --raised: #1b1b20;
            --line: rgba(255, 255, 255, 0.14);
            --txt: #ffffff;
            --muted: rgba(255, 255, 255, 0.62);
            --ok: #34d399;
            --ng: #f87171;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Pretendard Variable', 'Pretendard', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: var(--bg);
            color: var(--txt);
            line-height: 1.6;
            padding: 48px 24px;
            display: flex;
            justify-content: center;
        }
        .wrap { width: 100%; max-width: 880px; }
        .head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            padding-bottom: 24px;
            margin-bottom: 28px;
            border-bottom: 1px solid var(--line);
        }
        .head-left { display: flex; align-items: center; gap: 14px; }
        .mark {
            width: 46px; height: 46px; border-radius: 12px;
            background: linear-gradient(135deg, var(--gold-light), #a8873a);
            display: grid; place-items: center; font-size: 22px;
        }
        .head h1 { font-size: 21px; font-weight: 800; letter-spacing: -0.02em; }
        .head p { font-size: 13px; color: var(--muted); margin-top: 2px; }
        .back {
            padding: 10px 18px; border: 1px solid rgba(206, 172, 84, 0.55);
            border-radius: 999px; color: var(--gold);
            font-size: 13px; font-weight: 700; text-decoration: none;
            white-space: nowrap; transition: all 0.2s ease;
        }
        .back:hover { background: var(--gold); border-color: var(--gold); color: var(--on-gold); }

        .card {
            background: var(--card);
            border: 1px solid var(--line);
            border-radius: 16px;
            padding: 22px 24px;
            margin-bottom: 18px;
        }
        .card-head {
            display: flex; align-items: center; justify-content: space-between;
            gap: 12px; padding-bottom: 12px; margin-bottom: 14px;
            border-bottom: 1px solid var(--line);
        }
        .card-title { font-size: 15px; font-weight: 700; }
        .card-title em { font-style: normal; color: var(--muted); font-weight: 600; font-size: 13px; margin-left: 6px; }
        .badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 4px 12px; border-radius: 999px;
            font-size: 12px; font-weight: 700;
        }
        .badge.ok { background: rgba(52, 211, 153, 0.14); color: var(--ok); border: 1px solid rgba(52, 211, 153, 0.35); }
        .badge.ng { background: rgba(248, 113, 113, 0.14); color: var(--ng); border: 1px solid rgba(248, 113, 113, 0.35); }
        .dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

        .row { display: flex; justify-content: space-between; align-items: center; gap: 16px; padding: 9px 0; font-size: 14px; }
        .row + .row { border-top: 1px solid rgba(255, 255, 255, 0.05); }
        .k { color: var(--muted); }
        .v {
            font-family: 'Consolas', 'Menlo', monospace;
            font-weight: 600;
            background: var(--raised);
            border: 1px solid var(--line);
            padding: 3px 10px; border-radius: 6px;
            max-width: 62%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
        }
        .v.warn { color: var(--ng); }
    </style>
</head>
<body>
<div class="wrap">

    <div class="head">
        <div class="head-left">
            <span class="mark">🐾</span>
            <div>
                <h1>3-Tier 연동 진단</h1>
                <p>WEB → WAS → DB 요청 전달 및 연결 확인 · <%= currentTimeStr %></p>
            </div>
        </div>
        <a href="/" class="back">&larr; 메인으로</a>
    </div>

    <!-- 1. 이 요청을 처리한 WAS 인스턴스 -->
    <div class="card">
        <div class="card-head">
            <span class="card-title">⚙️ WAS 인스턴스<em>요청을 처리한 서버</em></span>
            <span class="badge ok"><span class="dot"></span>응답 정상</span>
        </div>
        <div class="row"><span class="k">호스트명</span><span class="v"><%= hostname %></span></div>
        <div class="row"><span class="k">내부 IP</span><span class="v"><%= hostIp %></span></div>
    </div>

    <!-- 2. WEB → WAS 요청 전달 경로 -->
    <div class="card">
        <div class="card-head">
            <span class="card-title">🌐 요청 전달 경로<em>WEB → WAS</em></span>
            <span class="badge <%= (xff != null) ? "ok" : "ng" %>">
                <span class="dot"></span><%= (xff != null) ? "프록시 경유 확인" : "직접 접속" %>
            </span>
        </div>
        <div class="row"><span class="k">클라이언트 IP</span><span class="v"><%= clientIp %></span></div>
        <div class="row"><span class="k">X-Forwarded-For</span><span class="v"><%= (xff != null) ? xff : "-" %></span></div>
        <div class="row"><span class="k">X-Forwarded-Proto</span><span class="v"><%= proto %></span></div>
        <div class="row"><span class="k">ALB Trace-Id</span><span class="v"><%= (albTraceId != null) ? albTraceId : "-" %></span></div>
    </div>

    <!-- 3. WAS → DB 연결 -->
    <div class="card">
        <div class="card-head">
            <span class="card-title">🗄️ DB 연동<em>WAS → DB</em></span>
            <span class="badge <%= dbConnected ? "ok" : "ng" %>">
                <span class="dot"></span><%= dbConnected ? "연결 정상" : "연결 실패" %>
            </span>
        </div>
        <div class="row">
            <span class="k">상태</span>
            <span class="v <%= dbConnected ? "" : "warn" %>"><%= dbStatusMsg %></span>
        </div>
        <div class="row"><span class="k">대상 DB</span><span class="v"><%= dbUrl %></span></div>
        <div class="row"><span class="k">응답 시간</span><span class="v"><%= (dbPingTimeMs >= 0) ? (dbPingTimeMs + " ms") : "-" %></span></div>
    </div>

</div>
</body>
</html>
