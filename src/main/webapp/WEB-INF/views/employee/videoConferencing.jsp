<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal" var="CustomUser"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonStyle.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/videoConferencing.css">
<header>
    <div class="logo">
        <img src="${pageContext.request.contextPath}/resources/images/logo.png">
    </div>
</header>
<main>
    <div class="btn-join">
        <button id="joinBtn" class="btn btn-fill-bl-sm font-md font-18">회의 참여하기</button>
    </div>

    <div id="streamWrap">
        <div id="videoStream">

        </div>
        <div id="streamControls" class="btn-control">
            <button id="cameraBtn">카메라 ON/OFF</button>
            <button id="micBtn">마이크 ON/OFF</button>
            <button id="leaveBtn">떠나기</button>
        </div>
    </div>
</main>
<script src="${pageContext.request.contextPath}/resources/js/AgoraRTC_N-4.19.0.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/videoConferencing.js"></script>