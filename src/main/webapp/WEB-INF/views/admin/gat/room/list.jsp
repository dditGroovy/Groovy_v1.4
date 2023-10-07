<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-grid.css">
<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-theme-alpine.css">
<link rel="stylesheet" href="/resources/css/admin/manageRoomList.css">
<script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
<div class="content-container">
	<header id="tab-header">
		<h1><a href="${pageContext.request.contextPath}/reserve/manageRoom">시설 관리</a></h1>
		<h1><a href="${pageContext.request.contextPath}/reserve/loadReservationt" class="on">예약 현황</a></h1>
	</header>
	<div class="filterWrap">
		<div class="select-wrapper">
			<select name="" class="stroke selectBox">
				<option value="">전체</option>
				<option value="휴게실">휴게실</option>
				<option value="회의실">회의실</option>
			</select>
		</div>
		<div id="search" class="input-free-white">
            <i class="icon i-search"></i>
			<input type="text" id="quickFilter" placeholder="검색어를 입력하세요." oninput="onQuickFilterChanged()"/>
		</div>
	</div>
	<div class="cardWrap">
		<div class="card grid-card">
				<div id="myGrid" class="ag-theme-alpine" style="width:100%;"></div>
		</div>
	</div>
</div>
<script>
//ag-grid
const returnValue = (params) => params.value;

class ClassBtn {
    init(params) {
        this.eGui = document.createElement('div');
        const currentTime = new Date(); // 현재 날짜 및 시간 가져오기
        const endTime = new Date(params.data.endTime);

        // 예약 끝 시간과 현재 시간을 비교하여 버튼을 활성화 또는 비활성화
        if (endTime > currentTime) {
            // 예약이 아직 안끝났으므로 버튼을 활성화합니다.
            this.eGui.innerHTML = `
                <button class="cancelRoom" id="${params.value}">예약 취소</button>
            `;
       
            // 클릭 이벤트 핸들러를 추가
            this.btnReturn = this.eGui.querySelector('.cancelRoom');

         	// 클릭 이벤트 핸들러를 정의하고 삭제 버튼에 추가
            this.btnReturn.addEventListener("click", () => {
                Swal.fire({
                    text: "정말로 예약을 취소하시겠습니까?",
                    showCancelButton: true,
                    confirmButtonColor: '#5796F3FF',
                    cancelButtonColor: '#e1e1e1',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                        const fcltyResveSn = params.value; 

                        // 값이 비어있으면 요청을 보내지 않도록 확인
                        if (fcltyResveSn) {
                            const xhr = new XMLHttpRequest();
							xhr.open("get", "/reserve/deleteReservation?fcltyResveSn=" + fcltyResveSn, true);
                            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                            xhr.onload = function () {
                                if (xhr.status === 200) {
                                    location.reload(); // 페이지 리로드
                                }
                            };

                            xhr.onerror = function () {
                                console.error("오류로 인해 삭제 요청이 실패했습니다.");
                            };

                            xhr.send();
                        }
                    }
                });
            });
        }
    }

    getGui() {
        return this.eGui;
    }

    destroy() {}
}
const getString = function (param) {
    const str = "${param}";
    return str;
};
const StringRenderer = function (params) {
    return getString(params.value);
};

function onQuickFilterChanged() {
    gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
}



const columnDefs = [
    {field: "fcltyResveSn", headerName: "예약번호", cellRenderer: returnValue, width: 100, cellStyle: {textAlign: "center"}},
    {field: "commonCodeFcltyKindParent", headerName: "시설 종류 구분",width: 150, getQuickFilterText: (params) => {return params.value}, cellStyle: {textAlign: "center"}},
    {field: "commonCodeFcltyKind", headerName: "시설 이름",width: 150, cellStyle: {textAlign: "center"}},
    {field: "fcltyResveBeginTime", headerName: "시작 일자",width: 200,  cellStyle: {textAlign: "center"}},
    {field: "fcltyResveEndTime", headerName: "끝 일자", width: 200, cellStyle: {textAlign: "center"}},
    {field: "fcltyResveEmplNm", headerName: "예약 사원(사번)",width: 200,  cellStyle: {textAlign: "center"}},
    {field: "fcltyResveRequstMatter", headerName: "요청사항", width: 200, cellStyle: {textAlign: "center"}},
    {field: "chk", headerName: " ", cellRenderer: ClassBtn,width: 150,  cellStyle: {textAlign: "center"}},
];
const rowData = [];
let count = 0;
<c:forEach items="${reservedRooms}" var="room">
    <c:set var="beginTime" value="${room.fcltyResveBeginTime}"/>
    <fmt:formatDate var="fBeginTime" value="${beginTime}" pattern="yyyy-MM-dd HH:mm"/>
    <c:set var="endTime" value="${room.fcltyResveEndTime}"/>
    <fmt:formatDate var="fEndTime" value="${endTime}" pattern="yyyy-MM-dd HH:mm"/>

    <c:set var="isoFormattedEndTime">
		<fmt:formatDate value="${room.fcltyResveEndTime}" pattern="yyyy-MM-dd'T'HH:mm:ss"/>
	</c:set>
    	count++;

    rowData.push({
        fcltyResveSn: count,
        commonCodeFcltyKindParent: "${room.fcltyName}",
        commonCodeFcltyKind: "${room.fcltyCode}",
        fcltyResveBeginTime: "${fBeginTime}",
        fcltyResveEndTime: "${fEndTime}",
        fcltyResveEmplNm: "${room.fcltyEmplName}(${room.fcltyResveEmplId})",
        fcltyResveRequstMatter: "${room.fcltyResveRequstMatter}",
        chk: "${room.fcltyResveSn}",
        endTime: new Date("${isoFormattedEndTime}")
    });


</c:forEach>

 // ag-Grid 초기화
    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData,
        onFirstDataRendered: onGridDataRendered, // 그리드 데이터 렌더링 후 이벤트 핸들러
		pagination: true,
		paginationPageSize: 10,
		rowHeight: 50,
		onGridReady: function (event) {
			event.api.sizeColumnsToFit();
		},
    };


    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#myGrid');
        new agGrid.Grid(gridDiv, gridOptions);
    });

 // 그리드 데이터 렌더링 후 실행되는 이벤트 핸들러
    function onGridDataRendered(event) {
        const gridApi = event.api;

        // 새로운 요소를 생성하고 'countValue' ID 할당
        const countElement = document.createElement('div');
        countElement.id = 'countValue';

        // 그리드에서 현재 행의 개수 가져오기
        const rowCount = gridApi.getModel().getRowCount();

        // 개수 업데이트
        countElement.textContent = rowCount;
    }
</script>