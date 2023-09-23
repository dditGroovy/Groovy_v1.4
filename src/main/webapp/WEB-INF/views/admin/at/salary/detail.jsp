<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="content-container">
    <h2>급여 상세</h2>
    <div>
        <table border=" 1">
            <c:forEach var="emplVO" items="${empList}" varStatus="stat">
                <tr>
                    <td><a href="#" onclick="getPaymentList(${emplVO.emplId})"> ${emplVO.emplId}</a></td>
                    <td>${emplVO.emplNm}</td>
                    <td>${emplVO.commonCodeDept}팀</td>
                    <td>${emplVO.commonCodeClsf}</td>
                </tr>
            </c:forEach>
        </table>
        <select name="sortOptions" id="yearSelect" class="stroke"></select>
    </div>
    <div id="paymentList">
    </div>
    <div id="paymentDetail">
    </div>
</div>
<script>
    let year;
    let tariffList;

    let yearSelect = document.querySelector("#yearSelect");

    getAllYear();

    function getAllYear() {
        $.ajax({
            type: 'get',
            url: `/salary/years`,
            dataType: 'json',
            success: function (result) {
                let code = ``;
                for (let i = 0; i < result.length; i++) {
                    code += `<option value="\${result[i]}">\${result[i]}</option>`;
                }
                yearSelect.innerHTML = code;
                year = result[0];
            },
            error: function (xhr) {
                xhr.status;
            }
        });
    }

    function getPaymentList(id) {
        year = $("#yearSelect").val();
        $.ajax({
            url: `/salary/payment/list/\${id}/\${year}`,
            type: 'GET',
            success: function (data) {
                tariffList = data.tariffList;
                let code = "<table border=1>";
                if (data.salaryList.length === 0) {
                    code += "<tr><td>상세 내역이 없습니다</td></tr>";
                } else {
                    for (let i = 0; i < data.salaryList.length; i++) {
                        code += "<tr>";
                        code += `<td>\${data.salaryList[i].salaryPymntDate}월</td>`;
                        code += `<td><a href="#" class="getDetail" data-bslry="\${data.salaryList[i].salaryBslry}"
                                                                   data-allwnc="\${data.salaryList[i].salaryOvtimeAllwnc}"
                                                                   data-emplNm="\${data.salaryList[i].emplNm}"
                                                                   data-month="\${data.salaryList[i].salaryPymntDate}">급여명세서 보기</a></td>`;
                        code += "</tr>";
                    }
                }
                code += "</table>";
                $("#paymentList").html(code);

            },
            error: function (xhr) {
                console.log(xhr.status)
            }
        })
    }

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    $("#paymentList").on("click", ".getDetail", function (event) {
        event.preventDefault();
        const emplNm = $(this).data("emplnm");
        const month = $(this).data("month");
        const bslry = parseInt($(this).data("bslry"));
        const allwnc = parseInt($(this).data("allwnc"));
        const payment = parseInt(bslry) + parseInt(allwnc); // 총 지급액
        let deduction = 0; // 총 공제액
        let taxes = {};
        for (let i = 0; i < tariffList.length; i++) {
            if (i !== tariffList.length - 1) {
                taxes[i] = payment * tariffList[i].taratStdrValue / 100;
            } else {
                taxes[i] = taxes[4] * tariffList[i].taratStdrValue / 100;
            }
            deduction += parseInt(taxes[i]);
        }
        let code = "";
        code += `<p>실 지급액</p>`;
        code += `<p>\${formatNumber(payment-deduction)}</p>`;
        code += `<p>급여 상세</p>`;
        code += `<p>\${month}  \${emplNm}</p><hr>`;
        code += `<p>지급 \${formatNumber(payment)} 원</p>`;
        code += `<p>통상임금 \${formatNumber(bslry)} 원</p>`;
        code += `<p>시간외수당 \${formatNumber(allwnc)} 원</p><hr>`;
        code += `<p>공제 \${formatNumber(deduction)} 원</p>`;

        for (let i in taxes) {
            if (taxes.hasOwnProperty(i)) {
                code += `<p>\${tariffList[i].taratStdrNm} \${formatNumber(taxes[i].toFixed(0))} 원</p>`;
            }
        }
        $("#paymentDetail").html(code);
    });

</script>