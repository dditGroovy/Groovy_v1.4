<%@ page import="kr.co.groovy.enums.DutyKind" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<style>
    .border {
        border: 1px solid #333333;
        display: flex;
        gap: 24px;
    }

    .orgBorder {
        border: 1px solid #333333;
        width: 100%;
    }

    .taskBoxWrapper {
        display: flex;
        gap: 24px;
        margin: 48px;
    }

    .inTaskBox {
        border: 1px solid #333333;
        flex: 7;
    }

    .outTaskBox {
        border: 1px solid #333333;
        flex: 3;
    }

    .todoBoardListWrapper {
        display: flex;
        gap: 24px;
    }

    .todoCard {
        margin: 4px 0;
    }

    .list-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    #modal {
        width: 30%;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        border: 1px solid red;
    }

    .modal-container {
        width: 100%;
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

    <a href="#">할 일</a>
    <a href="/job/jobDiary">업무 일지</a>

    <div id="todoBoard">
        <div class="todoBoardListWrapper">
            <c:forEach var="dayInfo" items="${dayOfWeek}" varStatus="stat">
                <div class="todoBoardList">
                    <div class="list-header">
                        <div class="list-header-name">
                            <p class="day" data-date="${dayInfo.date}">${dayInfo.day}</p>
                        </div>
                        <div class="list-header-add">
                            <button class="addJob">+</button>
                        </div>
                    </div>
                    <br/>
                    <div class="list-content">
                        <c:forEach var="jobVO" items="${jobListByDate[stat.index]}">
                            <button type="button" class="todoCard myJob" style="text-align: left"
                                    data-seq="${jobVO.jobNo}">
                                <div class="todoCard-title">
                                    <span class="todoName">${jobVO.jobSj}</span>
                                </div>
                                <div class="todoCard-info">
                                    <span class="dutyProgrs">${jobVO.jobProgressVOList[0].commonCodeDutyProgrs}</span>
                                    <span class="dutykind">${jobVO.commonCodeDutyKind}</span>
                                    <span class="toDoClosDate">${jobVO.jobClosDate}까지</span>
                                </div>
                            </button>
                            <br>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <div id="receiveJobContainer">
        <h1>들어온 업무 요청</h1>
        <c:forEach var="receiveJobVO" items="${receiveJobList}">
            <button class="receiveJob" data-seq="${receiveJobVO.jobNo}">
                <img src="/uploads/profile/${receiveJobVO.jobRequstEmplProfl}" alt="profile" style="width: 50px;">
                <span>${receiveJobVO.jobRequstEmplNm}</span>
                <span> | ${receiveJobVO.jobSj}</span>
                <span>&nbsp;&nbsp;&nbsp; &nbsp; ${receiveJobVO.jobRequstDate}</span>
            </button>
        </c:forEach>
    </div>

    <div id="requestJobContainer">
        <h1>요청한 업무</h1>
        <a href="/job/request">더보기</a>
        <c:forEach var="requestJobVO" items="${requestJobList}">
            <button type="button" class="requestJobDetail" data-seq="${requestJobVO.jobNo}">
                    ${requestJobVO.jobSj}
                        &nbsp; &nbsp; ${requestJobVO.jobRequstDate}
            </button>
            <br/>
        </c:forEach>
    </div>
    <button class="requestJob">업무 요청하기</button>
</div>
<div id="modal">
    <div class="modal-container">
        <div id="modal-receive-job" class="modal-common">
            <div class="modal-header">
                <h4><i class="icon icon-idea"></i>들어온 업무 요청</h4>
                <button class="close">&times;</button>
            </div>
            <div class="modal-body">
                <ul>
                    <li class="form-data-list">
                        <h5>📚 업무 제목</h5>
                        <div class="data-box">
                            <p class="receive-sj"></p>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5>✅ 업무 내용</h5>
                        <div class="data-box">
                            <p class="receive-cn"></p>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5>📅 업무 기간</h5>
                        <div>
                            <div class="data-box">
                                <p class="receive-begin"></p>
                            </div>
                            <div class="data-box">
                                <p class="receive-close"></p>
                            </div>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5 for="">💭 업무 분류</h5>
                        <div class="input-data">
                            <input type="radio" class="receive-kind" value="회의">
                            <label>회의</label>
                            <input type="radio" class="receive-kind" value="팀">
                            <label>팀</label>
                            <input type="radio" class="receive-kind" value="개인">
                            <label>개인</label>
                            <input type="radio" class="receive-kind" value="교육">
                            <label>교육</label>
                            <input type="radio" class="receive-kind" value="기타">
                            <label>기타</label>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5 for="">💌 보낸 사람</h5>
                        <div class="data-box">
                            <p class="receive-request"></p>
                        </div>
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <button id="reject">거절</button>
                <button id="agree">승인</button>
            </div>
        </div>
        <div id="modal-request-job" class="modal-common">
            <div class="modal-header">
                <h4><i class="icon icon-idea"></i>업무 요청하기</h4>
                <button class="close">&times;</button>
            </div>
            <div class="modal-body">
                <form id="requestJob" method="post">
                    <ul>
                        <li class="form-data-list">
                            <label for="jobSj">📚 업무 제목</label>
                            <input type="text" name="jobSj" id="jobSj" placeholder="업무 제목을 입력하세요.">
                        </li>
                        <li class="form-data-list">
                            <label for="jobCn">✅ 업무 내용</label>
                            <input type="text" name="jobCn" id="jobCn" placeholder="업무 내용을 입력하세요.">
                        </li>
                        <li class="form-data-list">
                            <label>📅 업무 기간</label>
                            <div class="input-date">
                                <input type="date" name="jobBeginDate" id="jobBeginDate" onchange="validateDate()"
                                       placeholder="시작 날짜">
                                ~
                                <input type="date" name="jobClosDate" id="jobClosDate" onchange="validateDate()"
                                       placeholder="끝 날짜">
                            </div>
                        </li>
                        <li class="form-data-list">
                            <label>💭 업무 분류</label>
                            <div class="input-data">
                                <input type="radio" name="commonCodeDutyKind" id="meeting" value="DUTY010"/>
                                <label for="meeting">회의</label>
                                <input type="radio" name="commonCodeDutyKind" id="team" value="DUTY012"/>
                                <label for="team">팀</label>
                                <input type="radio" name="commonCodeDutyKind" id="personal" value="DUTY011"/>
                                <label for="personal">개인</label>
                                <input type="radio" name="commonCodeDutyKind" id="edu" value="DUTY013"/>
                                <label for="edu">교육</label>
                                <input type="radio" name="commonCodeDutyKind" id="etc" value="DUTY014"/>
                                <label for="etc">기타</label>
                            </div>
                        </li>
                        <li class="form-data-list">
                            <label>🔥 업무 진행</label>
                            <div class="input-data">
                                <input type="radio" name="commonCodeDutyProgrs" id="DUTY030" value="DUTY030">
                                <label for="DUTY030">업무 전</label>
                                <input type="radio" name="commonCodeDutyProgrs" id="DUTY031" value="DUTY031">
                                <label for="DUTY031">업무 중</label>
                                <input type="radio" name="commonCodeDutyProgrs" id="DUTY032" value="DUTY032">
                                <label for="DUTY032">업무 완료</label>
                            </div>
                        </li>
                        <li class="form-data-list">
                            <label style="display: inline-block;">💌 받는 사람</label>
                            <button type="button" id="orgBtn">조직도</button>
                            <label for="receive" style="width: 100%">

                                <div id="receive" style="border: 1px solid #333; height: 50px; border-radius: 50px">
                                </div>
                                <div id="orgChart"></div>
                            </label>
                        </li>
                    </ul>
                </form>
            </div>
            <div class="modal-footer">
                <button class="close">취소</button>
                <button type="submit" id="request">요청</button>
            </div>
        </div>
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

        <div id="modal-newJob" class="modal-common">
            <div class="modal-header">
                <h4><i class="icon icon-idea"></i>업무 등록</h4>
                <button class="close">&times;</button>
            </div>
            <div class="modal-tab">
                <ul class="tab-list">
                    <li>
                        <button id="tab-new-job">신규 등록</button>
                    </li>
                    <li>
                        <button id="tab-new-request">요청 받은 업무 목록</button>
                    </li>
                </ul>
            </div>
            <div class="modal-body">
                <div class="modal-content">
                    <div class="modal-option new-job on" data-target="tab-new-job">
                        <form id="registNewJob">
                            <ul>
                                <li class="form-data-list">
                                    <label for="sj">📚 업무 제목</label>
                                    <input type="text" name="jobSj" id="sj" placeholder="업무 제목을 입력하세요.">
                                </li>
                                <li class="form-data-list">
                                    <label for="cn">✅ 업무 내용</label>
                                    <input type="text" name="jobCn" id="cn" placeholder="업무 내용을 입력하세요.">
                                </li>
                                <li class="form-data-list">
                                    <label>📅 업무 기간</label>
                                    <div class="input-date">
                                        <input type="date" name="jobBeginDate" placeholder="시작 날짜"
                                               onchange="newValidateDate()" id="date-begin">
                                        ~
                                        <input type="date" name="jobClosDate" placeholder="끝 날짜"
                                               onchange="newValidateDate()" id="date-close">
                                    </div>
                                </li>
                                <li class="form-data-list">
                                    <label>💭 업무 분류</label>
                                    <div class="input-data">
                                        <input type="radio" name="commonCodeDutyKind" value="DUTY010" id="meetingData">
                                        <label for="meetingData">회의</label>
                                        <input type="radio" name="commonCodeDutyKind" value="DUTY011" id="teamData">
                                        <label for="teamData">팀</label>
                                        <input type="radio" name="commonCodeDutyKind" value="DUTY012" id="personalData">
                                        <label for="personalData">개인</label>
                                        <input type="radio" name="commonCodeDutyKind" value="DUTY013" id="eduData">
                                        <label for="eduData">교육</label>
                                        <input type="radio" name="commonCodeDutyKind" value="DUTY014" id="etcData">
                                        <label for="etcData">기타</label>
                                    </div>
                                </li>
                                <li class="form-data-list">
                                    <label>🔥 업무 상태</label>
                                    <div class="input-data">
                                        <input type="radio" name="commonCodeDutyProgrs" value="DUTY030" id="beforeData">
                                        <label for="beforeData">업무 전</label>
                                        <input type="radio" name="commonCodeDutyProgrs" value="DUTY031" id="doingData">
                                        <label for="doingData">업무 중</label>
                                        <input type="radio" name="commonCodeDutyProgrs" value="DUTY032" id="doneData">
                                        <label for="doneData">업무 완료</label>
                                    </div>
                                </li>
                            </ul>
                            <button type="button" class="close">취소</button>
                            <button type="button" class="regist">등록</button>
                        </form>
                    </div>
                    <div class="modal-option new-request" data-target="tab-new-request">
                        <form action="">
                            <div class="request-list-wrap">
                                <c:forEach var="receiveJobVO" items="${receiveJobList}">
                                    <button type="button" class="receiveJob" data-seq="${receiveJobVO.jobNo}">
                                        <img src="/uploads/profile/${receiveJobVO.jobRequstEmplProfl}" alt="profile"
                                             style="width: 50px;">
                                        <span>${receiveJobVO.jobRequstEmplNm}</span>
                                        <span> | ${receiveJobVO.jobSj}</span>
                                        <span>&nbsp;&nbsp;<fmt:formatDate value="${receiveJobVO.jobRequstDate}"
                                                                          pattern="yy년 MM월 dd일"/></span>
                                    </button>
                                </c:forEach>
                            </div>
                            <ul>
                                <li class="form-data-list">
                                    <label>📚 업무 제목</label>
                                    <div class="data-box">
                                        <p id="receive-sj"></p>
                                    </div>
                                </li>
                                <li class="form-data-list">
                                    <label>✅ 업무 내용</label>
                                    <div class="data-box">
                                        <p id="receive-cn"></p>
                                    </div>
                                </li>
                                <li class="form-data-list">
                                    <label>📅 업무 기간</label>
                                    <div class="input-date">
                                        <div class="data-box">
                                            <p id="receive-begin"></p>
                                        </div>
                                        ~
                                        <div class="data-box">
                                            <p id="receive-close"></p>
                                        </div>
                                    </div>
                                </li>
                                <li class="form-data-list">
                                    <label>💭 업무 분류</label>
                                    <div class="input-data">
                                        <input type="radio" class="receive-kind-box" value="회의">
                                        <label>회의</label>
                                        <input type="radio" class="receive-kind-box" value="팀">
                                        <label>팀</label>
                                        <input type="radio" class="receive-kind-box" value="개인">
                                        <label>개인</label>
                                        <input type="radio" class="receive-kind-box" value="교육">
                                        <label>교육</label>
                                        <input type="radio" class="receive-kind-box" value="기타">
                                        <label>기타</label>
                                    </div>
                                </li>
                            </ul>
                            <button id="rejectJob">거절</button>
                            <button id="agreeJob">승인</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div id="modal-job-detail" class="modal-common">
            <div class="modal-header">
                <h4><i class="icon icon-idea"></i>업무 상세</h4>
                <button class="close">&times;</button>
            </div>
            <div class="modal-body">
                <ul>
                    <li class="form-data-list">
                        <h5>📚 업무 제목</h5>
                        <div class="data-box">
                            <p id="sj-data"></p>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5>✅ 업무 내용</h5>
                        <div class="data-box">
                            <p id="cn-data"></p>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5>📅 업무 기간</h5>
                        <div class="date">
                            <div class="data-box">
                                <p id="begin-data"></p>
                            </div>
                            <div class="data-box">
                                <p id="close-data"></p>
                            </div>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5 for="">💭 업무 분류</h5>
                        <div class="input-data">
                            <input type="radio" name="commonCodeDutyKind" value="회의" class="kind-data">
                            <label>회의</label>
                            <input type="radio" name="commonCodeDutyKind" value="팀" class="kind-data">
                            <label>팀</label>
                            <input type="radio" name="commonCodeDutyKind" value="개인" class="kind-data">
                            <label>개인</label>
                            <input type="radio" name="commonCodeDutyKind" value="교육" class="kind-data">
                            <label>교육</label>
                            <input type="radio" name="commonCodeDutyKind" value="기타" class="kind-data">
                            <label>기타</label>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5 for="">🔥 업무 상태</h5>
                        <div class="input-data">
                            <input type="radio" name="commonCodeDutyProgrs" value="업무 전" id="before" class="progress"
                                   data-code="DUTY030">
                            <label for="before">업무 전</label>
                            <input type="radio" name="commonCodeDutyProgrs" value="업무 중" id="doing" class="progress"
                                   data-code="DUTY031">
                            <label for="doing">업무 중</label>
                            <input type="radio" name="commonCodeDutyProgrs" value="업무 완" id="done" class="progress"
                                   data-code="DUTY032">
                            <label for="done">업무 완료</label>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <div class="head">
                            <h5>💌 보낸 사람</h5>
                        </div>
                        <div class="data-box">
                            <p id="request-data"></p>
                        </div>
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" id="modify">수정</button>
                <button type="button" id="confirm" style="display: none">확인</button>
            </div>
        </div>
    </div>
</div>
<script src="/resources/js/orgChart.js"></script>
<script src="/resources/js/job.js"></script>
<script>
    <sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser" />
    let emplNm = `${CustomUser.employeeVO.emplNm}`;
    </sec:authorize>
</script>