<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/vacation/manage" class="on">연차 관리</a></h1>
    </header>
    <main>
        <table border="1">
            <tr>
                <th>사번</th>
                <th>이름</th>
                <th>부서</th>
                <th>직급</th>
                <th>입사일</th>
                <th>보유 연차</th>
            </tr>
            <c:forEach items="${allEmplVacation}" var="vacation">
                <fmt:formatDate var= "emplEncpn" value="${vacation.emplEncpn}" type="date" pattern="yyyy-MM-dd" />
            <tr>
                <td class="yrycEmpId">${vacation.yrycEmpId}</td>
                <td>${vacation.emplNm}</td>
                <td>${vacation.deptNm}</td>
                <td>${vacation.clsfNm}</td>
                <td>${emplEncpn}</td>
                <td>
                    <button class="minusBtn">-</button>
                    <input type="number" class="yrycNowCo" value="${vacation.yrycNowCo}">
                    <button class="plusBtn">+</button>
                    <button class="saveBtn">저장</button>
                </td>
            </tr>
            </c:forEach>
        </table>
    </main>
</div>
<script>
    $(".minusBtn").on("click", function () {
        let inputElement = $(this).next("input[type='number']");
        let currentValue = parseFloat(inputElement.val());
        if (!isNaN(currentValue)) {
            inputElement.val(currentValue - 1);
        }
    });

    $(".plusBtn").on("click", function () {
        let inputElement = $(this).prev("input[type='number']");
        let currentValue = parseFloat(inputElement.val());
        if (!isNaN(currentValue)) {
            inputElement.val(currentValue + 1);
        }
    });

    $(".saveBtn").on("click", function() {
        let inputElement = $(this).siblings(".yrycNowCo");
        let currentValue = parseFloat(inputElement.val());
        let emplId = $(this).closest("tr").find(".yrycEmpId").text();

        let data = {
            yrycEmpId : emplId,
            yrycNowCo : currentValue
        }

        console.log(data);
        $.ajax({
            url : "/vacation/manage",
            type : "post",
            data: JSON.stringify(data),
            contentType: "application/json;charset:utf-8",
            success : function (result) {
                if(result == 1) {
                    location.href = "/vacation/manage";
                }
            },
            error : function (xhr) {
                alert("오류로 인하여 연차 개수 수정을 실패했습니다.")
            }
        })
    })
</script>