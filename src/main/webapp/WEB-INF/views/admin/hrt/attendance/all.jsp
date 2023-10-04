<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/attendance.css">

<script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<div class="content-container">
    <header id="tab-header">
            <h1><a class="on" href="${pageContext.request.contextPath}/attendance/manage">근태 관리</a></h1>
    </header>
    <nav class="nav">
        <button class="btn btn-fill-bl-sm font-18 font-md" onclick="location.href='${pageContext.request.contextPath}/attendance/manage'">전체</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT010'">인사</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT011'">회계</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT012'">영업</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT013'">홍보</button>
        <button class="btn btn-fill-wh-sm font-18 font-md" onclick="location.href='${pageContext.request.contextPath}/attendance/manage/DEPT014'">총무</button>
    </nav>
    <main>
        <div class="wrap" id="chartsJsWrap">
            <div class="chart-area">
                <canvas class="chart" id="allDepartment"></canvas>
                <p class="font-14 font-md">부서별 전체 근무시간</p>
            </div>
            <div class="chart-area">
                <canvas class="chart" id="avgDepartment"></canvas>
                <p class="font-14 font-md">부서별 평균 근무시간</p>
            </div>
        </div>
        <div id="myGrid" class="ag-theme-material"></div>
    </main>
</div>
<script>
    const allDepartment = $("#allDepartment");
    const avgDepartment = $("#avgDepartment");
    const deptTotalWorkTime = ${deptTotalWorkTime};
    const deptAvgWorkTime = ${deptAvgWorkTime};
    const allDclzList = ${allDclzList};

    const doughnutChart = new Chart(allDepartment, {
        type: 'doughnut',
        data: {
            labels: ['인사', '회계', '영업', '홍보', '총무'],
            datasets: [{
                label: '부서별 전체 근무시간',
                data: deptTotalWorkTime,
                borderWidth: 1
            }]
        }
    });

    const barChart = new Chart(avgDepartment, {
        type: 'bar',
        data: {
            labels: ['인사', '회계', '영업', '홍보', '총무'],
            datasets: [{
                label: '부서별 평균 근무시간',
                data: deptAvgWorkTime,
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    const getMedalString = function (param) {
        const str = `${param} `;
        return str;
    };

    const MedalRenderer = function (params) {
        return getMedalString(params.value);
    };

    const columnDefs = [
        {field: "emplNm", headerName: "이름", resizable: true, cellStyle: {textAlign: "center"}},
        {field: "deptNm", headerName: "부서", resizable: true, cellStyle: {textAlign: "center"}},
        {field: "clsfNm", headerName: "직급", resizable: true, cellStyle: {textAlign: "center"}},
        {field: "defaulWorkDate", headerName: "소정근무일 수", resizable: true, cellStyle: {textAlign: "center"}},
        {field: "realWikWorkDate", headerName: "실제근무일 수", resizable: true, cellStyle: {textAlign: "center"}},
        {field: "defaulWorkTime", headerName: "소정 근무시간", resizable: true, cellStyle: {textAlign: "center"}},
        {field: "realWorkTime", headerName: "실제 근무시간", resizable: true, cellStyle: {textAlign: "center"}},
        {field: "overWorkTime", headerName: "총 연장 근무시간", resizable: true, cellStyle: {textAlign: "center"}},
        {field: "totalWorkTime", headerName: "총 근무시간", resizable: true, cellStyle: {textAlign: "center"}},
        {field: "avgWorkTime", headerName: "평균 근무시간", resizable: true, cellStyle: {textAlign: "center"}},
    ];

    const rowData = allDclzList;

    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData,
        pagination: true,
        paginationPageSize: 10,
        onGridReady: function (event) {
            event.api.sizeColumnsToFit();
        },
        rowHeight: 50,
    };

    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#myGrid');
        new agGrid.Grid(gridDiv, gridOptions);
    });

</script>