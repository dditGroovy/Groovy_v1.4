<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<sec:authentication property="principal" var="CustomUser"/>
<fmt:formatDate value="${paystub.salaryDtsmtIssuDate}" var="month" pattern="M"/>
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
    <header>
        <ul>
            <li><a href="${pageContext.request.contextPath}/vacation">내 휴가</a></li>
            <li><a href="${pageContext.request.contextPath}/salary/paystub/checkPassword">내 급여</a></li>
            <li><a href="${pageContext.request.contextPath}/vacation/record">휴가 기록</a></li>
        </ul>
    </header>

    <main>
        <div>
            <table border="1" id="paystub">
                <tr>
                    <td colspan="2">${month}월 급여명세서</td>
                </tr>
                <tr>
                    <td colspan="2">실 수령액</td>
                </tr>
                <tr>
                    <td colspan="2">${salaryDtsmtNetPay} 원</td>
                </tr>
                <tr>
                    <td>지급</td>
                    <td>${salaryDtsmtPymntTotamt} 원</td>
                </tr>
                <tr>
                    <td>통상 임금</td>
                    <td>${salaryBslry} 원</td>
                </tr>
                <tr>
                    <td>시간 외 수당</td>
                    <td>${salaryOvtimeAllwnc} 원</td>
                </tr>
                <tr>
                    <td>공제</td>
                    <td>${salaryDtsmtDdcTotamt} 원</td>
                </tr>
                <tr>
                    <td>국민연금</td>
                    <td>${salaryDtsmtSisNp} 원</td>
                </tr>
                <tr>
                    <td>건강보험</td>
                    <td>${salaryDtsmtSisHi} 원</td>
                </tr>
                <tr>
                    <td>고용보험</td>
                    <td>${salaryDtsmtSisEi} 원</td>
                </tr>
                <tr>
                    <td>산재보험</td>
                    <td>${salaryDtsmtSisWci} 원</td>
                </tr>
                <tr>
                    <td>소득세</td>
                    <td>${salaryDtsmtIncmtax} 원</td>
                </tr>
                <tr>
                    <td>지방소득세</td>
                    <td>${salaryDtsmtLocalityIncmtax} 원</td>
                </tr>
            </table>
            <div>
                <button id="downloadBtn">급여명세서 다운로드</button>
            </div>
        </div>

        <div>
            <div>
                <p>지급 내역</p>
                <label><input type="checkbox" id="hideAmount"/>금액 숨기기</label>
                <select name="selectedYear" id="selectedYear">
                    <c:forEach items="${years}" var="year">
                        <option value="${year}">${year}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <table id="paystubList" border="1">

                </table>
            </div>
        </div>
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
                    let months = date.getMonth() + 1;
                    let formatedDate = date.getFullYear() + "년 " +
                        (months < 10 ? "0" : "") + months + "월 " +
                        (date.getDate() < 10 ? "0" : "") + date.getDate() + "일";
                    let paymentDate = date.getFullYear() + "-" +
                        (months < 10 ? "0" : "") + months + "-" +
                        (date.getDate() < 10 ? "0" : "") + date.getDate();
                    let netPay = obj.salaryDtsmtNetPay.toLocaleString();
                    code += `<tr>
                             <td><a href="/salary/paystub/detail/\${paymentDate}">\${months}월</a></td>
                             <td>\${formatedDate} 지급</td>
                             <td id="totalStr">실수령액</td>
                             <td id="total">\${netPay} 원</td>
                          </tr>`
                });
                $("#paystubList").html(code);
                if ($("#hideAmount").prop("checked")) {
                    $("#totalStr, #total").css("visibility", "hidden");
                } else {
                    $("#totalStr, #total").css("visibility", "visible");
                }
            },
            error: function (xhr) {
                console.log(xhr.responseText);
            }
        })
    }

    $("#hideAmount").on("click", function () {
        let isChecked = $(this).prop("checked");

        $.ajax({
            url: "/salary/paystub/saveCheckboxState",
            type: "post",
            data: { "isChecked" : isChecked },
            success: function (result) {
            },
            error: function (xhr) {
                console.log(xhr.responseText);
            }
        });
    });

    let jsPDF = jspdf.jsPDF;

    $("#downloadBtn").on("click", function() {
        html2canvas($('#paystub')[0]).then(function(canvas) {
            let imgData = canvas.toDataURL('image/png');
            let imgWidth = 150;
            let pageHeight = 300;
            let imgHeight = parseInt(canvas.height * imgWidth / canvas.width);
            let heightLeft = imgHeight;
            let margin = 10;

            let doc = new jsPDF('p', 'mm','a4');
            let position = 30;

            doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;

            while (heightLeft >= 0) {
                position = heightLeft - imgHeight;
                doc.addPage();
                doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }

            let fileName = "${CustomUser.employeeVO.emplId}_${CustomUser.employeeVO.emplNm}_${month}월_급여명세서.pdf";
            doc.save(fileName);
        });
    });
</script>