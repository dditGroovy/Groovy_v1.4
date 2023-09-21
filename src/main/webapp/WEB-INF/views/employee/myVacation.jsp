<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/vacation" class="on">내 휴가</a></h1>
        <h1><a href="${pageContext.request.contextPath}/salary/paystub/checkPassword">내 급여</a></h1>
        <h1><a href="${pageContext.request.contextPath}/vacation/record">휴가 기록</a></h1>
    </header>
    <main>
        <div class="main-inner vacation-inner">
            <div class="status-wrap">
                <ul id="sanctionStatus" class="total-status">
                    <li class="status-item total-item">
                        <p class="status-item-title total-item-title">발생 연차</p>
                        <p class="status-item-content total-item-content">
                            <a href="#" class="strong font-b font-32">${usedVacationCnt}</a>건</p>
                    </li>
                    <li class="status-item total-item">
                        <p class="status-item-title total-item-title">사용 연차</p>
                        <p class="status-item-content total-item-content">
                            <a href="#"  class="strong font-b font-32">${usedVacationCnt}</a>건</p>
                    </li>
                    <li class="status-item total-item">
                        <p class="status-item-title total-item-title">잔여 연차</p>
                        <p class="status-item-content total-item-content">
                            <a href="#"  class="strong font-b font-32">${nowVacationCnt}</a>건</p>
                    </li>
                </ul>
                <table>
                    <tr>
                        <th>발생 연차</th>
                        <th>사용 연차</th>
                        <th>잔여 연차</th>
                    </tr>
                    <tr>
                        <th>${totalVacationCnt}</th>
                        <th>${usedVacationCnt}</th>
                        <th>${nowVacationCnt}</th>
                    </tr>
                </table>
            </div>
        </div>
        <div>
            <div>
                <div>
                    <div><p>최근 휴가 기록</p></div>
                    <div><a href="${pageContext.request.contextPath}/vacation/request">휴가 신청</a></div>
                </div>
                <div id="myVacation">
                    <ul>
                        <c:choose>
                            <c:when test="${not empty myVacation}">
                                <c:forEach items="${myVacation}" var="myVacation">
                                    <c:choose>
                                        <c:when test="${myVacation.yrycUseDtlsBeginDate == myVacation.yrycUseDtlsEndDate}">
                                            <li>${myVacation.commonCodeYrycUseKind}
                                                | ${myVacation.yrycUseDtlsBeginDate}</li>
                                        </c:when>
                                        <c:otherwise>
                                            <li>${myVacation.commonCodeYrycUseKind} | ${myVacation.yrycUseDtlsBeginDate}
                                                ~ ${myVacation.yrycUseDtlsEndDate}</li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li>휴가 정보가 없습니다.</li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
            <div>
                <div><p>구성원의 휴가(연락금지)</p></div>
                <div id="memVacation">
                    <ul>
                        <c:choose>
                            <c:when test="${not empty myVacation}">
                                <c:forEach items="${teamMemVacation}" var="memVacation">
                                    <c:choose>
                                        <c:when test="${memVacation.yrycUseDtlsBeginDate == memVacation.yrycUseDtlsEndDate}">
                                            <li>
                                                <img src="${memVacation.profileFileName}"/>
                                                    ${memVacation.yrycUseDtlsEmplNm}
                                                | ${memVacation.commonCodeYrycUseKind} ${memVacation.yrycUseDtlsBeginDate}
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li>
                                                <img src="${memVacation.profileFileName}"/>
                                                    ${memVacation.yrycUseDtlsEmplNm}
                                                | ${memVacation.commonCodeYrycUseKind} ${memVacation.yrycUseDtlsBeginDate}
                                                ~ ${memVacation.yrycUseDtlsEndDate}
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li>휴가 정보가 없습니다.</li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </div>
    </main>
</div>