<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    #dclzNav > ul {
        display: flex;
        gap: 48px;
    }

    #myGrid {
        width: 100%;
        height: calc((360 / 1080) * 100vh);
    }
</style>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<div class="content-container">
    <header>
        <ul>
            <li><a href="${pageContext.request.contextPath}/attendance/manageDclz">근태 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/employee/loadLog">로그 관리</a></li>
        </ul>
        <nav id="dclzNav">
            <ul>
                <li><a href="${pageContext.request.contextPath}/attendance/manageDclz">전체</a></li>
                <li><a href="${pageContext.request.contextPath}/attendance/manageDclz/DEPT010">인사</a></li>
                <li><a href="${pageContext.request.contextPath}/attendance/manageDclz/DEPT011">회계</a></li>
                <li><a href="${pageContext.request.contextPath}/attendance/manageDclz/DEPT012">영업</a></li>
                <li><a href="${pageContext.request.contextPath}/attendance/manageDclz/DEPT013">홍보</a></li>
                <li><a href="${pageContext.request.contextPath}/attendance/manageDclz/DEPT014">총무</a></li>
            </ul>
        </nav>
    </header>
    <br/><br/><br/>
    <main>
        <input type="text" oninput="onQuickFilterChanged()" id="quickFilter" placeholder="검색어를 입력하세요"/>
        <div id="myGrid" class="ag-theme-alpine"></div>
    </main>
</div>
<script>
    const deptDclzList = ${deptDclzList};

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
        {
            field: "emplId", headerName: "사원번호", getQuickFilterText: (params) => {
                return getMedalString(params.value);
            }
        },
        {field: "emplNm", headerName: "이름"},
        {field: "clsfNm", headerName: "직급"},
        {field: "defaulWorkDate", headerName: "소정근무일수"},
        {field: "realWikWorkDate", headerName: "실제근무일수"},
        {field: "defaulWorkTime", headerName: "소정근무시간"},
        {field: "realWorkTime", headerName: "실제근무시간"},
        {field: "overWorkTime", headerName: "총 연장 근무시간"},
        {field: "totalWorkTime", headerName: "총 근무시간"},
        {field: "avgWorkTime", headerName: "평균 근무시간"},
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