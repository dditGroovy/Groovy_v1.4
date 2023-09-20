<%--
  Created by IntelliJ IDEA.
  User: Ha-Neul Yun
  Date: 2023-09-08
  Time: 오후 2:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="stylesheet"
	href="https://unpkg.com/ag-grid-community/styles/ag-grid.css">
<link rel="stylesheet"
	href="https://unpkg.com/ag-grid-community/styles/ag-theme-alpine.css">

<script
	src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
<style>
ul {
	list-style: none;
	padding-left: 0;
}

.wrap ul {
	display: flex;
	gap: 10px
}

.header, .titleWrap {
	display: flex;
	align-items: center;
	gap: 10px;
}

table tr {
	display: flex;
}

table tr td, table tr th {
	flex: 1;
}

.roomInfoList, .fxrpsList {
	display: flex;
	align-items: center;
	gap: 24px;
}

.content>ul {
	display: flex;
	flex-direction: column;
}

.content {
    display: flex;
    flex-direction: column;
    gap: var(--vh-64);
    padding: calc((10/var(--vh)*100vh)) calc((50/var(--vw)*100vw)) 0 calc((50/var(--vw)*100vw));
}

.roomInfo {
	display: grid;
	grid-template-rows: repeat(2, 1fr);
	grid-template-columns: repeat(2, 1fr)
}

#fcltyResveSn, .fcltyResveSn {
	display: none;
}

.fxrpsList {
	border: 3px solid black;
	border-radius: 30px;
	margin: 10px;
}

.roomInfoList {
	margin-left: 50px;
}

.roomInfoList, .fxrpsList {
	display: inline-flex;
	text-align: center;
	gap: 30px;
}

.roomId, .roomType, .equip {
	display: flex;
	width: 100px;
	height: 150px;
	align-items: center;
}

.fxrps {
	display: flex;
	width: 300px;
	height: 150px;
	align-items: center;
}

.wrap{
	padding: calc((50/var(--vh)*100vh)) calc((50/var(--vw)*100vw)) 0 calc((50/var(--vw)*100vw));
}

.header{
padding: calc((10/var(--vh)*100vh)) calc((50/var(--vw)*100vw)) 0 calc((50/var(--vw)*100vw));
}

.header, .titleWrap {
    display: flex;
    align-items: center;
    gap: 10px;
}

.titleWrap h1{
	font-weight: bold;
	margin-left: 45px;
}

.facility{
	display: inline-flex;
    width: 150px;
    height: 50px;
    align-items: center;
    text-align: center;
    margin: 10px;
}
</style>
<div class="wrap">
	<ul>
		<li><a href="/run/manage" class="tab">시설 관리</a></li>
		<li><a href="/run/manage" class="tab">예약 현황</a></li>
	</ul>
</div>
<br />
<br />
<div class="cardWrap">
	<div class="card">
		<div class="header">
			<h2>오늘 예약 현황</h2>
			<p>
				<a href="list" class="totalResve"><span id="countValue"></span>건</a>
			</p>
			<a href="list">더보기</a>
		</div>
		<br />
		<div class="content">
			<div id="myGrid" style="height: 500px;" class="ag-theme-alpine"></div>
		</div>
	</div>	
	<br />
	<div class="card">
		<div class="header">
			<div class="titleWrap" style="display: block">
				<h1>시설 관리</h1>
				<table>
					<tbody>
						<tr class="facility">
							<td>회의실 | ${meetingCount}개</td>
						</tr>
						<tr class="facility">
							<td>휴게실 | ${retiringCount}개</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="content">
			<div class="roomInfo">
				<c:forEach items="${meetingCode}" var="meeting">
					<ul class="fxrpsList">
						<li class="roomInfoList">
							<c:if test="${meeting.fcltyName == '회의실'}">
								<h4 class="roomId">${meeting.fcltyCode}</h4>
								<span class="roomType">${meeting.fcltyName}</span>
								<h5 class="equip">비품</h5>
								<li class="fxrps">${meeting.equipName}</li>
							</c:if>
						</li>
					</ul>
				</c:forEach>
				<c:forEach items="${retiringCode}" var="retiring">
					<ul class="fxrpsList">
						<li class="roomInfoList">
							<c:if test="${retiring.fcltyName == '휴게실'}">
								<h4 class="roomId">${retiring.fcltyCode}</h4>
								<span class="roomType">${retiring.fcltyName}</span>
								<h5 class="equip">비품</h5>
							</c:if>
						</li>
					</ul>
				</c:forEach>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
//ag-grid
const returnValue = (params) => params.value;

class ClassBtn {
    init(params) {
        this.eGui = document.createElement('div');
        this.eGui.innerHTML = `
            <button class="cancelRoom" id="${params.value}">예약 취소</button>
        `;
        this.id = params.value;
        this.btnReturn = this.eGui.querySelector(".cancelRoom");

        // 클릭 이벤트 핸들러를 정의하고 삭제 버튼에 추가
        this.btnReturn.addEventListener("click", () => {
            console.log("취소가 되니?");
            if (confirm("정말 취소하시겠습니까?")) {
                const fcltyResveSn = this.id; // params.value 대신 this.id를 사용
                console.log(fcltyResveSn);

                // 값이 비어있으면 요청을 보내지 않도록 확인
                if (fcltyResveSn) {
                    const xhr = new XMLHttpRequest();
                    xhr.open("get", "/reservation/deleteReserved?fcltyResveSn=" + fcltyResveSn, true);
                    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                    xhr.onload = function () {
                        if (xhr.status === 200) {
                            console.log("삭제가 완료되었습니다. 상태 코드: " + xhr.responseText);
                            location.reload(); // 페이지 리로드
                        } else {
                            console.log("삭제 요청이 실패했습니다. 상태 코드: " + xhr.status);
                        }
                    };

                    xhr.onerror = function () {
                        console.error("네트워크 오류로 인해 삭제 요청이 실패했습니다.");
                    };

                    xhr.send();
                }
            }
        });
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
    {field: "fcltyResveSn", headerName: "예약번호", cellRenderer: returnValue},
    {field: "commonCodeFcltyKindParent", headerName: "시설 종류 구분",getQuickFilterText: (params) => {return params.value}},
    {field: "commonCodeFcltyKind", headerName: "시설 이름"},
    {field: "fcltyResveBeginTime", headerName: "시작 시간"},
    {field: "fcltyResveEndTime", headerName: "끝 시간"},
    {field: "fcltyResveEmplNm", headerName: "예약 사원"},
    {field: "fcltyResveEmplId", headerName: "사번"},
    {field: "fcltyResveRequstMatter", headerName: "요청사항"},
    {field: "chk", headerName: " ", cellRenderer: ClassBtn},
];
const rowData = [];
    <c:forEach items="${toDayList}" var="room">
    <c:set var="beginTime" value="${room.fcltyResveBeginTime}"/>
    <fmt:formatDate var="fBeginTime" value="${beginTime}" pattern="HH:mm"/>
    <c:set var="endTime" value="${room.fcltyResveEndTime}"/>
    <fmt:formatDate var="fEndTime" value="${endTime}" pattern="HH:mm"/>
    <c:if test="${not empty room.fcltyResveRequstMatter || fcltyResveRequstMatter.indexOf('n')==-1}">
     rowData.push({
        fcltyResveSn: "${room.fcltyResveSn}",
        commonCodeFcltyKindParent: "${room.fcltyCode}",
        commonCodeFcltyKind: "${room.fcltyName}",
        fcltyResveBeginTime: "${fBeginTime}",
        fcltyResveEndTime: "${fEndTime}",
        fcltyResveEmplNm: "${room.fcltyEmplName}",
        fcltyResveEmplId: "${room.fcltyResveEmplId}",
        fcltyResveRequstMatter : "${room.fcltyResveRequstMatter}",
        chk:"${room.fcltyResveSn}"
    })
    </c:if>
    </c:forEach>
    
 // ag-Grid 초기화
    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData,
        onFirstDataRendered: onGridDataRendered, // 그리드 데이터 렌더링 후 이벤트 핸들러
    };

    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#myGrid');
        new agGrid.Grid(gridDiv, gridOptions);
    });

    // 그리드 데이터 렌더링 후 실행되는 이벤트 핸들러
    function onGridDataRendered(event) {
        const gridApi = event.api;
        const countElement = document.getElementById('countValue');
        
        // 그리드에서 현재 행의 개수 가져오기
        const rowCount = gridApi.getModel().getRowCount();
        
        // 개수 업데이트
        countElement.textContent = rowCount;
    }
</script>