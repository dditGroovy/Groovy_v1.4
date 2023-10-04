<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>메일 | 휴지통</title>
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
                    <button onclick="modifyDeleteAtByBtn()" class="btn btn-free-white btn-service"><span>복구</span>
                    </button>
                </th>
                <th style="width: 48px">
                    <button onclick="deleteMail()" class="btn btn-free-white btn-service"><span>영구 삭제</span></button>
                </th>
                <th colspan="4" style="text-align:left; vertical-align: middle">
                    ${unreadMailCount} / ${allMailCount}
                </th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty list}">
                    <c:forEach var="emailVO" items="${list}">
                        <tr data-id="${emailVO.emailEtprCode}">
                            <td><input type="checkbox" class="selectmail"></td>
                            <td onclick="modifyTableAt(this)" data-type="redng" class="cursor">
                                <c:if test="${emailVO.emailRedngAt eq 'N'}">
                                    <i class="icon i-mail mail-icon" data-at="N"></i>
                                </c:if>
                                <c:if test="${emailVO.emailRedngAt eq 'Y'}">
                                    <i class="icon i-mail-read mail-icon" data-at="Y"></i>
                                </c:if>
                                <c:if test="${empty emailVO.emailRedngAt}">
                                    <span>-</span>
                                </c:if>
                                <input type="hidden" value="${emailVO.emailDeleteAt}" name="deleteAt">
                            </td>
                            <td onclick="modifyTableAt(this)" data-type="imprtnc" class="cursor">
                                <c:choose>
                                    <c:when test="${emailVO.emailImprtncAt == 'N'}">
                                        <i class="icon i-star-out star-icon" data-at="N"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="icon i-star-fill star-icon" data-at="Y"></i>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${emailVO.emailFromAddr}</td>
                            <td><span>[${emailVO.emailBoxName}] </span><a href="#">${emailVO.emailFromSj}</a></td>
                            <c:set var="sendDateStr" value="${emailVO.emailFromSendDate}"/>
                            <fmt:formatDate var="sendDate" value="${sendDateStr}" pattern="yy.MM.dd"/>
                            <td>${sendDate}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td class="no-data" co>
                            메일이 존재하지 않습니다.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/mailAt.js"></script>
<script>
    let flag = true;

    function deleteMail() {
        checkboxes = document.querySelectorAll(".selectmail:checked");
        checkboxes.forEach(function (checkbox) {
            let tr = checkbox.closest("tr");
            let emailEtprCode = tr.getAttribute("data-id");

            let isDelete = confirm("휴지통에서 메일을 삭제하면 복구할 수 없습니다. 정말로 삭제하시겠습니까?");
            if (isDelete) {
                $.ajax({
                    url: `/email/\${emailEtprCode}`,
                    type: "put",
                    success: function (result) {
                        tr.remove();
                        document.querySelector("tbody").innerHTML = '<tr><td class="no-data" co="">메일이 존재하지 않습니다.</td></tr>';
                    },
                    error: function (xhr, status, error) {
                        console.log("code: " + xhr.status);
                        console.log("message: " + xhr.responseText);
                        console.log("error: " + xhr.error);
                    }
                });
            }
            checkbox.checked = false;
            allCheck.checked = false;
        });
    }
</script>
</body>
</html>