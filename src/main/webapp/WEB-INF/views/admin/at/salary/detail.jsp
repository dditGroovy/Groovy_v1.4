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
    <button id="makePdfDtsmt" title="올해 이번달의 명세서를 생성할 수 있습니다.">급여명세서 일괄생성</button>
    <button id="downloadDtsmt" title="올해 이번달의 명세서를 다운로드할 수 있습니다.">급여명세서 일괄저장</button>
    <button id="mailDtsmt" title="올해 이번달의 명세서를 메일로 전송할 수 있습니다.">급여명세서 일괄전송</button>
    <div class="cardWrap">
        <div class="card">
            <div id="myGrid" class="ag-theme-alpine"></div>
        </div>
    </div>
    <div class="serviceWrap">
        <select name="sortOptions" id="yearSelect" class="stroke"></select> ❗️연도 선택 후 조회할 사원을 다시 선택해주세요
        <div id="dtsmtDiv"><span>사원을 선택하세요</span></div>
    </div>
    <div id="modal" class="modal-dim" style="display: none">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm salaryCard" style="display: block">
            <div class="modal-top">
                <div class="modal-title">
                    <div id="paymentTitle"></div>
                </div>
            </div>
            <div class="modal-container">
                <div id="paymentDetail"></div>
                <div class="modal-footer btn-wrapper">
                    <button type="reset" class="btn btn-fill-wh-sm close">닫기</button>
                </div>
            </div>
        </div>
    </div>
    <div id="downloadDiv" style="visibility: hidden;">

    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/modal.js"></script>
<script>
    window.jsPDF = window.jspdf.jsPDF;
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

    function formatDate(millisecond) {
        let date = new Date(millisecond);
        let month = date.getMonth() < 10 ? "0" + date.getMonth() : date.getMonth();

        return date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate();
    }

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    const columnDefs = [
        {
            headerCheckboxSelection: true,
            checkboxSelection: true,
        },
        {field: "emplId", headerName: "사번"},
        {field: "emplNm", headerName: "이름"},
        {field: "commonCodeDept", headerName: "팀"},
        {field: "commonCodeClsf", headerName: "직급"},
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
        rowSelection: 'multiple',
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
                        listCode += `<td><button class="getDetail btn-modal" data-name="salaryCard">급여명세서 보기</button></td>`;
                        listCode += `<td><button class="download">다운로드</button></td>`;
                        listCode += "</tr>";
                    }
                    listCode += `</table>`;
                    dtsmtDiv.innerHTML = listCode;

                    const downloadButton = document.querySelectorAll(".download");
                    downloadButton.forEach(function (button, index) {
                        button.addEventListener("click", function () {
                            const selectedResult = result[index];
                            downloadButtonClickHandler(selectedResult);
                        });
                    });

                    const detailButtons = document.querySelectorAll(".getDetail");
                    detailButtons.forEach(function (button, index) {
                        button.addEventListener("click", function () {
                            document.querySelector("#modal").style.display = "block";
                            const selectedResult = result[index];
                            getDetailClickHandler(selectedResult);
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

    function getDetailClickHandler(result) {
        console.log(result);
        const formattedNetPay = formatNumber(result.salaryDtsmtNetPay);
        const formattedPymntTotamt = formatNumber(result.salaryDtsmtPymntTotamt);
        const formattedBslry = formatNumber(result.salaryBslry);
        const formattedOvtimeAllwnc = formatNumber(result.salaryOvtimeAllwnc);
        const formattedDdcTotamt = formatNumber(result.salaryDtsmtDdcTotamt);
        const formattedSisNp = formatNumber(result.salaryDtsmtSisNp);
        const formattedSisHi = formatNumber(result.salaryDtsmtSisHi);
        const formattedSisEi = formatNumber(result.salaryDtsmtSisEi);
        const formattedSisWci = formatNumber(result.salaryDtsmtSisWci);
        const formattedIncmtax = formatNumber(result.salaryDtsmtIncmtax);
        const formattedLocalityIncmtax = formatNumber(result.salaryDtsmtLocalityIncmtax);

        let title = `<p>\${result.month}월 - \${result.salaryEmplNm}</p>`;
        document.querySelector("#paymentTitle").innerHTML = title;
        let content = `
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
        document.querySelector("#paymentDetail").innerHTML = content;
    }

    function downloadButtonClickHandler(result) {
        console.log(result);
        const formattedNetPay = formatNumber(result.salaryDtsmtNetPay);
        const formattedPymntTotamt = formatNumber(result.salaryDtsmtPymntTotamt);
        const formattedBslry = formatNumber(result.salaryBslry);
        const formattedOvtimeAllwnc = formatNumber(result.salaryOvtimeAllwnc);
        const formattedDdcTotamt = formatNumber(result.salaryDtsmtDdcTotamt);
        const formattedSisNp = formatNumber(result.salaryDtsmtSisNp);
        const formattedSisHi = formatNumber(result.salaryDtsmtSisHi);
        const formattedSisEi = formatNumber(result.salaryDtsmtSisEi);
        const formattedSisWci = formatNumber(result.salaryDtsmtSisWci);
        const formattedIncmtax = formatNumber(result.salaryDtsmtIncmtax);
        const formattedLocalityIncmtax = formatNumber(result.salaryDtsmtLocalityIncmtax);
        const formattedDate = formatDate(result.salaryDtsmtIssuDate);
        str = `<jsp:include page="specification.jsp"/>`
        let element = document.querySelector("#downloadDiv");
        element.innerHTML = str;
        html2canvas(element).then((canvas) => {
            let imgData = canvas.toDataURL('image/png');
            let imgWidth = 150;
            let pageHeight = 300;
            let imgHeight = parseInt(canvas.height * imgWidth / canvas.width)
            let heightLeft = imgHeight;
            let margin = 10;

            let doc = new jsPDF('p', 'mm', 'a4');

            let position = 30;

            doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;
            while (heightLeft >= 0) {
                position = heightLeft - imgHeight;
                doc.addPage();
                doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }

            let fileName = `\${result.salaryDtsmtEtprCode}.pdf`;
            doc.save(fileName);
        });
    }

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    document.querySelector("#makePdfDtsmt").addEventListener("click", function () {
        const selectedData = getSelectedRowData();
        console.log(selectedData);
    });

    function getSelectedRowData() {
        const selectedNodes = gridOptions.api.getSelectedNodes();
        return selectedNodes.map((node) => node.data);
    }
</script>