<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>메일 | 휴지통</title>
</head>
<style>
    ul {
        list-style: none;
        padding-left: 0;
    }

    .mailnavWrap, .serviceWrap {
        display: flex;
        gap: 50px;
        align-items: center
    }

    .mailnavWrap ul {
        display: flex;
        justify-content: space-between;
        gap: 10px
    }

    .contentWrap {
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin-top: 50px;
    }
</style>
<body>
<jsp:include page="header.jsp"></jsp:include>
<div class="contentWrap">
    <div class="serviceWrap">
        <div class="serviceWrap">
            <div class="writeWrap">
                <a href="${pageContext.request.contextPath}/email/send">메일 쓰기</a>
                <a href="${pageContext.request.contextPath}/email/sendMine">내게 쓰기</a>
            </div>
            <div class="filterWrap">
                <label>필터</label>
                <select name="sortMail">
                    <option value="최신순">인사팀</option>
                    <option value="오래된순">회계팀</option>
                </select>
            </div>
        </div>
    </div>
    <table border="1" style="width: 80%; text-align: center">
        <thead>
        <tr>
            <th style="width: 100px">
                <input type="checkbox" id="selectAll" onclick="checkAll()">
            </th>
            <th style="width: 100px">
                읽음표시
                <button onclick="modifyDeleteAtByBtn()"><span>복구</span></button>
            </th>
            <th style="width: 100px">
                중요
                <button onclick="deleteMail()"><span>영구삭제</span></button>
            </th>
            <th style="width: 100px">파일여부</th>
            <th>보낸이</th>
            <th>제목</th>
            <th>날짜</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="emailCc" items="${list}">
            <tr data-id="${emailCc.emailEtprCode}">
                <td><input type="checkbox" class="selectmail"></td>
                <td onclick="modifyTableAt(this)" data-type="redng">
                        ${emailCc.emailRedngAt}
                    <input type="hidden" value="${emailCc.emailDeleteAt}" name="deleteAt">
                </td>
                <td onclick="modifyTableAt(this)" data-type="imprtnc">${emailCc.emailImprtncAt}</td>
                <td>파일존재여부</td>

                <td>${emailCc.emailFromAddr}</td>
                <td><span>[${emailCc.emailBoxName}] </span><a href="#">${emailCc.emailFromSj}</a></td>
                <c:set var="sendDateStr" value="${emailCc.emailFromSendDate}"/>
                <fmt:formatDate var="sendDate" value="${sendDateStr}" pattern="yy.MM.dd"/>
                <td>${sendDate}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<script src="${pageContext.request.contextPath}/resources/js/mailAt.js"></script>
<script>
    let flag = true;
    function deleteMail() {
        checkboxes = document.querySelectorAll(".selectmail:checked");
        checkboxes.forEach(function (checkbox) {
            let tr = checkbox.closest("tr");
            let emailEtprCode = tr.getAttribute("data-id");

            if (flag) {
                let isDelete = confirm("휴지통에서 메일을 삭제하면 복구할 수 없습니다. 정말로 삭제하시겠습니까?");
                if (isDelete) {
                    $.ajax({
                        url: `/email/\${emailEtprCode}`,
                        type: "put",
                        success: function (result) {
                            tr.remove();
                        },
                        error: function (xhr, status, error) {
                            console.log("code: " + xhr.status);
                            console.log("message: " + xhr.responseText);
                            console.log("error: " + xhr.error);
                        }
                    });
                }
                flag = false;
            }
            checkbox.checked = false;
            allCheck.checked = false;
        });
    }
</script>
</body>
</html>