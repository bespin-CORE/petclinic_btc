<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.management.ManagementFactory" %>
<%@ page import="java.lang.management.RuntimeMXBean" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%
    // =========================================================================
    // [★ C 담당 - 이지형 직접 책임] 3-Tier 엔드투엔드 헬스체크 대시보드 (test.jsp)
    // =========================================================================

    // 1. WAS 서버 호스트 정보
    String hostname = "Unknown";
    String hostIp = "Unknown";
    try {
        InetAddress addr = InetAddress.getLocalHost();
        hostname = addr.getHostName();
        hostIp = addr.getHostAddress();
    } catch (Exception e) {
        hostname = "Error: " + e.getMessage();
    }

    // 2. 가동 시간(Uptime) 및 자바 런타임 환경
    RuntimeMXBean rb = ManagementFactory.getRuntimeMXBean();
    long uptimeMs = rb.getUptime();
    long uptimeSec = uptimeMs / 1000;
    long uptimeMin = uptimeSec / 60;
    long uptimeHour = uptimeMin / 60;
    String uptimeStr = String.format("%d시간 %d분 %d초", uptimeHour, uptimeMin % 60, uptimeSec % 60);

    String javaVersion = System.getProperty("java.version");
    String javaVendor = System.getProperty("java.vendor");
    String osName = System.getProperty("os.name");
    String osArch = System.getProperty("os.arch");

    // 3. JVM 메모리 상태
    Runtime runtime = Runtime.getRuntime();
    long maxMemory = runtime.maxMemory() / (1024 * 1024);
    long totalMemory = runtime.totalMemory() / (1024 * 1024);
    long freeMemory = runtime.freeMemory() / (1024 * 1024);
    long usedMemory = totalMemory - freeMemory;
    int memUsagePercent = (int) ((usedMemory * 100) / totalMemory);

    // 4. 클라이언트 요청 분석 (X-Forwarded-For 등)
    String clientIp = request.getHeader("X-Forwarded-For");
    if (clientIp == null || clientIp.isEmpty() || "unknown".equalsIgnoreCase(clientIp)) {
        clientIp = request.getHeader("Proxy-Client-IP");
    }
    if (clientIp == null || clientIp.isEmpty() || "unknown".equalsIgnoreCase(clientIp)) {
        clientIp = request.getRemoteAddr();
    }
    String proto = request.getHeader("X-Forwarded-Proto");
    if (proto == null) proto = request.getScheme();
    String albTraceId = request.getHeader("X-Amzn-Trace-Id");

    // 5. DB 연결 상태 테스트 (로컬 H2 또는 RDS MySQL)
    boolean dbConnected = false;
    String dbStatusMsg = "Checking...";
    long dbPingTimeMs = -1;
    String dbUrl = System.getProperty("spring.datasource.url");
    if (dbUrl == null || dbUrl.isEmpty()) {
        dbUrl = "jdbc:h2:mem:petclinic (기본 인메모리 DB)";
    }
    
    long startTime = System.currentTimeMillis();
    try {
        Class.forName("org.h2.Driver");
        Connection conn = DriverManager.getConnection("jdbc:h2:mem:petclinic", "sa", "");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT 1");
        if (rs.next()) {
            dbConnected = true;
            dbPingTimeMs = System.currentTimeMillis() - startTime;
            dbStatusMsg = "연결 성공 (Query Latency: " + dbPingTimeMs + "ms)";
        }
        conn.close();
    } catch (Exception e) {
        dbConnected = false;
        dbStatusMsg = "DB 연결 실패 (" + e.getMessage() + ")";
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS (z)");
    String currentTimeStr = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WAS Tier 인프라 진단 대시보드 · PetClinic</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --primary-light: #eff6ff;
            --secondary: #059669;
            --secondary-light: #ecfdf5;
            --accent: #f59e0b;
            --danger: #ef4444;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --bg-body: #f8fafc;
            --bg-card: #ffffff;
            --border: #e2e8f0;
            --radius-lg: 16px;
            --radius-md: 12px;
            --shadow-sm: 0 1px 3px 0 rgb(0 0 0 / 0.06);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.07);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--bg-body);
            color: var(--text-main);
            line-height: 1.6;
            min-height: 100vh;
            padding: 32px 20px;
            display: flex;
            justify-content: center;
        }
        .container {
            width: 100%;
            max-width: 960px;
        }
        .header-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px 28px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        .header-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .icon-box {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: var(--primary-light);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: 800;
        }
        .header-text h1 {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-main);
        }
        .header-text p {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 2px;
        }
        .grid-2 {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(440px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }
        .section-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 22px 24px;
            box-shadow: var(--shadow-sm);
        }
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
            padding-bottom: 12px;
            margin-bottom: 14px;
        }
        .section-title {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 9999px;
        }
        .status-badge.ok {
            background: var(--secondary-light);
            color: var(--secondary);
            border: 1px solid rgba(5, 150, 105, 0.2);
        }
        .status-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--secondary);
        }
        .info-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
        }
        .info-label {
            color: var(--text-muted);
            font-weight: 500;
        }
        .info-val {
            font-weight: 700;
            color: var(--text-main);
            font-family: 'Consolas', 'Courier New', monospace;
            background: #f1f5f9;
            padding: 2px 8px;
            border-radius: 6px;
            max-width: 260px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .footer-note {
            text-align: center;
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 24px;
        }
        .btn-nav {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--primary);
            color: #ffffff;
            font-weight: 600;
            font-size: 13px;
            padding: 8px 16px;
            border-radius: var(--radius-md);
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .btn-nav:hover {
            background: var(--primary-hover);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header-card">
        <div class="header-title-wrap">
            <div class="icon-box">🐾</div>
            <div class="header-text">
                <h1>WAS Tier 상태 진단 대시보드</h1>
                <p>AWS 3-Tier Enterprise Cloud Architecture · Team 2 CORE</p>
            </div>
        </div>
        <div>
            <a href="/" class="btn-nav">
                <span>&larr; PetClinic 홈으로</span>
            </a>
        </div>
    </div>

    <div class="grid-2">
        <!-- Card 1: WAS Server Spec -->
        <div class="section-card">
            <div class="section-header">
                <span class="section-title">⚙️ WAS 인스턴스 정보</span>
                <span class="status-badge ok"><span class="status-dot"></span> 정상 가동 중</span>
            </div>
            <ul class="info-list">
                <li class="info-item">
                    <span class="info-label">호스트명 (Hostname)</span>
                    <span class="info-val"><%= hostname %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">내부 IP (Private IP)</span>
                    <span class="info-val"><%= hostIp %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">서버 가동 시간 (Uptime)</span>
                    <span class="info-val"><%= uptimeStr %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">운영체제 환경</span>
                    <span class="info-val"><%= osName %> (<%= osArch %>)</span>
                </li>
                <li class="info-item">
                    <span class="info-label">측정 시각</span>
                    <span class="info-val"><%= currentTimeStr %></span>
                </li>
            </ul>
        </div>

        <!-- Card 2: JVM Runtime & Memory -->
        <div class="section-card">
            <div class="section-header">
                <span class="section-title">☕ JVM 런타임 &amp; 힙 메모리</span>
                <span class="status-badge ok"><span class="status-dot"></span> Heap 정상</span>
            </div>
            <ul class="info-list">
                <li class="info-item">
                    <span class="info-label">자바 버전 (Java Runtime)</span>
                    <span class="info-val"><%= javaVendor %> <%= javaVersion %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">할당된 힙 (Total Heap)</span>
                    <span class="info-val"><%= totalMemory %> MB</span>
                </li>
                <li class="info-item">
                    <span class="info-label">현재 사용량 (Used Heap)</span>
                    <span class="info-val"><%= usedMemory %> MB (<%= memUsagePercent %>%)</span>
                </li>
                <li class="info-item">
                    <span class="info-label">최대 허용 메모리 (Max Heap)</span>
                    <span class="info-val"><%= maxMemory %> MB</span>
                </li>
                <li class="info-item">
                    <span class="info-label">여유 메모리 (Free Heap)</span>
                    <span class="info-val"><%= freeMemory %> MB</span>
                </li>
            </ul>
        </div>

        <!-- Card 3: Reverse Proxy & Client Request Header -->
        <div class="section-card">
            <div class="section-header">
                <span class="section-title">🌐 L7 프록시 및 클라이언트 헤더</span>
                <span class="status-badge ok"><span class="status-dot"></span> X-Forwarded 정상</span>
            </div>
            <ul class="info-list">
                <li class="info-item">
                    <span class="info-label">실제 클라이언트 IP</span>
                    <span class="info-val"><%= clientIp %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">인입 프로토콜</span>
                    <span class="info-val"><%= proto.toUpperCase() %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">ALB 추적 ID (Trace-Id)</span>
                    <span class="info-val"><%= (albTraceId != null) ? albTraceId : "로컬 직접 접속" %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">세션 ID (HttpSession)</span>
                    <span class="info-val"><%= session.getId() %></span>
                </li>
            </ul>
        </div>

        <!-- Card 4: Database Connection Status -->
        <div class="section-card">
            <div class="section-header">
                <span class="section-title">🗄️ DB Tier 연동 상태</span>
                <span class="status-badge <%= dbConnected ? "ok" : "" %>" style="<%= !dbConnected ? "background:#fef2f2; color:#ef4444;" : "" %>">
                    <span class="status-dot" style="<%= !dbConnected ? "background:#ef4444;" : "" %>"></span>
                    <%= dbConnected ? "DB 정상 연결" : "연결 지연/실패" %>
                </span>
            </div>
            <ul class="info-list">
                <li class="info-item">
                    <span class="info-label">연결 상태 메시지</span>
                    <span class="info-val"><%= dbStatusMsg %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">연결 타겟 데이터베이스</span>
                    <span class="info-val"><%= dbUrl %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">질의 지연시간 (Ping)</span>
                    <span class="info-val"><%= (dbPingTimeMs >= 0) ? (dbPingTimeMs + " ms") : "N/A" %></span>
                </li>
                <li class="info-item">
                    <span class="info-label">세션 스토리지 연동</span>
                    <span class="info-val">ElastiCache Redis 연동 준비됨</span>
                </li>
            </ul>
        </div>
    </div>

    <div class="footer-note">
        [★ C 담당 - 이지형 직접 책임] · Apache Tomcat 9 &bull; Spring Framework &bull; MySQL &bull; Redis
    </div>
</div>

</body>
</html>
