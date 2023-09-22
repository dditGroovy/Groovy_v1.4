<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<script src="https://code.jquery.com/jquery-3.6.0.slim.min.js"></script>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<div class="content-container">
    <div class="wrap">
    </div>
    <br/>
    <div class="serviceWrap">
        <input type="text" oninput="onQuickFilterChanged()" id="quickFilter" placeholder="검색어를 입력하세요"/>
    </div>
    <br/><br/>
    <div class="sanctionWrap">
        <div class="sanction">
            <div id="myGrid" class="ag-theme-alpine"></div>
        </div>
    </div>
</div>
<script>

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    const columnDefs = [
        {field: "status", headerName: "번호"},
        {
            field: "elctrnSanctnEtprCode",
            headerName: "결재번호",
            cellRenderer: linkCellRenderer
        },
        {field: "elctrnSanctnSj", headerName: "결재양식"},
        {field: "elctrnSanctnFinalDate", headerName: "결재승인일"},
        {field: "commonCodeDept", headerName: "부서"},
        {field: "elctrnSanctnDrftEmplId", headerName: "사번"},
        {field: "emplNm", headerName: "이름"},

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