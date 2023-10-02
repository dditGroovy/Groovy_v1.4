<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>초기 비밀번호 설정</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/resources/favicon.svg">
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" href="/resources/css/password/password.css">
</head>
<body>
<div class="container init-wrap">
    <main>
        <h1 style="display: none">그루비 초기 비밀번호 설정</h1>
        <div class="welcome-img-wrap">
            <img src="/resources/images/welcome.png" alt="welcome" class="welcome-img">
        </div>
        <div class="welcome-wrap">
            <h2 class="font-b font-32">입사를 축하합니다 🤗</h2>
            <p>비밀번호를 설정해주세요</p>
        </div>
        <div class="init-div">
            <form action="${pageContext.request.contextPath}/employee/initPassword" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <%--@declare id="memid"--%>
                <%--@declare id="mempassword"--%>
                <%--@declare id="passwordchk"--%>
                <%--<label for="emplId">아이디</label>--%>
                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal.username" var="emplId"/>
                <div class="input-wrap">
                <input type="hidden" name="emplId" id="emplId" readonly value="${emplId}"></sec:authorize>
                <input type="text" class="password btn-free-white input-l" name="emplPassword" id="empPass" placeholder="비밀번호"/>
                <input type="text" class="password btn-free-white input-l" name="passwordchk" id="passwordchk" placeholder="비밀번호 확인"/>
                </div>
                <div class="btn-wrap">
                    <button type="button" class="btn btn-free-blue input-l" id="submitBtn">비밀번호 설정하기</button>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>