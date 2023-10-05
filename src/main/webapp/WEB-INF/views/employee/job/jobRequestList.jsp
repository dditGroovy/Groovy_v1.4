<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-theme-alpine.css">
<link rel="stylesheet" href="/resources/css/common.css">
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>

<style>
	
	h4 > i.icon {
	    display: inline-block;
	    width: 13%;
	    height: 13%;
	    vertical-align: middle;
	    margin: 10px;
	}
	
	.form-data-list > h5{
		color: gray;
		font-weight: bold;
	}
	
	.ag-header-cell-text {
    	overflow: hidden;
    	text-overflow: ellipsis;
    	color: black!important;
    	text-align: center;
    	width: 100%;
    	font-size: var(--font-size-14);
	}
	
	
	.ag-body ag-layout-normal{
		font-size: var(--font-size-14);
	}
	
	.select-wrapper {
	    float: left;
	    margin: 10px;
	    top: 13px;
	}

	.close{
	    left: 100%;
	    position: sticky;
	    width: 15%;
	    height: 31px;
	    border: 1px solid white;
	    background-color: white;
	    font-size: 28px;
	}
	
	.check{
		position: relative;
	    font-size: 100%;
	    margin-top: 5%;
	    margin-left: 2.5%;
	    height: var(--vh-64);
	    background-color: white;
	    border-radius: var(--size-24);
	    border: 1px solid var(--color-main);
	    color: var(--color-main);
	}
	
	.cancel{
		position: relative;
	    font-size: 100%;
	    margin-top: 5%;
	    margin-right: 2.5%;
	    height: var(--vh-64);
	    background-color: white;
	    border-radius: var(--size-24);
	    border: 1px solid gray;
	    color: gray;
	}
	
    #request-job {
        height: 60%;
    }
    
    #modal {
	    width: 30%;
	    display: flex;
	    flex-direction: column!important;
	    align-items: flex-start!important;
	    position: fixed!important; /* 모달을 고정 위치로 설정 */
	    top: 46%; /* 화면 위 아래 중앙으로 이동 */
	    left: 60%; /* 화면 좌우 중앙으로 이동 */
	    transform: translate(-50%, -50%); /* 중앙으로 정확히 이동 */
	}
	
    .modal-header {
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 10%;
        font-weight: bold!important;
    }
	
	.modal-header > h4{
		text-align: center;
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
        display: flex!important;
        justify-content: center!important;
    }

    .modal-footer > button {
        width: 41%;
        padding: 10px;
        margin-bottom: 5%;
    }

    .modal-common, .modal-option {
        display: none;
    }

    .modal-common.on, .modal-option.on {
        display: block!important;
       	background-color: white!important;
       	border-radius: var(--size-32);
       	border: 1px solid black;
    }

    .state-list, .tab-list {
        list-style: none;
        display: flex;
        gap: 12px;
        font-size: xx-small;
    }

    .head {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .data-box {
        border: 1px solid var(--color-stroke);
        padding: 12px;
        border-radius: 30px;
        height: 100%;
        width: 100%;
        background-color: #F5FAFF;
        text-align: left;
    }
	
	.대기, .승인, .거절{
		border-radius: 8px;
		padding: 10px;
        color: aliceblue;
	}
	
	.stand, .approval, .refuse{
		float: right;
	}
	
    .stand, .대기 {
    	width: 10px;
    	height: 10px;
        background: var(--color-font-row);
    }

    .approval, .승인 {
    	width: 10px;
    	height: 10px;
        background: var(--color-main);
    }

    .refuse, .거절 {
    	width: 10px;
    	height: 10px;
        background: #D93C3C;
    }
   	.data-box > span{
		color: white!important;
	    height: 31px;
	    width: 57px;
	    font-size: small;
	    display: inline-table;
	    margin: 1%;
	    margin-left: 7%;
   	}
   	
   	.data-box > .승인{
		height: 31px;
    	width: 34%;
   	}
   	
   	.names{
   		color: aliceblue;
   	}
   	
   	.font-md {
    	font-family: "Pretendard-medium";
    	color: black;
	}

	.font-24 {
    	font-size: var(--font-size-24);
    	color: black;
    }
    /*	더보기 스타일 적용	*/
    
    #yearSelect, #monthSelect {
	    width: calc((230/1920)*100vw);
	    padding: var(--vh-12) var(--vw-10);
	    font-size: var(--font-size-14);
	    color: var(--color-font-md);
	    border-radius: var(--vw-10);
	    -o-appearance: none;
	    -webkit-appearance: none;
	    -moz-appearance: none;
	    appearance: none;
	    outline: none;
	    font-weight: bold;
	}
	
	#searchBtn {
		cursor: pointer;
	    background-color: var(--color-main);
	    border: 1px solid var(--color-stroke);
	    border-radius: var(--size-32);
	    padding: var(--vw-12);
	    width: 5%;
	    height: 4%;
	    font-weight: bold;
	    color: white;
	    margin-top: 25px;
	    font-size: x-small;
	}
    
    .ag-header-container, .ag-center-cols-container {
    	width: 100% !important;
    	white-space: nowrap;
    	margin: 0px auto;
    	background-color: #F5FAFF;
    	color: white; 
	}
	
	.ag-ltr .ag-cell {
    	border-right-width: 1px;
    	text-align: center;
    	font-size: var(--font-size-14);
	}
	
	.ag-root-wrapper {
		border: none;
		margin-top: 20px;
	}
	
	.detail{
	    margin-top: 2px;
	    width: calc((115 / var(--vw)) * 100vw);
	    background-color: white;
	    height: 35px;
	    border-radius: var(--size-32);
	    border: 1px solid gray;
	    color: gray;
	    font-size: var(--font-size-14);
	}
	.ag-paging-panel {
	    border: 1px solid white;
	    color: var(--ag-secondary-foreground-color);
	    height: var(--ag-header-height);
	    margin: 0px auto;
	}
	
	.ag-paging-row-summary-panel{
		display: none;
	}
	
	#title{
	    font-weight: bold;
	    margin-left: 13px;
	}
</style>

<div class="content-container">
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
    <div id="modal">
        <div id="modal-requestDetail-job" class="modal-common">
            <div class="modal-header">
                <h4><i class="icon icon-idea">💡</i>업무 요청하기(상세)</h4>
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
                            	<li class="stand"></li>
                                <li	>대기</li>
                                <li class="approval"></li>
                                <li>승인</li>
                                <li class="refuse"></li>
                                <li>거절</li>
                            </ul>
                        </div>
                        <div class="data-box" id="receiveBox">

                        </div>
						<div id="pagination" class="pagination-wrapper">
							
						</div>
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <button class="cancel">취소</button>
                <button class="check">확인</button>
            </div>
        </div>
    </div>

</div>
<script>
    let yearBtn = document.querySelector("#yearSelect");
 // 모달 열기 함수
    function openModal(modalId) {
        const modal = document.querySelector(modalId);
        modal.style.display = "block";
        document.body.style.overflow = "hidden"; // 스크롤 막기
        modal.classList.add("on");
    }

    // 모달 닫기 함수
    function closeModal(modalId) {
        const modal = document.querySelector(modalId);
        modal.style.display = "none";
        document.body.style.overflow = "auto"; // 스크롤 복원
        modal.classList.remove("on");
    }

    // 모달 닫기 버튼과 모달 외부를 클릭했을 때 모달 닫기
	document.querySelectorAll(".close, .check, .cancel	").forEach((button) => {
	    button.addEventListener("click", () => {
	        closeModal("#modal-requestDetail-job");
	    });
	});

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
                document.querySelector("#modal");
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
                                    <span class="names">\${jobProgressVO.jobRecptnEmplNm}</span>
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
        paginationPageSize: 10
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