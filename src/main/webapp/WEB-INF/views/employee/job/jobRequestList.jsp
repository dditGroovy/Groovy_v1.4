<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<style>
    #request-job {
        height: 60%;
    }
    #modal {
        width: 30%;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
    }
    .modal-header {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .modal-body {
        display: flex;
        width: 100%;
    }

    .form-data-list {
        display: flex;
        flex-direction: column;
    }

    .modal-body > ul {
        padding: 0 24px;
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    form {
        width: 100%;
    }

    .input-date, .date {
        display: flex;
        gap: 12px;
    }

    .date > div {
        flex: 1;
    }

    .input-date > input {
        flex: 1;
    }

    .modal-footer {
        display: flex;
        justify-content: center;
    }

    .modal-footer > button {
        width: 40%;
        padding: 10px;
    }

    .modal-common, .modal-option {
        display: none;
    }

    .modal-common.on, .modal-option.on {
        display: block;
    }

    .state-list, .tab-list {
        list-style: none;
        display: flex;
        gap: 12px;
    }

    .head {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .data-box {
        border: 1px solid black;
        padding: 12px;
    }

    .대기 {
        border-radius: 8px;
        background: var(--color-font-row);
        padding: 10px;
        color: white;
    }

    .승인 {
        border-radius: 8px;
        background: var(--color-main);
        padding: 10px;
        color: white;
    }

    .거절 {
        border-radius: 8px;
        background: #D93C3C;
        padding: 10px;
        color: white;
    }
</style>

<div class="content-container">
    <div id="title">
        <h1>요청한 업무 내역</h1>
    </div>
    <select id="yearSelect">
        <option value="">년도 선택</option>
    </select>
    <select id="monthSelect">
        <option value="">월 선택</option>
    </select>
    <button type="button" id="searchBtn">검색</button>
    <div id="request-job" class="ag-theme-alpine"></div>

    <!-- 모달 시작 -->
    <div id="modal">
        <div id="modal-requestDetail-job" class="modal-common">
            <div class="modal-header">
                <h4><i class="icon icon-idea"></i>업무 요청하기(상세)</h4>
                <button class="close">&times;</button>
            </div>
            <div class="modal-body">
                <ul>
                    <li class="form-data-list">
                        <h5>📚 업무 제목</h5>
                        <div class="data-box">
                            <p class="data-sj"></p>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5>✅ 업무 내용</h5>
                        <div class="data-box">
                            <p class="data-cn"></p>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5>📅 업무 기간</h5>
                        <div class="date">
                            <div class="data-box">
                                <p class="data-begin"></p>
                            </div>
                            <div class="data-box">
                                <p class="data-close"></p>
                            </div>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5 for="">💭 업무 분류</h5>
                        <div class="input-data">
                            <input type="radio" value="DUTY010" class="data-kind" disabled/>
                            <label>회의</label>
                            <input type="radio" value="DUTY011" class="data-kind" disabled/>
                            <label>팀</label>
                            <input type="radio" value="DUTY012" class="data-kind" disabled/>
                            <label>개인</label>
                            <input type="radio" value="DUTY013" class="data-kind" disabled/>
                            <label>교육</label>
                            <input type="radio" value="DUTY014" class="data-kind" disabled/>
                            <label>기타</label>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <div class="head">
                            <h5>💌 받는 사람</h5>
                            <ul class="state-list">
                                <li>대기</li>
                                <li>승인</li>
                                <li>거절</li>
                            </ul>
                        </div>
                        <div class="data-box" id="receiveBox">

                        </div>

                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <button class="close">확인</button>
            </div>
        </div>
    </div>

</div>
<script>
    let yearBtn = document.querySelector("#yearSelect");
    // 모달 열기 함수
    function openModal(modalId) {
        document.querySelector("#modal").style.display = "flex";
        document.querySelector(modalId).classList.add("on");
    }

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
                              <button type="button" class="detail">상세</button>
                            `;
            this.detailBtn = this.eGui.querySelector(".detail");
            this.detailBtn.onclick = () => {
                document.querySelector("#modal").style.display = "block";
                openModal("#modal-requestDetail-job");
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
                            code +=  `<span class="\${jobProgressVO.commonCodeDutySttus}">
                                    <span>\${jobProgressVO.jobRecptnEmplNm}</span>
                                    \${jobProgressVO.commonCodeDutySttus === '승인' ? `<span> | \${jobProgressVO.commonCodeDutyProgrs}</span>` : ''}
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
        {field: "No", headerName: "No"},
        {field: "commonCodeDutyKind", headerName: "업무 분류"},
        {field: "jobSj", headerName: "업무 제목"},
        {field: "jobTerm", headerName: "업무 기간"},
        {field: "chk", headerName: " ", cellRenderer: ClassJobBtn},
        {field: "jobNo", headerName: "jobNo", hide: true}
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
        pagination:true,
        paginationPageSize: 10,
    };

    document.querySelector("#searchBtn").addEventListener("click", ()=> {
        let selectedYear = document.querySelector("#yearSelect").value;
        let selectedMonth = document.querySelector("#monthSelect").value;
        data = {
            "year": selectedYear,
            "month": selectedMonth
        }

        $.ajax({
            type:'get',
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
    });

</script>