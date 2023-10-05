<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/manageSalaryDtsmt.css">
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<div class="content-container">
    <h1 class="dtsmtHeader tab-header font-md font-36">
        <a href="${pageContext.request.contextPath}/salary/list" class="on">급여 명세서 관리</a>
    </h1>
    <div class="wrap-container">
        <div class="wrap">
            <div class="searchDiv">
                <div class="serviceWrap">
                    <i class="icon i-search"></i>
                    <input type="text" class="input-free-white" oninput="onQuickFilterChanged()" id="quickFilter"
                           placeholder="검색어를 입력하세요"/>
                </div>
                <div class="btn-wrapper">
                    <button class="btn btn-free-white btn-sm color-font-md font-14 font-md btn-batch" id="makePdfDtsmt">
                        <span>일괄생성</span>
                    </button>
                    <button class="btn btn-free-white btn-sm color-font-md font-14 font-md btn-batch"
                            id="downloadDtsmt">
                        <span>일괄저장</span> <i class="icon i-download-medium btn-icon"></i>
                    </button>
                    <button class="btn btn-free-white btn-sm font-14 font-md color-font-md btn-batch" id="mailDtsmt">
                        <span>일괄전송</span> <i class="icon i-mail-medium btn-icon"></i>
                    </button>
                </div>
            </div>
            <div class="cardWrap">
                <div class="card">
                    <div id="myGrid" class="ag-theme-alpine"></div>
                </div>
            </div>
        </div>
        <div class="showList">
            <div class="selectDiv">
                <div class="select-wrapper">
                    <select name="sortOptions" id="yearSelect"
                            class="stroke selectBox font-md font-14 color-font-md"></select>
                </div>
                <span class="font-14">❗️연도 선택 후 조회할 사원을 다시 선택해주세요</span>
            </div>
            <div id="dtsmtDiv" class="stroke color-font-md font-14 bg-wht border-radius-24"><p class="empty">사원을
                선택하세요</p>
            </div>
        </div>
    </div>
    <div id="modal" class="modal-dim" style="display: none">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm salaryCard"
             style="display: block; width: calc(476 * (100vw / var(--vw)));">
            <div class="modal-top">
                <div class="modal-title">
                    <div id="paymentTitle"></div>
                </div>
            </div>
            <div class="modal-container">
                <div class="paymentDetail"></div>
                <div class="modal-footer btn-wrapper">
                    <button type="reset" class="btn btn-fill-wh-sm close">닫기</button>
                </div>
            </div>
        </div>
    </div>
    <div id="downloadDiv"
         style="position: absolute; top: -9999px; left: -9999px; width: 210mm; height: 297mm; padding: 10mm;"></div>
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
    let pdfCount = 0;
    let mailCount = 0;

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
        let month = date.getMonth() + 2;
        month = month < 10 ? "0" + month : month;
        return date.getFullYear() + "-" + month + "-" + date.getDate();
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
            width: 50
        },
        {field: "emplId", headerName: "사번", cellStyle: {textAlign: "center"}},
        {field: "emplNm", headerName: "이름", cellStyle: {textAlign: "center"}},
        {field: "commonCodeDept", headerName: "팀", cellStyle: {textAlign: "center"}},
        {field: "commonCodeClsf", headerName: "직급", cellStyle: {textAlign: "center"}},
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
        onGridReady: function (event) {
            event.api.sizeColumnsToFit();
        },
        rowHeight: 50,
        pagination: true,
        paginationPageSize: 10,
        onRowClicked: function (event) {
            let emplId = event.data.emplId;
            let year = yearSelect.options[yearSelect.selectedIndex].value;
            let dtsmtDiv = document.querySelector("#dtsmtDiv");
            let childSpan = dtsmtDiv.querySelector("span");
            $.ajax({
                url: `/salary/payment/list/\${emplId}/\${year}`,
                type: "get",
                dataType: 'json',
                success: function (result) {
                    let listCode = "<table id='salaryDtsmtList'>";
                    if (result.length === 0) {
                        listCode += `<tr><td>상세 내역이 없습니다.</td></tr>`;
                    }
                    for (let i = 0; i < result.length; i++) {
                        let year = new Date(result[i].salaryDtsmtIssuDate).getFullYear();
                        let month = `\${result[i].month}`;
                        let day = new Date(result[i].salaryDtsmtIssuDate).getDate();
                        listCode += "<tr>";
                        listCode += `<td class="font-14 font-sb "><span class="color-font-md">\${month - 1}월</span></td>`;
                        listCode += `<td class="font-14 color-font-md font-md">\${year}년 \${month - 0}월 \${day}일 지급</td>`;
                        listCode += `<td align="right"><button class="getDetail btn-modal font-sb color-font-md font-14" data-name="salaryCard">급여명세서 보기</button></td>`;
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

        let title = `<p>\${result.month - 1}월 - \${result.salaryEmplNm}</p>`;
        document.querySelector("#paymentTitle").innerHTML = title;
        let content = `
            <div>
                <p class="font-18 font-reg color-font-md" style="margin-top: var(--vh-8); margin-bottom: calc((4 / var(--vh)) * 100vh); ">실 수령액</p>
                <p class="font-b font-24 strong">\${formattedNetPay}원</p>
            </div>
            <p class="font-sb font-24 color-font-high" style="text-align: center; margin-bottom: var(--vh-24">급여 상세</p>
            <div class="tableDiv">
                <table>
                    <tr class="font-sb font-18 color-font-high">
                        <th>지급</th>
                        <td>\${formattedPymntTotamt}원</td>
                    </tr>
                    <tr>
                        <th class="font-reg font-14 color-font-md">통상임금</th>
                        <td class="font-reg font-14 color-font-md">\${formattedBslry}원</td>
                    </tr>
                    <tr>
                        <th class="font-reg font-14 color-font-md">초과근무수당</th>
                        <td class="font-reg font-14 color-font-md">\${formattedOvtimeAllwnc}원</td>
                    </tr>
                    <tr></tr>
                    <tr class="font-sb font-18 color-font-high">
                        <th>공제</th>
                        <td>\${formattedDdcTotamt}원</td>
                    </tr>
                    <tr>
                        <th>국민연금</th>
                        <td>\${formattedSisNp}원</td>
                    </tr>
                    <tr>
                        <th class="font-reg font-14 color-font-md">건강보험</th>
                        <td class="font-reg font-14 color-font-md">\${formattedSisHi}원</td>
                    </tr>
                    <tr>
                        <th class="font-reg font-14 color-font-md">고용보험</th>
                        <td class="font-reg font-14 color-font-md">\${formattedSisEi}원</td>
                    </tr>
                    <tr>
                        <th class="font-reg font-14 color-font-md">산재보험</th>
                        <td class="font-reg font-14 color-font-md">\${formattedSisWci}원</td>
                    </tr>
                    <tr>
                        <th class="font-reg font-14 color-font-md">소득세</th>
                        <td class="font-reg font-14 color-font-md">\${formattedIncmtax}원</td>
                    </tr>
                    <tr>
                        <th class="font-reg font-14 color-font-md">지방소득세</th>
                        <td class="font-reg font-14 color-font-md">\${formattedLocalityIncmtax}원</td>
                    </tr>
                </table>
            </div>
            `;
        document.querySelector(".paymentDetail").innerHTML = content;
    }

    function downloadButtonClickHandler(r) {
        const fNetPay = formatNumber(r.salaryDtsmtNetPay);
        const fPymntTotamt = formatNumber(r.salaryDtsmtPymntTotamt);
        const fBslry = formatNumber(r.salaryBslry);
        const fOvtimeAllwnc = formatNumber(r.salaryOvtimeAllwnc);
        const fDdcTotamt = formatNumber(r.salaryDtsmtDdcTotamt);
        const fSisNp = formatNumber(r.salaryDtsmtSisNp);
        const fSisHi = formatNumber(r.salaryDtsmtSisHi);
        const fSisEi = formatNumber(r.salaryDtsmtSisEi);
        const fSisWci = formatNumber(r.salaryDtsmtSisWci);
        const fIncmtax = formatNumber(r.salaryDtsmtIncmtax);
        const fLocalityIncmtax = formatNumber(r.salaryDtsmtLocalityIncmtax);
        const fDate = formatDate(r.salaryDtsmtIssuDate);

        let format = `<jsp:include page="specification.jsp"/>`
        let downloadDiv = document.querySelector("#downloadDiv");
        downloadDiv.innerHTML = format;
        html2canvas(downloadDiv, {scale: 2}).then((canvas) => {
            const doc = new jsPDF('p', 'mm', 'a4');
            let imgData = canvas.toDataURL("image/png");
            let imgWidth = 210;
            let imgHeight = (canvas.height * imgWidth) / canvas.width;

            doc.addImage(imgData, "PNG", 0, 0, imgWidth, imgHeight);

            let fileName = `\${r.salaryDtsmtEtprCode}.pdf`;

            let data = {
                etprCode: `\${r.salaryDtsmtEtprCode}`,
                datauri: doc.output('datauristring')
            };
            let dataLength = Object.keys(data).length;

            $.ajax({
                url: "/salary/uploadFile",
                type: 'post',
                data: JSON.stringify(data),
                contentType: 'application/json',
                success: function (result) {
                    if (result === "success") {
                        pdfCount++;
                        if (dataLength === pdfCount) {
                            Swal.fire({
                                text: '급여명세서 생성이 완료되었습니다. 다운로드 및 일괄전송이 가능합니다.',
                                showConfirmButton: false,
                                timer: 1500
                            })
                        }
                    }
                },
                error: function (xhr, status, error) {
                    console.log("code: " + xhr.status);
                    console.log("message: " + xhr.responseText);
                    console.log("error: " + xhr.error);
                }
            });
        });
    }

    document.querySelector("#makePdfDtsmt").addEventListener("click", function () {
        const selectedData = getSelectedRowData();
        selectedData.forEach(function (data) {
            let emplId = data.emplId;
            let nowDate = new Date();
            let nowYear = nowDate.getFullYear();
            let nowMonth = nowDate.getMonth() + 1;
            nowMonth = nowMonth < 10 ? "0" + nowMonth : nowMonth;

            $.ajax({
                url: `/salary/payment/list/\${emplId}/\${year}`,
                type: 'get',
                dataType: 'json',
                success: function (result) {
                    const monthlyData = result.filter(function (item) {
                        let searchDate = new Date(item.salaryDtsmtIssuDate);
                        return searchDate.getFullYear() == nowYear && (searchDate.getMonth() + 1) == nowMonth;
                    });

                    for (let i = 0; i < monthlyData.length; i++) {
                        const selectedResult = monthlyData[i];
                        downloadButtonClickHandler(selectedResult);
                    }
                },
                error: function (xhr, status, error) {
                    console.log("code: " + xhr.status);
                    console.log("message: " + xhr.responseText);
                    console.log("error: " + xhr.error);
                }
            });
        });
    });

    function getSelectedRowData() {
        const selectedNodes = gridOptions.api.getSelectedNodes();
        return selectedNodes.map((node) => node.data);
    }

    document.querySelector("#downloadDtsmt").addEventListener("click", function () {
        let nowDate = new Date();
        let year = nowDate.getFullYear().toString().substring(2);
        let month = nowDate.getMonth() + 1;
        month = month < 10 ? "0" + month : month;
        let date = year + month

        let selectedData = getSelectedRowData();
        let emplIdArray = selectedData.map(item => item.emplId);
        let emplIdJson = encodeURIComponent(JSON.stringify(emplIdArray));
        location.href = `/file/download/salaryZip?date=\${date}&data=\${emplIdJson}`;
    });

    document.querySelector("#mailDtsmt").addEventListener("click", function () {
        let selectedData = getSelectedRowData();
        let emplIdArray = selectedData.map(item => item.emplId);
        let emplIdJson = encodeURIComponent(JSON.stringify(emplIdArray));

        let nowDate = new Date();
        let year = nowDate.getFullYear().toString().substring(2);
        let month = nowDate.getMonth() + 1;
        month = month < 10 ? "0" + month : month;
        let date = year + month

        let data = {
            data: emplIdJson,
            date: date
        }

        $.ajax({
            url: "/salary/email",
            data: data,
            type: 'post',
            success: function (result) {
                if (result === "success") {
                    Swal.fire({
                        text: '메일 전송을 완료했습니다.',
                        showConfirmButton: false,
                        timer: 1500
                    });
                }
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
            }
        });
    })

</script>