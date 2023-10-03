<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/attendance.css">

<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<div class="content-container">
    <header id="tab-header">
        <h1><a class="on" href="${pageContext.request.contextPath}/attendance/manage">근태 관리</a></h1>
    </header>
    <nav class="nav">
        <button class="btn btn-fill-wh-sm font-18 font-md" onclick="location.href='${pageContext.request.contextPath}/attendance/manage'">전체</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" id="DEPT010" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT010'">인사</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" id="DEPT011" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT011'">회계</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" id="DEPT012" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT012'">영업</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" id="DEPT013" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT013'">홍보</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" id="DEPT014" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT014'">총무</button>
    </nav>
    <main>
        <div id="myGrid" class="ag-theme-material"></div>
    </main>
</div>
<script>
    const deptDclzList = ${deptDclzList};
    const currentPageUrl = window.location.href;
    const lastPart = currentPageUrl.substring(currentPageUrl.lastIndexOf("/") + 1);
    const currentPageBtn = document.getElementById(lastPart);

    currentPageBtn.classList.remove("btn-fill-wh-sm");
    currentPageBtn.classList.add("btn-fill-bl-sm");

    const getMedalString = function (param) {
        const str = `${param} `;
        return str;
    };
    const MedalRenderer = function (params) {
        return getMedalString(params.value);
    };

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    const columnDefs = [
        {field: "emplNm", headerName: "이름", width: 170, resizable: true},
        {field: "clsfNm", headerName: "직급", width: 120, resizable: true},
        {field: "defaulWorkDate", headerName: "소정근무일수", width: 150, resizable: true},
        {field: "realWikWorkDate", headerName: "실제근무일수", width: 150, resizable: true},
        {field: "defaulWorkTime", headerName: "소정근무시간", width: 170, resizable: true},
        {field: "realWorkTime", headerName: "실제근무시간", width: 170, resizable: true},
        {field: "overWorkTime", headerName: "총 연장 근무시간", width: 170, resizable: true},
        {field: "totalWorkTime", headerName: "총 근무시간", width: 170, resizable: true},
        {field: "avgWorkTime", headerName: "평균 근무시간", width: 170, resizable: true},
    ];

    const rowData = deptDclzList;

    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData
    };

    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#myGrid');
        new agGrid.Grid(gridDiv, gridOptions);
    });

</script>