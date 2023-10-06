<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet"
      href="https://unpkg.com/ag-grid-community/styles/ag-theme-alpine.css">
<link rel="stylesheet" href="/resources/css/common.css">
<script defer
        src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<link rel="stylesheet" href="/resources/css/job/jobRequestList.css">
<div class="content-container">
    <header id="tab-header">
        <h1>
            <a href="${pageContext.request.contextPath}/job/main" class="on">할
                일</a>
        </h1>
        <h1>
            <a href="${pageContext.request.contextPath}/job/jobDiary">업무 일지</a>
        </h1>
    </header>
    <div id="title">
        <h1>요청한 업무 내역</h1>
    </div>
    <div class="select-wrapper">
        <select id="yearSelect">
            <option>년도 선택</option>
        </select>
    </div>
    <div class="select-wrapper">
        <select id="monthSelect">
            <option>월 선택</option>
        </select>
    </div>
    <button type="button" id="searchBtn">검색</button>
    <div id="request-job" class="ag-theme-alpine"></div>

    <!-- 모달 시작 -->
    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div id="modal-requestDetail-job"
             class="modal-layer card-df sm receiveJobDetail">
            <div class="modal-top modal-header">
                <div class="modal-title">
                    <i class="icon i-idea i-3d"></i>업무 요청하기(상세)
                </div>
                <button type="button" class="modal-close btn close close">
                    &times;
                </button>
            </div>
            <div class="modal-container modal-body ">
                <form id="requestJob" method="post">
                    <ul class="modal-list">
                        <li class="form-data-list"><label class="modal-title">📚 업무 제목</label>
                            <div class="data-box">
                                <p class="data-sj"></p>
                            </div>
                        </li>
                        <li class="form-data-list"><label class="modal-title">✅ 업무 내용</label>
                            <div class="data-box">
                                <p class="data-cn"></p>
                            </div>
                        </li>
                        <li class="form-data-list"><label class="modal-title">📅
                            업무 기간</label>
                            <div class="date">
                                <div class="data-box">
                                    <p class="data-begin"></p>
                                </div>
                                <div class="data-box">
                                    <p class="data-close"></p>
                                </div>
                            </div>
                        </li>
                        <li class="form-data-list"><label class="modal-title">💭
                            업무 분류</label>
                            <div class="input-data">
                                <input type="radio" value="DUTY010" class="data-kind" disabled/>
                                <label>회의</label> <input type="radio" value="DUTY011"
                                                         class="data-kind" disabled/> <label>팀</label> <input
                                    type="radio" value="DUTY012" class="data-kind" disabled/> <label>개인</label>
                                <input type="radio" value="DUTY013" class="data-kind" disabled/>
                                <label>교육</label> <input type="radio" value="DUTY014"
                                                         class="data-kind" disabled/> <label>기타</label>
                            </div>
                        </li>
                        <li class="form-data-list">
                            <div class="receive-org-wrap">
                                <h5>💌 받는 사람</h5>
                                <ul class="state-list">
                                    <li class="stand"></li>
                                    <li>대기</li>
                                    <li class="approval"></li>
                                    <li>승인</li>
                                    <li class="refuse"></li>
                                    <li>거절</li>
                                </ul>
                            </div>
                            <div class="data-box" id="receiveBox"></div>
                            <div id="pagination" class="pagination-wrapper"></div>
                        </li>
                    </ul>
                </form>
            </div>
            <div class="modal-footer">
                <div class="btn-wrap">
                    <button class="btn btn-fill-bl-sm check close">확인</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="/resources/js/modal.js"></script>
<script>
    let yearBtn = document.querySelector("#yearSelect");

    //년도 불러오기
    $.ajax({
        type: 'get',
        url: '/job/getRequestYear',
        success: function (years) {
            years.forEach(year => {
                const newOption = document.createElement('option');
                newOption.text = year;
                newOption.value = year;
                yearBtn.appendChild(newOption);
            });
        },
        error: function (xhr) {
            console.log(xhr.status);
        }
    });

    //해당연도 월 불러오기
    function getMonthByYear(year) {
        $.ajax({
            type: 'get',
            url: `/job/getRequestMonth?year=\${year}`,
            success: function (months) {
                months.forEach(month => {
                    const newOption = document.createElement('option');
                    newOption.text = month;
                    newOption.value = month;
                    newOption.className = "monthBtn";
                    document.querySelector("#monthSelect").appendChild(newOption);
                });
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        });
    }

    yearBtn.addEventListener("change", () => {
        selectedYearValue = yearBtn.value;
        getMonthByYear(selectedYearValue);
        const monthBtns = document.querySelectorAll(".monthBtn");
        monthBtns.forEach((btn) => {
            btn.remove();
        });
    });

    class ClassJobBtn {
        init(params) {
            const jobNo = params.data.jobNo;
            this.eGui = document.createElement('div');
            this.eGui.innerHTML = `
               <button type="button" class="detail" data-name="newRequestJob">상세</button>
           `;
            this.detailBtn = this.eGui.querySelector(".detail[data-name='newRequestJob']");
            this.detailBtn.onclick = () => {
                // 모달 열기 함수 호출
                modalOpen("receiveJobDetail");
                $.ajax({
                    type: 'get',
                    url: '/job/getJobByNo?jobNo=' + jobNo,
                    success: function (jobVO) {
                        document.querySelector(".data-sj").innerText = jobVO.jobSj;
                        document.querySelector(".data-cn").innerText = jobVO.jobCn;
                        document.querySelector(".data-begin").innerText = jobVO.jobBeginDate;
                        document.querySelector(".data-close").innerText = jobVO.jobClosDate;
                        let kind = jobVO.commonCodeDutyKind;
                        let checkboxes = document.querySelectorAll(".data-kind");

                        checkboxes.forEach(checkbox => {
                            if (checkbox.value === kind) {
                                checkbox.checked = true;
                            }
                        });
                        let jobProgressVOList = jobVO.jobProgressVOList;
                        let code = ``;
                        jobProgressVOList.forEach((jobProgressVO) => {
                            code += `<span class="\${jobProgressVO.commonCodeDutySttus}">
                                        <span class="names">\${jobProgressVO.jobRecptnEmplNm}</span>
                                        \${jobProgressVO.commonCodeDutySttus === '승인' ? ` <span> | \${jobProgressVO.commonCodeDutyProgrs}
                                    </span>` : ''}
                                    </span>`;
                        });
                        document.querySelector("#receiveBox").innerHTML = code;
                    },
                    error: function (xhr) {
                        console.log(xhr.status);
                    }
                })
            };
        }

        getGui() {
            return this.eGui;
        }
    }

    let rowDataRequest = [];
    const columnDefsRequest = [
        {field: "No", headerName: "No", cellStyle: {textAlign: "center"}},
        {field: "commonCodeDutyKind", headerName: "업무 분류", cellStyle: {textAlign: "center"}},
        {field: "jobSj", headerName: "업무 제목", cellStyle: {textAlign: "center"}},
        {field: "jobTerm", headerName: "업무 기간", cellStyle: {textAlign: "center"}},
        {field: "chk", headerName: " ", cellRenderer: ClassJobBtn, cellStyle: {textAlign: "center"}},
        {field: "jobNo", headerName: "jobNo", hide: true, cellStyle: {textAlign: "center"}}
    ];

    <c:forEach var="jobVO" items="${jobList}" varStatus="status">
    rowDataRequest.push({
        No: "${status.count}",
        commonCodeDutyKind: "${jobVO.commonCodeDutyKind}",
        jobSj: "${jobVO.jobSj}",
        jobTerm: "${jobVO.jobBeginDate} ~ ${jobVO.jobClosDate}",
        jobNo: "${jobVO.jobNo}"
    })
    </c:forEach>

    const gridRegistOptions = {
        columnDefs: columnDefsRequest,
        rowData: rowDataRequest,
        pagination: true,
        paginationPageSize: 10,
        onGridReady: function (event) {
            event.api.sizeColumnsToFit();
        },
        rowHeight: 50,
    };

    document.querySelector("#searchBtn").addEventListener("click", () => {
        let selectedYear = document.querySelector("#yearSelect").value;
        let selectedMonth = document.querySelector("#monthSelect").value;
        data = {
            "year": selectedYear,
            "month": selectedMonth
        }

        $.ajax({
            type: 'get',
            url: '/job/getJobByDateFilter',
            data: data,
            contentType: 'application/json; charset=utf-8',
            success: function (jobVOList) {
                rowDataRequest = [];
                jobVOList.forEach(function (jobVO, index) {
                    rowDataRequest.push({
                        No: index + 1,
                        commonCodeDutyKind: jobVO.commonCodeDutyKind,
                        jobSj: jobVO.jobSj,
                        jobTerm: `\${jobVO.jobBeginDate} ~ \${jobVO.jobClosDate}`,
                        jobNo: jobVO.jobNo
                    });
                });
                gridRegistOptions.api.setRowData(rowDataRequest);
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        });
    });

    document.addEventListener('DOMContentLoaded', () => {
        const requestJobGrid = document.querySelector('#request-job');
        new agGrid.Grid(requestJobGrid, gridRegistOptions);
    })
</script>