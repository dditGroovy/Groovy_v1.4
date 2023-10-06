<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/salary/mySalary.css">
<sec:authentication property="principal" var="CustomUser"/>
<fmt:formatDate value="${paystub.salaryDtsmtIssuDate}" var="month" pattern="M"/>
<fmt:formatDate value="${paystub.salaryDtsmtIssuDate}" var="year" pattern="Y"/>
<fmt:formatNumber var="salaryDtsmtDdcTotamt" value="${paystub.salaryDtsmtDdcTotamt}" type="number"
                  maxFractionDigits="3"/>
<fmt:formatNumber var="salaryDtsmtPymntTotamt" value="${paystub.salaryDtsmtPymntTotamt}" type="number"
                  maxFractionDigits="3"/>
<fmt:formatNumber var="salaryDtsmtNetPay" value="${paystub.salaryDtsmtNetPay}" type="number" maxFractionDigits="3"/>
<fmt:formatNumber var="salaryDtsmtSisNp" value="${paystub.salaryDtsmtSisNp}" type="number" maxFractionDigits="3"/>
<fmt:formatNumber var="salaryDtsmtSisHi" value="${paystub.salaryDtsmtSisHi}" type="number" maxFractionDigits="3"/>
<fmt:formatNumber var="salaryDtsmtSisEi" value="${paystub.salaryDtsmtSisEi}" type="number" maxFractionDigits="3"/>
<fmt:formatNumber var="salaryDtsmtSisWci" value="${paystub.salaryDtsmtSisWci}" type="number" maxFractionDigits="3"/>
<fmt:formatNumber var="salaryDtsmtIncmtax" value="${paystub.salaryDtsmtIncmtax}" type="number" maxFractionDigits="3"/>
<fmt:formatNumber var="salaryDtsmtLocalityIncmtax" value="${paystub.salaryDtsmtLocalityIncmtax}" type="number"
                  maxFractionDigits="3"/>
<fmt:formatNumber var="salaryBslry" value="${paystub.salaryBslry}" type="number" maxFractionDigits="3"/>
<fmt:formatNumber var="salaryOvtimeAllwnc" value="${paystub.salaryOvtimeAllwnc}" type="number" maxFractionDigits="3"/>
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/vacation">내 휴가</a></h1>
        <h1><a href="${pageContext.request.contextPath}/employee/confirm/salary" class="on">내 급여</a></h1>
        <h1><a href="${pageContext.request.contextPath}/vacation/request">휴가 기록</a></h1>
    </header>

    <main>
        <div class="main-inner salary-inner">
            <section class="sec">
                <div class="salary-wrap card card-df" id="paystub">
                    <div class="content-title-wrap">
                        <i class="icon i-budget"></i>
                        <h2 class="content-title">${year}년 ${month - 1}월 급여명세서</h2>
                    </div>
                    <div class="total-salary-wrap">
                        <h3>실 수령액</h3>
                        <h4>${salaryDtsmtNetPay}원</h4>
                    </div>
                    <div class="detail-salary-wrap">
                        <div class="payments">
                            <div class="payment-total-wrap total-wrap flex-wrap">
                                <p class="total-title">지급</p>
                                <h4 class="payment-total total">${salaryDtsmtPymntTotamt}원</h4>
                            </div>
                            <div class="payment-detail-wrap detail-wrap">
                                <div class="payment-detail-item detail-item flex-wrap">
                                    <p>통상 임금</p>
                                    <h5 class="payment-detail payment">${salaryBslry}원</h5>
                                </div>
                                <div class="payment-detail-item detail-item flex-wrap">
                                    <p>시간 외 수당</p>
                                    <h5 class="payment-detail payment">${salaryOvtimeAllwnc}원</h5>
                                </div>
                            </div>
                        </div>
                        <div class="deduction">
                            <div class="deduction-total-wrap total-wrap flex-wrap">
                                <p class="total-title">공제</p>
                                <h4 class="deduction-total total">${salaryDtsmtDdcTotamt}원</h4>
                            </div>
                            <div class="deduction-detail-wrap detail-wrap">
                                <div class="deduction-detail-item detail-item flex-wrap">
                                    <p>국민연금</p>
                                    <h5 class="deduction-detail payment">${salaryDtsmtSisNp}원</h5>
                                </div>
                                <div class="deduction-detail-item detail-item flex-wrap">
                                    <p>건강보험</p>
                                    <h5 class="deduction-detail payment">${salaryDtsmtSisHi}원</h5>
                                </div>
                                <div class="deduction-detail-item detail-item flex-wrap">
                                    <p>고용보험</p>
                                    <h5 class="deduction-detail payment">${salaryDtsmtSisEi}원</h5>
                                </div>
                                <div class="deduction-detail-item detail-item flex-wrap">
                                    <p>산재보험</p>
                                    <h5 class="deduction-detail payment">${salaryDtsmtSisWci}원</h5>
                                </div>
                                <div class="deduction-detail-item detail-item flex-wrap">
                                    <p>소득세</p>
                                    <h5 class="deduction-detail payment">${salaryDtsmtIncmtax}원</h5>
                                </div>
                                <div class="deduction-detail-item detail-item flex-wrap">
                                    <p>지방소득세</p>
                                    <h5 class="deduction-detail payment">${salaryDtsmtLocalityIncmtax}원</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="btn-wrap">
                        <button id="downloadBtn" class="btn btn-out-sm">급여명세서 <i class="icon i-down"></i></button>
                    </div>
                </div>
            </section>
            <section class="sec sec-salary-status">
                <div class="salary-status">
                    <div class="title-wrap">
                        <h2 class="main-title">지급 내역</h2>
                        <div class="salary-service-wrap">
                            <div class="toggle-wrap">
                                <label class="toggle" for="hideAmount">
                                    <input type="checkbox" id="hideAmount"
                                           value="${CustomUser.employeeVO.notificationVO.teamNotice}">
                                    <span class="slider"></span>
                                </label>
                                <span>금액 숨기기</span>
                            </div>

                            <div class="select-wrapper">
                                <select name="selectedYear" id="selectedYear" class="stroke selectBox">
                                    <c:forEach items="${years}" var="year">
                                        <option value="${year}">${year}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div>
                        <div class="paystubList">
                            <ul class="card card-df" id="paystubList">

                            </ul>
                        </div>
                    </div>
                </div>
            </section>
    </main>
</div>
<script>
    let isSavedChecked = ${CustomUser.employeeVO.hideAmount}
        $("#hideAmount").prop("checked", isSavedChecked);

    let year = $("#selectedYear").val();
    if (year != null) {
        loadPaystubList(year);
    }

    $("#selectedYear").on("change", function (event) {
        year = event.target.value;
        loadPaystubList(year);
    })

    $("#hideAmount").on("change", function () {
        if (this.checked) {
            $("#totalStr, #total").css("visibility", "hidden");
        } else {
            $("#totalStr, #total").css("visibility", "visible");
        }
    });

    function loadPaystubList(year) {
        $.ajax({
            url: `/salary/paystub/\${year}`,
            type: "get",
            success: function (result) {
                code = "";
                $.each(result, function (idx, obj) {
                    let date = new Date(obj.salaryDtsmtIssuDate);
                    let months = date.getMonth(); // 기준 달보다 1 작음
                    let formatedDate = date.getFullYear() + "년 " +
                        (months < 9 ? "0" : "") + (months + 1) + "월 " +
                        (date.getDate() < 10 ? "0" : "") + date.getDate() + "일";
                    let paymentDate = date.getFullYear() + "-" +
                        (months < 9 ? "0" : "") + (months + 1) + "-" +
                        (date.getDate() < 10 ? "0" : "") + date.getDate();
                    let netPay = obj.salaryDtsmtNetPay.toLocaleString();
                    code += `
                         <li><a href="/salary/paystub/detail/\${paymentDate}" class="payStub-item">
                            <div class="item-wrap">
                                <strong>\${months}월</strong>
                                <span>\${formatedDate} 지급</span>
                            </div>
                            <div class="item-wrap">
                                <strong id="totalStr">실수령액</strong>
                                <span id="total">\${netPay} 원</span>
                            </div>
                        </a></li>`
                });
                $("#paystubList").html(code);
                if ($("#hideAmount").prop("checked")) {
                    $("#totalStr, #total").css("visibility", "hidden");
                } else {
                    $("#totalStr, #total").css("visibility", "visible");
                }
            },
            error: function (xhr) {

            }
        })
    }

    $("#hideAmount").on("click", function () {
        let isChecked = $(this).prop("checked");

        $.ajax({
            url: "/salary/paystub/saveCheckboxState",
            type: "post",
            data: {"isChecked": isChecked},
            success: function (result) {
            },
            error: function (xhr) {

            }
        });
    });

    $("#downloadBtn").on("click", function () {
        let data = ${CustomUser.employeeVO.emplId};

        let contentTitle = document.querySelector(".content-title").textContent;
        let year = contentTitle.substring(contentTitle.indexOf("년") - 2, contentTitle.indexOf("년"));
        let month = contentTitle.substring(contentTitle.indexOf("월") - 1, contentTitle.indexOf("월"));
        month = month < 10 ? "0" + month : month;
        let date = year + month;
        location.href = `/file/download/salary?date=\${date}&data=\${data}`;
    });
</script>