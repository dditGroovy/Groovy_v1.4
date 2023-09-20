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

    .wrap {
        padding: calc((50/var(--vh)*100vh)) calc((50/var(--vw)*100vw)) 0 calc((50/var(--vw)*100vw));
    }

    .wrap ul {
        display: flex;
        gap: 10px
    }

    .ag-header-container, .ag-center-cols-container {
        width: 100% !important;
        white-space: nowrap;
        margin: 0px auto;
    }

    .ag-row {
        white-space: nowrap;
        width: 100%;
        margin: 0px auto;
    }

    .serviceWrap {
        padding: calc((50/var(--vh)*100vh)) calc((50/var(--vw)*100vw)) 0 calc((50/var(--vw)*100vw));
    }
</style>
<div class="wrap">
    <ul>
        <li><a href="room" class="tab">시설 관리</a></li>
        <li><a href="room" class="tab">예약 현황</a></li>
    </ul>
</div>

<div class="serviceWrap">
    <input type="text" oninput="onQuickFilterChanged()" id="quickFilter"
        placeholder="검색어를 입력하세요" />
</div>
<br />
<br />
<div class="cardWrap">
    <div class="card">
        <div id="myGrid" class="ag-theme-alpine" style="width:100%;"></div>
    </div>
</div>
<script>
    // ag-grid
    const returnValue = (params) => params.value;

    class ClassBtn {
        init(params) {
            this.eGui = document.createElement('div');
            const currentTime = new Date(); // 현재 날짜 및 시간 가져오기
            const endTime = new Date(params.data.endTime);
            console.log(endTime);

            // 예약 끝 시간과 현재 시간을 비교하여 버튼을 활성화 또는 비활성화
            if (endTime > currentTime) {
                // 예약이 아직 안끝났으므로 버튼을 활성화합니다.
                this.eGui.innerHTML = `
                    <button class="cancelRoom" id="${params.value}">예약 취소</button>
                `;

                // 클릭 이벤트 핸들러를 추가
                this.id = params.value;
                this.btnReturn = this.eGui.querySelector(".cancelRoom");

                this.btnReturn.addEventListener("click", () => {
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
            } else {
                // 예약이 이미 끝났으므로 버튼을 비활성화합니다.
                this.eGui.innerHTML = `
                    <button class="cancelRoom" id="${params.value}" disabled>예약 취소</button>
                `;
            }
        }

        getGui() {
            return this.eGui;
        }

        destroy() { }
    }
    const getString = function (param) {
        const str = param; // "${param}"를 "${param}"으로 수정
        return str;
    };
    const StringRenderer = function (params) {
        return getString(params.value);
    };

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    const columnDefs = [
        { field: "fcltyResveSn", headerName: "예약번호", cellRenderer: returnValue },
        { field: "commonCodeFcltyKindParent", headerName: "시설 종류 구분", getQuickFilterText: (params) => { return params.value } },
        { field: "commonCodeFcltyKind", headerName: "시설 이름" },
        { field: "fcltyResveBeginTime", headerName: "시작 일시" },
        { field: "fcltyResveEndTime", headerName: "끝 일시" },
        { field: "fcltyResveEmplNm", headerName: "예약 사원(사번)" },
        { field: "fcltyResveRequstMatter", headerName: "요청사항" },
        { field: "chk", headerName: " ", cellRenderer: ClassBtn },
    ];
    const rowData = [];

    <c:forEach items="${reservedRooms}" var="room" varStatus="state">
        <c:set var="beginTime" value="${room.fcltyResveBeginTime}" />
        <fmt:formatDate var="fBeginTime" value="${beginTime}" pattern="yyyy-MM-dd HH:mm" />
        <c:set var="endTime" value="${room.fcltyResveEndTime}" />
        <fmt:formatDate var="fEndTime" value="${endTime}" pattern="yyyy-MM-dd HH:mm" />

        <c:set var="isoFormattedEndTime">
            <fmt:formatDate value="${room.fcltyResveEndTime}" pattern="yyyy-MM-dd'T'HH:mm:ss" />
        </c:set>

        rowData.push({
            fcltyResveSn: "${room.fcltyResveSn}", // "${stat.count}"를 "${room.fcltyResveSn}"으로 수정
            commonCodeFcltyKindParent: "${room.fcltyCode}",
            commonCodeFcltyKind: "${room.fcltyName}",
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

        // 페이지에 추가
        document.body.appendChild(countElement);
    }
</script>