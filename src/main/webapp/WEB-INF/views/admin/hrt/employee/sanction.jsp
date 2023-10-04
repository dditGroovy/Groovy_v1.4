<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="/resources/css/admin/adminSanction.css">
<script src="https://code.jquery.com/jquery-3.6.0.slim.min.js"></script>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<div class="content-container">
	<header id="tab-header">
    	<h1><a class="on">수신 문서함</a></h1>
    </header>
	
	<div class="searchDiv">
	    <div class="serviceWrap">
	    	<i class="icon i-search"></i>
	        <input type="text" class="input-free-white" oninput="onQuickFilterChanged()" id="quickFilter" placeholder="검색어를 입력하세요"/>
	    </div>
    </div>

    <div class="cardWrap">
        <div class="card">
            <div id="myGrid" class="ag-theme-alpine"></div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/sanction.js"></script>

<script>

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    const columnDefs = [
        {field: "status", headerName: "번호", width: 70, cellStyle: {textAlign: "center"}},
        {
            field: "elctrnSanctnEtprCode",
            headerName: "결재번호",
            cellRenderer: linkCellRenderer,
            cellStyle: {textAlign: "center"}
        },
        {field: "elctrnSanctnSj", headerName: "결재양식", cellStyle: {textAlign: "center"}},
        {field: "elctrnSanctnFinalDate", headerName: "결재승인일", cellStyle: {textAlign: "center"}},
        {field: "commonCodeDept", headerName: "부서", width: 100, cellStyle: {textAlign: "center"}},
        {field: "elctrnSanctnDrftEmplId", headerName: "사번", cellStyle: {textAlign: "center"}},
        {field: "emplNm", headerName: "이름", cellStyle: {textAlign: "center"}},

    ];
    const rowData = [];
    <c:forEach var="sanctionVO" items="${sanctionList}" varStatus="status">

    rowData.push({
        status: "${status.count}",
        elctrnSanctnEtprCode: "${sanctionVO.elctrnSanctnEtprCode}",
        elctrnSanctnSj: "${sanctionVO.elctrnSanctnSj}",
        elctrnSanctnFinalDate: "${sanctionVO.elctrnSanctnFinalDate}",
        commonCodeDept: "${sanctionVO.commonCodeDept}",
        elctrnSanctnDrftEmplId: "${sanctionVO.elctrnSanctnDrftEmplId}",
        emplNm: "${sanctionVO.emplNm}",

    })
    </c:forEach>
    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData,
        onGridReady: function (event) {
            event.api.sizeColumnsToFit();
        },
        rowHeight: 50,
        pagination: true,
        paginationPageSize: 10,
    };

    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#myGrid');
        new agGrid.Grid(gridDiv, gridOptions);

    });

    function linkCellRenderer(params) {
        const link = document.createElement('a');
        link.href = `/sanction/read/\${params.value}`
        link.className = "openSanction link"
        link.innerText = params.value;
        link.addEventListener('click', (event) => {
            event.preventDefault();
            window.open(link.href, "결재", getWindowSize());

        });
        return link;
    }
</script>