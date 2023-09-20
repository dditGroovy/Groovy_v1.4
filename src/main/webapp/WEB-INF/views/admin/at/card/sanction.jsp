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
    <div class="cardWrap">
        <div class="card">
            <div id="myGrid" class="ag-theme-alpine"></div>
        </div>
    </div>
</div>
<script>

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    const columnDefs = [
        {
            field: "cprCardResveSn",
            headerName: "예약번호",
            cellRenderer: linkCellRenderer
        },
        {field: "cprCardUsePurps", headerName: "사용 목적"},
        {field: "cprCardUseExpectAmount", headerName: "사용 예상 금액"},
        {field: "cprCardResveBeginDate", headerName: "사용 시작 일자"},
        {field: "cprCardResveClosDate", headerName: "사용 종료 일자"},
        {field: "commonCodeDept", headerName: "부서"},
        {field: "cprCardResveEmplId", headerName: "사번"},
        {field: "emplNm", headerName: "이름"},
        {field: "commonCodeYrycState", headerName: "결재상태"},
        {field: "commonCodeResveAt", headerName: "예약여부"},
        {field: "cprCardResveRturnAt", headerName: "반납여부"},
        // {field: "chk", headerName: " ", cellRenderer: ClassComp},
    ];
    const rowData = [];
    <c:forEach var="sanctionVO" items="${sanctionList}" varStatus="status">
    <fmt:formatNumber type="number" value="${sanctionVO.cprCardUseExpectAmount}" pattern="#,##0" var="formattedAmount" />

    rowData.push({
        cprCardResveSn: "${sanctionVO.cprCardResveSn}",
        cprCardUsePurps: "${sanctionVO.cprCardUsePurps}",
        cprCardUseExpectAmount: "${formattedAmount} 원",
        cprCardResveBeginDate: "${sanctionVO.cprCardResveBeginDate}",
        cprCardResveClosDate: "${sanctionVO.cprCardResveClosDate}",
        commonCodeDept: "${sanctionVO.commonCodeDept}",
        cprCardResveEmplId: "${sanctionVO.cprCardResveEmplId}",
        emplNm: "${sanctionVO.emplNm}",
        commonCodeYrycState: "${sanctionVO.commonCodeYrycState == 'YRYC032' ? '승인' : '미승인'}",
        commonCodeResveAt: "${sanctionVO.commonCodeResveAt =='RESVE010' ? '비예약': '예약'}", // RESVE010: 비예약, RESVE011: 예약
        cprCardResveRturnAt: "${sanctionVO.cprCardResveRturnAt == 0 ? '미반납' : '반납'}", // 0: 반납X / 1: 반납O

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