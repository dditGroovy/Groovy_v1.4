<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>메일 | 받은메일함</title>
    <link href="/resources/css/mail/mail.css" rel="stylesheet"/>
</head>
<body>
<div class="content-container">
    <jsp:include page="header.jsp"></jsp:include>
    <div class="contentWrap card card-df mail-all-wrap">
        <div class="serviceWrap">
            <div class="writeWrap">
                <a href="${pageContext.request.contextPath}/email/send">메일 쓰기</a>
                <a href="${pageContext.request.contextPath}/email/sendMine">내게 쓰기</a>
            </div>
            <div class="select-wrapper">
                <select name="sortMail" id="" class="stroke selectBox">
                    <option value="DESC">최신순</option>
                    <option value="ASC">오래된순</option>
                </select>
            </div>
        </div>
        <table class="form">
            <thead>
            <tr>
                <th style="width: 80px">
                    <input type="checkbox" id="selectAll" onclick="checkAll()">
                </th>
                <th style="width: 48px">
                    <button onclick="modifyAtByBtn()" class="btn btn-free-white btn-service"><span>읽음</span></button>
                </th>
                <th style="width: 48px">
                    <button onclick="modifyDeleteAtByBtn()" class="btn btn-free-white btn-service"><span>삭제</span>
                    </button>
                </th>
                <th colspan="4" style="text-align:left; vertical-align: middle">
                    ${unreadMailCount} <span class="total-mail-text">/ ${allMailCount}</span>
                </th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty list}">
                    <c:forEach var="emailVO" items="${list}">
                        <tr data-id="${emailVO.emailEtprCode}">
                            <td><input type="checkbox" class="selectMail"></td>
                            <td onclick="modifyTableAt(this)" data-type="redng" class="cursor">
                                <c:if test="${emailVO.emailRedngAt eq 'N'}">
                                    <i class="icon i-mail mail-icon" data-at="N"></i>
                                </c:if>
                                <c:if test="${emailVO.emailRedngAt eq 'Y'}">
                                    <i class="icon i-mail-read mail-icon" data-at="Y"></i>
                                </c:if>
                                <input type="hidden" value="${emailVO.emailDeleteAt}" name="deleteAt">
                            </td>
                            <td onclick="modifyTableAt(this)" data-type="imprtnc" class="cursor">
                                <c:if test="${emailVO.emailImprtncAt == 'N'}">
                                    <i class="icon i-star-out star-icon" data-at="N"></i>
                                </c:if>
                                <c:if test="${emailVO.emailImprtncAt == 'Y'}">
                                    <i class="icon i-star-fill star-icon" data-at="Y"></i>
                                </c:if>
                            </td>
                            <td class="from">${emailVO.emailFromAddr}</td>
                            <td class="subject"><a href="/email/read/${emailVO.emailEtprCode}">${emailVO.emailFromSj}</a>
                            </td>
                            <c:set var="sendDateStr" value="${emailVO.emailFromSendDate}"/>
                            <fmt:formatDate var="sendDate" value="${sendDateStr}" pattern="yy.MM.dd"/>
                            <td class="fromDate">${sendDate}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td class="no-data" colspan="7">
                            메일이 존재하지 않습니다.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <div class="pagination-wrapper">
                <ul class="pagination">
                    <li class="page-item \${pager.pre==false?'disabled':''}" value="${pageVO.pre}" id="pre">
                        <a class="page-link" href="/email/inbox?page=${pageVO.page-1}" aria-label="Previous">
                            <span aria-hidden="true" class="color-font-high font-14">Prev</span>
                        </a>
                    </li>

                    <c:forEach var="i" begin="${pageVO.startNum}" end="${pageVO.lastNum}">
                        <li class="page-item ${pageVO.page==i? 'active':''}">
                            <a class="page-link page-num" href="/email/inbox?page=${i}">${i}</a>
                        </li>
                    </c:forEach>

                    <li class="${pageVO.next?'':'disabled'}" id="next">
                        <a href="/email/inbox?page=${pageVO.page+1}" aria-label="Next">
                            <span class="color-font-high font-14">Next</span>
                        </a>
                    </li>
                </ul>
            </div>
        </c:if>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/mailAt.js"></script>
</body>
</html>