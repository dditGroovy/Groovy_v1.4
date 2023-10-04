<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/vacation/vacation.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/vacation" class="on">내 휴가</a></h1>
        <h1><a href="${pageContext.request.contextPath}/employee/confirm/salary">내 급여</a></h1>
        <h1><a href="${pageContext.request.contextPath}/vacation/request">휴가 기록</a></h1>
    </header>
    <main>
        <div class="main-inner vacation-inner">
            <div class="status-wrap">
                <ul id="sanctionStatus" class="total-status">
                    <li class="status-item total-item">
                        <p class="status-item-title total-item-title">발생 연차</p>
                        <p class="status-item-content total-item-content">
                            <span class="strong font-b font-32">${totalVacationCnt}</span>개</p>
                    </li>
                    <li class="status-item total-item">
                        <p class="status-item-title total-item-title">사용 연차</p>
                        <p class="status-item-content total-item-content">
                            <span class="strong font-b font-32">${usedVacationCnt}</span>개</p>
                    </li>
                    <li class="status-item total-item">
                        <p class="status-item-title total-item-title">잔여 연차</p>
                        <p class="status-item-content total-item-content">
                            <span class="strong font-b font-32">${nowVacationCnt}</span>개</p>
                    </li>
                </ul>
            </div>
            <div class="vacation-info-wrap">
                <div class="myVation-wrap content-wrap">
                    <div class="content-header">
                        <h2 class="main-title">최근 휴가 기록</h2>
                        <a href="${pageContext.request.contextPath}/vacation/request" class="btn btn-free-blue vationRequest">휴가 신청</a>
                    </div>
                    <div id="myVacation" class="card-df vacation-card">
                        <ul class="myVacation-list vacation-list">
                            <c:choose>
                                <c:when test="${not empty myVacation}">
                                    <c:forEach items="${myVacation}" var="myVacation">
                                        <c:choose>
                                            <c:when test="${myVacation.yrycUseDtlsBeginDate == myVacation.yrycUseDtlsEndDate}">
                                                <li class="color-font-md vacation-list-item"> <strong class="font-b">${myVacation.commonCodeYrycUseKind}</strong>
                                                    ${myVacation.yrycUseDtlsBeginDate}</li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="color-font-md vacation-list-item"><strong class="font-b">${myVacation.commonCodeYrycUseKind}</strong> ${myVacation.yrycUseDtlsBeginDate}
                                                    ~ ${myVacation.yrycUseDtlsEndDate}</li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li class="no-list">휴가 정보가 없습니다.</li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
                <div class="memVacation-wrap content-wrap">
                    <div class="content-header">
                        <h2 class="main-title">구성원의 휴가(연락금지)</h2>
                    </div>
                    <div id="memVacation" class="card-df vacation-card">
                        <ul class="memVacation-list vacation-list">
                            <c:choose>
                                <c:when test="${not empty teamMemVacation}">
                                    <c:forEach items="${teamMemVacation}" var="memVacation">
                                        <c:choose>
                                            <c:when test="${memVacation.yrycUseDtlsBeginDate == memVacation.yrycUseDtlsEndDate}">
                                                <li class="color-font-md vacation-list-item">
                                                    <img src="/uploads/profile/${memVacation.profileFileName}" class="member-profile"/>
                                                    <strong class="font-b">${memVacation.yrycUseDtlsEmplNm}</strong>
                                                    ${memVacation.commonCodeYrycUseKind} ${memVacation.yrycUseDtlsBeginDate}
                                                </li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="color-font-md vacation-list-item">
                                                    <img src="/uploads/profile/${memVacation.profileFileName}" class="member-profile"/>
                                                    <strong class="font-b">${memVacation.yrycUseDtlsEmplNm}</strong>
                                                    ${memVacation.commonCodeYrycUseKind} ${memVacation.yrycUseDtlsBeginDate}
                                                    ~ ${memVacation.yrycUseDtlsEndDate}
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li class="no-list">휴가 정보가 없습니다.</li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>