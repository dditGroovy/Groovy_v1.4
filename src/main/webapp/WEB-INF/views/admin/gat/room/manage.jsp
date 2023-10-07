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
<link rel="stylesheet" href="/resources/css/admin/manageRoom.css">
<script
	src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>

<div class="content-container">
	<header id="tab-header">
		<h1>
			<a href="${pageContext.request.contextPath}/reserve/manageRoom"
				class="on">시설 관리</a>
		</h1>
		<h1>
			<a href="${pageContext.request.contextPath}/reserve/loadReservation">예약
				현황</a>
		</h1>
	</header>
	<div class="cardWrap">
		<div class="card card-df grid-card">
			<div class="header">
				<h2 class="font-b font-24">오늘 예약 현황</h2>
				<p class="current-resve">
					<a href="list" class="totalResve font-18 font-md"><span
						id="countValue" class="font-md font-36"></span> 건</a>
				</p>
				<a href="/reserve/loadReservation" class="more font-11 font-md">더보기 <i
					class="icon i-arr-rt" style="fill: red"></i>
				</a>
			</div>
			<div class="content">
				<div id="myGrid" class="ag-theme-alpine"></div>
			</div>
		</div>
		<div class="card card-df facility-card">
			<div class="header">
				<div class="titleWrap" style="display: block">
					<h1 class="manage-header font-b font-24">시설 관리</h1>
					<table>
						<tbody>
							<tr class="facility facility-left">
								<td class="font-md font-18">회의실 | <span
									class="count font-md font-24">${meetingCount}</span> 개
								</td>
							</tr>
							<tr class="facility">
								<td class="font-md font-18">휴게실 | <span
									class="count font-md font-24">${retiringCount}</span> 개
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="content">
				<div class="roomInfo">
					<c:forEach items="${meetingCode}" var="meeting">
						<ul class="fxrpsList card card-df">
							<li class="roomInfoList"><i class="icon-user"></i> <c:if
									test="${meeting.fcltyName == '회의실'}">
									<h4 class="roomId font-sb font-24">${meeting.fcltyCode}</h4>
									<span class="roomType font-reg font-18">${meeting.fcltyName}</span>
									<h4 class="equip font-sb font-18">비품</h4>
									<span class="fxrps font-reg font-14">|&nbsp;&nbsp;${meeting.equipName}</span>
								</c:if></li>
						</ul>
					</c:forEach>
					<c:forEach items="${retiringCode}" var="retiring">
						<ul class="fxrpsList card card-df">
							<li class="roomInfoList"><i class="icon-user"></i> <c:if
									test="${retiring.fcltyName == '휴게실'}">
									<h4 class="roomId font-sb font-24">${retiring.fcltyCode}</h4>
									<span class="roomType font-reg font-18">${retiring.fcltyName}</span>
								</c:if></li>
						</ul>
					</c:forEach>
				</div>
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
            const currentTime = new Date();
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
                                        location.reload();
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
        {field: "fcltyResveSn", headerName: "순번", cellRenderer: returnValue, width: 100,cellStyle: {textAlign: "center"}},
        {
            field: "commonCodeFcltyKindParent", headerName: "시설 종류 구분", getQuickFilterText: (params) => {
                return params.value
            }, width: 150, cellStyle: {textAlign: "center"}
        },
        {field: "commonCodeFcltyKind", headerName: "시설 이름", width: 150, cellStyle: {textAlign: "center"}},
        {field: "fcltyResveBeginTime", headerName: "시작 시간", width: 150, cellStyle: {textAlign: "center"}},
        {field: "fcltyResveEndTime", headerName: "끝 시간", width: 150, cellStyle: {textAlign: "center"}},
        {field: "fcltyResveEmplNmAndId", headerName: "예약 사원(사번)", width: 200, cellStyle: {textAlign: "center"}},
        {field: "fcltyResveRequstMatter", headerName: "요청사항", width: 200, cellStyle: {textAlign: "center"}},
        {field: "chk", headerName: " ", cellRenderer: ClassBtn, width: 150, cellStyle: {textAlign: "center"}},
    ];
    let count=0;
    const rowData = [];
    <c:forEach items="${toDayList}" var="room">
    count++;
    <c:set var="beginTime" value="${room.fcltyResveBeginTime}"/>
    <fmt:formatDate var="fBeginTime" value="${beginTime}" pattern="HH:mm"/>
    <c:set var="endTime" value="${room.fcltyResveEndTime}"/>
    <fmt:formatDate var="fEndTime" value="${endTime}" pattern="HH:mm"/>
    //요청사항이 null이여도 출력되게 바꾸었음
    <c:set var="requestMatter" value="${room.fcltyResveRequstMatter}"/>
    <c:if test="${empty requestMatter}">
    <c:set var="requestMatter" value=""/>
    </c:if>
    
    <c:set var="isoFormattedEndTime">
		<fmt:formatDate value="${room.fcltyResveEndTime}" pattern="yyyy-MM-dd'T'HH:mm:ss"/>
	</c:set>

    rowData.push({
        fcltyResveSn: count,
        commonCodeFcltyKindParent: "${room.fcltyName}",
        commonCodeFcltyKind: "${room.fcltyCode}",
        fcltyResveBeginTime: "${fBeginTime}",
        fcltyResveEndTime: "${fEndTime}",
        fcltyResveEmplNmAndId: "${room.fcltyEmplName}(${room.fcltyResveEmplId})",
        fcltyResveRequstMatter : "${room.fcltyResveRequstMatter}",
        chk:"${room.fcltyResveSn}",
        endTime: new Date("${isoFormattedEndTime}")
    });
	console.log(rowData.pop().endTime);
    </c:forEach>

    // ag-Grid 초기화
    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData,
        onFirstDataRendered: onGridDataRendered, // 그리드 데이터 렌더링 후 이벤트 핸들러
        onGridReady: function (event) {
            event.api.sizeColumnsToFit();
        },
        rowHeight: 50,
    };

    // 페이지 로드 시에 카운트 업데이트를 미리 호출
    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#myGrid');
        new agGrid.Grid(gridDiv, gridOptions);

        // rowData 배열이 비어있을 때 초기 카운트 값 설정
        const countElement = document.getElementById('countValue');
        if (rowData.length === 0) {
            countElement.textContent = "0";
        } else {
            // rowData가 비어있지 않으면 rowCount를 계산하여 설정
            const gridApi = gridOptions.api;
            const rowCount = gridApi.getModel().getRowCount();
            countElement.textContent = rowCount === 0 ? "0" : rowCount;
        }
    });

    // onFirstDataRendered 이벤트 핸들러 내부에서 addEventListener를 호출
    function onGridDataRendered(event) {
        const gridApi = event.api;
        const countElement = document.getElementById('countValue');

        // 이 함수는 rowCount가 0이면 "0"을, 그렇지 않으면 rowCount를 countValue span에 업데이트
        function updateCountValue() {
            const rowCount = gridApi.getModel().getRowCount();
            countElement.textContent = rowCount === 0 ? "0" : rowCount;
        }

        // 그리드 데이터 변경 시에도 카운트 업데이트
        gridApi.addEventListener('rowDataChanged', updateCountValue);
    }
</script>