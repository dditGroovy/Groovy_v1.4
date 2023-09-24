<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
    ul {
        list-style: none;
        padding-left: 0;
    }

    .wrap ul {
        display: flex;
        gap: 10px
    }

    #myGrid {
        width: 100%;
        height: calc((360 / 1080) * 100vh);
    }
</style>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<div class="content-container">
    <div class="wrap">
    </div>
    <br/>

    <br/><br/>
    <input type="text" oninput="onQuickFilterChanged()" id="quickFilter" placeholder="검색어를 입력하세요"/>
    <button>급여명세서 다운로드</button>
    <button>급여명세서 일괄전송</button>
    <div class="cardWrap">
        <div class="card">
            <div id="myGrid" class="ag-theme-alpine"></div>
        </div>
    </div>
    <div class="serviceWrap">
        <select name="sortOptions" id="yearSelect" class="stroke"></select>
        <div id="dtsmtDiv"><span>사원을 선택하세요</span></div> <!-- 여기에 급여명세서 리스트 뜸 -->
    </div>
    <div id="paymentDetail"> <!-- 월별 급여명세서 확인 -->
    </div>
</div>
<script>
    let year;
    let tariffList;
    let id = document.querySelector("a").getAttribute("data-id");
    let yearSelect = document.querySelector("#yearSelect");

    getAllYear();

    yearSelect.addEventListener("change", function () {
        selectedYear = yearSelect.options[yearSelect.selectedIndex].value;
    });

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

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    const columnDefs = [
        {
            headerCheckboxSelection: true,
            checkboxSelection: true,
            width: 250
        },
        {field: "emplId", headerName: "사번", width: 250},
        {field: "emplNm", headerName: "이름", width: 250},
        {field: "commonCodeDept", headerName: "팀", width: 250},
        {field: "commonCodeClsf", headerName: "직급", width: 250},
    ];

    const rowData = [];
    <c:forEach var="employeeVO" items="${empList}">
    rowData.push({
        emplId: "${employeeVO.emplId}",
        emplNm: "${employeeVO.emplNm}",
        commonCodeDept: "${employeeVO.commonCodeDept}",
        commonCodeClsf: "${employeeVO.commonCodeClsf}",
    })
    </c:forEach>

    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData,
        onRowClicked: function (event) {
            let emplId = event.data.emplId;
            let year = yearSelect.options[yearSelect.selectedIndex].value;
            let dtsmtDiv = document.querySelector("#dtsmtDiv");
            let childSpan = dtsmtDiv.querySelector("span");
            if (childSpan) {
                dtsmtDiv.removeChild(childSpan);
            }
            $.ajax({
                url: `/salary/payment/list/\${emplId}/\${year}`,
                type: "get",
                dataType: 'json',
                success: function (result) {
                    let listCode = "<table border=1 id='salaryDtsmtList'>";
                    if (result.length === 0) {
                        listCode += `<tr><td>상세 내역이 없습니다.</td></tr>`;
                    }
                    for (let i = 0; i < result.length; i++) {
                        listCode += "<tr>";
                        listCode += `<td>\${result[i].month}월</td>`;
                        listCode += `<td><button class="getDetail">급여명세서 보기</button></td>`;
                        listCode += "</tr>";
                    }
                    listCode += `</table>`;
                    dtsmtDiv.innerHTML = listCode;

                    const detailButtons = document.querySelectorAll(".getDetail");
                    detailButtons.forEach(function (button, index) {
                        button.addEventListener("click", function () {
                            const selectedResult = result[index];
                            const formattedNetPay = formatNumber(selectedResult.salaryDtsmtNetPay);
                            const formattedPymntTotamt = formatNumber(selectedResult.salaryDtsmtPymntTotamt);
                            const formattedBslry = formatNumber(selectedResult.salaryBslry);
                            const formattedOvtimeAllwnc = formatNumber(selectedResult.salaryOvtimeAllwnc);
                            const formattedDdcTotamt = formatNumber(selectedResult.salaryDtsmtDdcTotamt);
                            const formattedSisNp = formatNumber(selectedResult.salaryDtsmtSisNp);
                            const formattedSisHi = formatNumber(selectedResult.salaryDtsmtSisHi);
                            const formattedSisEi = formatNumber(selectedResult.salaryDtsmtSisEi);
                            const formattedSisWci = formatNumber(selectedResult.salaryDtsmtSisWci);
                            const formattedIncmtax = formatNumber(selectedResult.salaryDtsmtIncmtax);
                            const formattedLocalityIncmtax = formatNumber(selectedResult.salaryDtsmtLocalityIncmtax);
                            let dtsmtCode = `
                            <p>\${selectedResult.month}월 - \${selectedResult.salaryEmplNm}</p>
                            <p>실 수령액</p>
                            <p>\${formattedNetPay}원</p>
                            <hr>
                            <p>급여 상세</p>
                            <table border="1">
                                <tr>
                                    <th>지급</th>
                                    <td>\${formattedPymntTotamt}원</td>
                                </tr>
                                <tr>
                                    <th>통상임금</th>
                                    <td>\${formattedBslry}원</td>
                                </tr>
                                <tr>
                                    <th>초과근무수당</th>
                                    <td>\${formattedOvtimeAllwnc}원</td>
                                </tr>
                                <tr>
                                    <th>공제</th>
                                    <td>\${formattedDdcTotamt}원</td>
                                </tr>
                                <tr>
                                    <th>국민연금</th>
                                    <td>\${formattedSisNp}원</td>
                                </tr>
                                <tr>
                                    <th>건강보험</th>
                                    <td>\${formattedSisHi}원</td>
                                </tr>
                                <tr>
                                    <th>고용보험</th>
                                    <td>\${formattedSisEi}원</td>
                                </tr>
                                <tr>
                                    <th>산재보험</th>
                                    <td>\${formattedSisWci}원</td>
                                </tr>
                                <tr>
                                    <th>소득세</th>
                                    <td>\${formattedIncmtax}원</td>
                                </tr>
                                <tr>
                                    <th>지방소득세</th>
                                    <td>\${formattedLocalityIncmtax}원</td>
                                </tr>
                            </table>
                            `;
                            document.querySelector("#paymentDetail").innerHTML = dtsmtCode;
                        });
                    });
                },
                error: function (xhr, status, error) {
                    console.log("code: " + xhr.status);
                    console.log("message: " + xhr.responseText);
                    console.log("error: " + xhr.error);
                }
            });
        }
    };

    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#myGrid');
        new agGrid.Grid(gridDiv, gridOptions);
    });

    function linkCellRenderer(params) {
        const link = document.createElement('a');
        link.href = '#';
        link.innerText = params.value;
        link.addEventListener('click', (event) => {
            event.preventDefault();
        });
        return link;
    }
</script>