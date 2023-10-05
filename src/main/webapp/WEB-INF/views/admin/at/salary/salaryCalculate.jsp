<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/manageSalaryCalculate.css">
    <script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
    <div class="content-container">
        <h1 class="dtsmtHeader tab-header font-md font-36">
            <a href="${pageContext.request.contextPath}/salary/calculate" class="on">급여 정산</a>
        </h1>
        <div class="wrap">
            <div class="yearMonthDiv">
                <div class="select-wrapper">
                    <select name="sortOptions" id="yearSelect"
                            class="stroke selectBox font-md font-14 color-font-md"></select>
                </div>
                <div class="searchDiv">
                    <div class="serviceWrap">
                        <i class="icon i-search"></i>
                        <input type="text" oninput="onQuickFilterChanged()" class="input-free-white" id="quickFilter"
                               placeholder="검색어를 입력하세요"/>
                    </div>
                </div>
            </div>
            <div id="monthDiv"></div>

        </div>
        <div class="cardWrap">
            <div class="card">
                <div id="myGrid" class="ag-theme-alpine"></div>
            </div>
        </div>

    </div>
</sec:authorize>
<script>
    let selectedYear = null;
    let yearSelect = document.querySelector("#yearSelect");

    getAllYear();

    yearSelect.addEventListener("change", function () {
        selectedYear = yearSelect.options[yearSelect.selectedIndex].value;
        getAllMonth(selectedYear);
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
                selectedYear = result[0];
                getAllMonth(selectedYear);
            },
            error: function (xhr) {
                xhr.status;
            }
        });
    }

    function getAllMonth(year) {
        $.ajax({
            type: 'get',
            url: '/salary/months',
            data: {year: year},
            contentType: "application/json;charset=utf-8",
            dataType: 'json',
            success: function (result) {
                let nowDate = new Date();
                let code = ``;
                for (let i = 1; i <= 12; i++) {
                    if (result.includes(i < 10 ? `0\${i}` : `\${i}` && nowDate.getDate() >= 15) || (i < nowDate.getMonth() + 1 && nowDate.getDate() >= 14)) {
                        code += `<button type="button" class="btn btn-free-white btn-sm font-14 font-md color-font-md btn-batch" onclick="getSalaryByYearAndMonth(\${year}, this)">\${i}월</button>`;
                    } else {
                        code += `<button type="button" class="btn btn-free-white btn-sm font-14 font-md color-font-md btn-batch" disabled>\${i}월</button>`;
                    }
                }
                monthDiv.innerHTML = code;
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        });
    }

    function getSalaryByYearAndMonth(year, monthBtn) {
        let month = parseInt(monthBtn.innerText);
        month = month < 10 ? `0\${month}` : month;
        $.ajax({
            url: '/salary/selectedDate',
            contentType: 'application/json;charset=utf-8',
            type: 'get',
            data: {
                year: year,
                month: month
            },
            dataType: 'json',
            success: function (result) {
                rowData.length = 0;
                for (let i = 0; i < result.length; i++) {
                    rowData.push({
                        emplId: result[i].commuteVO.dclzEmplId,
                        emplNm: result[i].commuteVO.emplNm,
                        defaulWorkTime: result[i].commuteVO.defaulWorkTime,
                        realWorkTime: result[i].commuteVO.realWorkTime,
                        overWorkTime: result[i].commuteVO.overWorkTime,
                        totalWorkTime: result[i].commuteVO.totalWorkTime,
                        salaryBslry: result[i].paystubVO.salaryBslry,
                        salaryOvtimeAllwnc: result[i].paystubVO.salaryOvtimeAllwnc,
                        salaryDtsmtPymntTotamt: result[i].paystubVO.salaryDtsmtPymntTotamt,
                        salaryDtsmtSisNp: result[i].paystubVO.salaryDtsmtSisNp,
                        salaryDtsmtSisHi: result[i].paystubVO.salaryDtsmtSisHi,
                        salaryDtsmtSisEi: result[i].paystubVO.salaryDtsmtSisEi,
                        salaryDtsmtSisWci: result[i].paystubVO.salaryDtsmtSisWci,
                        salaryDtsmtIncmtax: result[i].paystubVO.salaryDtsmtIncmtax,
                        salaryDtsmtLocalityIncmtax: result[i].paystubVO.salaryDtsmtLocalityIncmtax,
                        salaryDtsmtDdcTotamt: result[i].paystubVO.salaryDtsmtDdcTotamt,
                        salaryDtsmtNetPay: result[i].paystubVO.salaryDtsmtNetPay
                    });
                }
                gridOptions.api.setRowData(rowData);
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        })
    }

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    const columnDefs = [
        {
            field: "emplId",
            headerName: "사번",
            cellRenderer: linkCellRenderer
            , cellStyle: {textAlign: "center"}
        },
        {field: "emplNm", headerName: "이름", cellStyle: {textAlign: "center"}},
        {field: "defaulWorkTime", headerName: "소정근무시간", cellStyle: {textAlign: "center"}},
        {field: "realWorkTime", headerName: "근무시간", cellStyle: {textAlign: "center"}},
        {field: "overWorkTime", headerName: "초과근무시간", cellStyle: {textAlign: "center"}},
        {field: "totalWorkTime", headerName: "근무인정시간", cellStyle: {textAlign: "center"}},
        {field: "salaryBslry", headerName: "기본급", cellStyle: {textAlign: "center"}, valueFormatter: formatNumber},
        {
            field: "salaryOvtimeAllwnc",
            headerName: "초과근무수당",
            cellStyle: {textAlign: "center"},
            valueFormatter: formatNumber
        },
        {
            field: "salaryDtsmtPymntTotamt",
            headerName: "지급액계",
            cellStyle: {textAlign: "center"},
            valueFormatter: formatNumber
        },
        {field: "salaryDtsmtSisNp", headerName: "국민연금", cellStyle: {textAlign: "center"}, valueFormatter: formatNumber},
        {field: "salaryDtsmtSisHi", headerName: "건강보험", cellStyle: {textAlign: "center"}, valueFormatter: formatNumber},
        {field: "salaryDtsmtSisEi", headerName: "고용보험", cellStyle: {textAlign: "center"}, valueFormatter: formatNumber},
        {
            field: "salaryDtsmtSisWci",
            headerName: "산재보험",
            cellStyle: {textAlign: "center"},
            valueFormatter: formatNumber
        },
        {
            field: "salaryDtsmtIncmtax",
            headerName: "소득세",
            cellStyle: {textAlign: "center"},
            valueFormatter: formatNumber
        },
        {
            field: "salaryDtsmtLocalityIncmtax",
            headerName: "지방소득세",
            cellStyle: {textAlign: "center"},
            valueFormatter: formatNumber
        },
        {
            field: "salaryDtsmtDdcTotamt",
            headerName: "공제액계",
            cellStyle: {textAlign: "center"},
            valueFormatter: formatNumber
        },
        {
            field: "salaryDtsmtNetPay",
            headerName: "실수령액",
            cellStyle: {textAlign: "center"},
            valueFormatter: formatNumber
        },
    ];

    const rowData = [];
    <c:forEach var="cnp" items="${cnpList}">
    rowData.push({
        emplId: "${cnp.commuteVO.dclzEmplId}",
        emplNm: "${cnp.commuteVO.emplNm}",
        defaulWorkTime: "${cnp.commuteVO.defaulWorkTime}",
        realWorkTime: "${cnp.commuteVO.realWorkTime}",
        overWorkTime: "${cnp.commuteVO.overWorkTime}",
        totalWorkTime: "${cnp.commuteVO.totalWorkTime}",
        salaryBslry: "${cnp.paystubVO.salaryBslry}",
        salaryOvtimeAllwnc: "${cnp.paystubVO.salaryOvtimeAllwnc}",
        salaryDtsmtPymntTotamt: "${cnp.paystubVO.salaryDtsmtPymntTotamt}",
        salaryDtsmtSisNp: "${cnp.paystubVO.salaryDtsmtSisNp}",
        salaryDtsmtSisHi: "${cnp.paystubVO.salaryDtsmtSisHi}",
        salaryDtsmtSisEi: "${cnp.paystubVO.salaryDtsmtSisEi}",
        salaryDtsmtSisWci: "${cnp.paystubVO.salaryDtsmtSisWci}",
        salaryDtsmtIncmtax: "${cnp.paystubVO.salaryDtsmtIncmtax}",
        salaryDtsmtLocalityIncmtax: "${cnp.paystubVO.salaryDtsmtLocalityIncmtax}",
        salaryDtsmtDdcTotamt: "${cnp.paystubVO.salaryDtsmtDdcTotamt}",
        salaryDtsmtNetPay: "${cnp.paystubVO.salaryDtsmtNetPay}"
    })
    </c:forEach>

    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData,
        pagination: true,
        paginationPageSize: 10,
        rowHeight: 50,
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

    function formatNumber(num) {
        num = parseInt(num.value);
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

</script>
