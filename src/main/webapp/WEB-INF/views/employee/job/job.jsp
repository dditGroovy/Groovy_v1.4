<%@ page import="kr.co.groovy.enums.DutyKind" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css"/>


<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/job/job.css">
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

    .todoCard {
        margin: 4px 0;
    }

    .list-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    /*#modal {
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
    }*/



    .modal-body > ul {
        padding: 0 24px;
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    form {
        width: 100%;
    }





    /*.modal-footer {
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
    }*/


    .head {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }


</style>
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/job/main" class="on">할 일</a></h1>
        <h1><a href="${pageContext.request.contextPath}/job/jobDiary">업무 일지</a></h1>
    </header>
    <main>
        <div class="main-inner job-inner">
            <div class="job-inner-top">
                <section id="receive-job">
                    <div class="content-wrap card card-df">
                        <div class="content-header">
                            <h2 class="main-title">
                                들어온 업무 요청
                            </h2>
                        </div>
                        <div class="content-body">
                            <ul class="receive-list job-list">
                            <c:choose>
                                <c:when test="${not empty receiveJobList}">
                                    <c:forEach var="receiveJobVO" items="${receiveJobList}">
                                        <li class="receive-list-item list-item">
                                            <button class="receiveJob btn btn-modal" data-seq="${receiveJobVO.jobNo}" data-name="receiveJobDetail">
                                                <div class="empl-info">
                                                    <img src="/uploads/profile/${receiveJobVO.jobRequstEmplProfl}" alt="profile" class="empl-profile">
                                                    <span class="empl-name">${receiveJobVO.jobRequstEmplNm}</span>
                                                </div>
                                                <div class="receive-job-detail">
                                                    <p class="receive-job-title job-title">${receiveJobVO.jobSj}</p>
                                                    <span class="receive-job-date job-date">${receiveJobVO.jobRequstDate}</span>
                                                </div>
                                            </button>
                                            <div class="btn-wrap">
                                                <button type="button" class="jobReject btn receive-btn">거절</button>
                                                <button type="button" class="jobAgree btn receive-btn">승인</button>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li class="no-list"><span>들어온 업무 요청이 없습니다.</span></li>
                                </c:otherwise>
                            </c:choose>
                            </ul>
                        </div>
                    </div>
                </section>
                <section id="request-job">
                    <div class="content-wrap card card-df">
                        <div class="content-header">
                            <div>
                                <h2 class="main-title">
                                    요청한 업무
                                </h2>
                                <a href="/job/request" class="more">더보기</a>
                            </div>
                            <button class="requestJob btn btn-flat btn-modal" data-name="newRequestJob"><i class="icon i-send-blue"></i>업무 요청하기</button>
                        </div>
                        <div class="content-body">
                            <ul class="request-list job-list">
                                <c:choose>
                                    <c:when test="${not empty requestJobList}">
                                        <c:forEach var="requestJobVO" items="${requestJobList}">
                                            <li class="request-list-item list-item">
                                                <button type="button" class="requestJobDetail btn btn-modal" data-seq="${requestJobVO.jobNo}" data-name="requestJobDetail">
                                                    <p class="job-title request-job-title">${requestJobVO.jobSj}</p>
                                                    <span class="request-job-date job-date">${requestJobVO.jobRequstDate}</span>
                                                </button>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="no-list"><span>요청한 업무가 없습니다.</span></li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                    </div>
                </section>
            </div>
            <div class="job-inner-bt">
                <div id="todoBoard">
                    <div class="todoBoardListWrapper swiper-wrapper">
                        <c:forEach var="dayInfo" items="${dayOfWeek}" varStatus="stat">
                            <div class="todoBoardList card card-df swiper-slide">
                                <div class="list-header">
                                    <div class="list-header-name">
                                        <p class="day" data-date="${dayInfo.date}">${dayInfo.day}</p>
                                    </div>
                                    <div class="list-header-add">
                                        <button class="addJob btn btn-modal" data-name="newJob">+</button>
                                    </div>
                                </div>
                                <div class="list-content">
                                    <c:choose>
                                        <c:when test="${not empty jobListByDate[stat.index]}">
                                            <c:forEach var="jobVO" items="${jobListByDate[stat.index]}">
                                            <button type="button" class="todoCard myJob btn btn-modal" data-name="jobDetail"
                                                    data-seq="${jobVO.jobNo}">
                                                <div class="todoCard-title">
                                                    <span class="todoName">${jobVO.jobSj}</span>
                                                </div>
                                                <div class="todoCard-info">
                                                    <div class="badge-wrap">
                                                        <span class="dutyProgrs badge">${jobVO.jobProgressVOList[0].commonCodeDutyProgrs}</span>
                                                        <span class="dutykind badge">${jobVO.commonCodeDutyKind}</span>
                                                    </div>
                                                    <span class="toDoClosDate">${jobVO.jobClosDate}까지</span>
                                                </div>
                                            </button>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-list">등록된 업무가 없습니다.</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm receiveJobDetail">
                <div class="modal-top">
                    <div class="modal-title"><i class="icon i-idea i-3d"></i>들어온 업무 요청</div>
                    <button type="button" class="modal-close btn close">
                        <i class="icon i-close">X</i>
                    </button>
                </div>
                <div class="modal-container">
                    <ul class="modal-list">
                        <li class="form-data-list">
                            <h5 class="modal-title">📚 업무 제목</h5>
                            <div class="data-box input-l modal-input">
                                <p class="receive-sj"></p>
                            </div>
                        </li>
                        <li class="form-data-list">
                            <h5 class="modal-title">✅ 업무 내용</h5>
                            <div class="data-box input-l modal-input">
                                <p class="receive-cn"></p>
                            </div>
                        </li>
                        <li class="form-data-list">
                            <h5 class="modal-title">📅 업무 기간</h5>
                            <div class="input-date">
                                <div class="data-box input-l modal-input">
                                    <p class="receive-begin"></p>
                                </div>
                                ~
                                <div class="data-box input-l modal-input">
                                    <p class="receive-close"></p>
                                </div>간
                            </div>
                        </li>
                        <li class="form-data-list">
                            <h5 class="modal-title">💭 업무 분류</h5>
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
                            <h5 class="modal-title">💌 보낸 사람</h5>
                            <div class="data-box input-l modal-input">
                                <p class="receive-request"></p>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <div class="btn-wrap">
                        <button type="button" id="reject" class="btn btn-fill-wh-sm">거절</button>
                        <button type="button" id="agree" class="btn btn-fill-bl-sm">승인</button>
                    </div>
                </div>
        </div>
        <div class="modal-layer card-df sm newRequestJob">
            <div class="modal-top">
                <div class="modal-title"><i class="icon i-idea i-3d"></i>업무 요청</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <form id="requestJob" method="post">
                    <ul class="modal-list">
                        <li class="form-data-list">
                            <label for="jobSj" class="modal-title">📚 업무 제목</label>
                            <input type="text" name="jobSj" id="jobSj" class="input-l modal-input" placeholder="업무 제목을 입력하세요.">
                        </li>
                        <li class="form-data-list">
                            <label for="jobCn" class="modal-title">✅ 업무 내용</label>
                            <input type="text" name="jobCn" id="jobCn" placeholder="업무 내용을 입력하세요." class="input-l modal-input">
                        </li>
                        <li class="form-data-list">
                            <label class="modal-title">📅 업무 기간</label>
                            <div class="input-date">
                                <input type="date" name="jobBeginDate" id="jobBeginDate" onchange="validateDate()"
                                       placeholder="시작 날짜" class="input-l modal-input">
                                ~
                                <input type="date" name="jobClosDate" id="jobClosDate" onchange="validateDate()"
                                       placeholder="끝 날짜" class="input-l modal-input">
                            </div>
                        </li>
                        <li class="form-data-list">
                            <label class="modal-title">💭 업무 분류</label>
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
                            <label class="modal-title">🔥 업무 진행</label>
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
                            <div class="receive-org-wrap">
                                <label class="modal-title">💌 받는 사람</label>
                                <button type="button" id="orgBtn" class="btn btn-flat">조직도</button>
                            </div>
                            <label for="receive" style="width: 100%">
                                <div id="receive" class="input-l modal-input">
                                </div>
                                <div id="orgChart"></div>
                            </label>
                        </li>
                    </ul>
                </form>
            </div>
            <div class="modal-footer">
                <div class="btn-wrap">
                    <button class="close btn btn-fill-wh-sm">취소</button>
                    <button type="submit" id="request"  class="btn btn-fill-bl-sm">요청</button>
                </div>
            </div>
        </div>
        <div class="modal-layer card-df sm requestJobDetail">
            <div class="modal-top">
                <div class="modal-title"><i class="icon i-idea i-3d"></i>업무 요청(상세)</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-container">
                    <ul class="modal-list">
                        <li class="form-data-list">
                            <h5 class="modal-title">📚 업무 제목</h5>
                            <div class="data-box input-l modal-input">
                                <p class="data-sj"></p>
                            </div>
                        </li>
                        <li class="form-data-list">
                            <h5 class="modal-title">✅ 업무 내용</h5>
                            <div class="data-box input-l modal-input">
                                <p class="data-cn"></p>
                            </div>
                        </li>
                        <li class="form-data-list">
                            <h5 class="modal-title">📅 업무 기간</h5>
                            <div class="input-date">
                                <div class="data-box input-l modal-input">
                                    <p class="data-begin"></p>
                                </div>
                                ~
                                <div class="data-box input-l modal-input">
                                    <p class="data-close"></p>
                                </div>
                            </div>
                        </li>
                        <li class="form-data-list">
                            <h5 class="modal-title">💭 업무 분류</h5>
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
                                    <li class="state-list-item state-list-wait">대기</li>
                                    <li class="state-list-item state-list-agree">승인</li>
                                    <li class="state-list-item state-list-reject">거절</li>
                                </ul>
                            </div>
                            <div class="data-box input-l modal-input" id="receiveBox">
                            </div>
                        </li>
                    </ul>
            </div>
            <div class="modal-footer">
                <div class="btn-wrap">
                    <button class="close btn btn-fill-wh-sm">확인</button>
                </div>
            </div>
        </div>
        <div class="modal-layer card-df sm newJob">
            <div class="modal-top">
                <div class="modal-title"><i class="icon i-idea i-3d"></i>업무 등록</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-tab">
                <div class="tab-wrap">
                    <div id="tabs">
                        <input type="radio" name="tabs" id="tab-new-job" checked>
                        <label for="tab-new-job" class="tab">신규 등록</label>
                        <input type="radio" name="tabs" id="tab-new-request">
                        <label for="tab-new-request" class="tab">요청 받은 업무 목록</label>
                        <div class="glider"></div>
                    </div>
                </div>
            </div>
            <div class="modal-container">
                <div class="modal-option new-job on" data-target="tab-new-job">
                    <form id="registNewJob">
                        <ul class="modal-list">
                            <li class="form-data-list">
                                <label for="sj" class="modal-title">📚 업무 제목</label>
                                <input type="text" name="jobSj" id="sj" class="input-l modal-input" placeholder="업무 제목을 입력하세요.">
                            </li>
                            <li class="form-data-list">
                                <label for="cn" class="modal-title">✅ 업무 내용</label>
                                <input type="text" name="jobCn" id="cn" class="input-l modal-input" placeholder="업무 내용을 입력하세요.">
                            </li>
                            <li class="form-data-list">
                                <label class="modal-title">📅 업무 기간</label>
                                <div class="input-date">
                                    <input type="date" name="jobBeginDate" placeholder="시작 날짜"
                                           onchange="newValidateDate()" id="date-begin" class="input-l modal-input">
                                    ~
                                    <input type="date" name="jobClosDate" placeholder="끝 날짜"
                                           onchange="newValidateDate()" id="date-close" class="input-l modal-input">
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

                    </form>
                </div>
                <div class="modal-option new-request" data-target="tab-new-request">
                    <form>
                        <div class="request-list-wrap">
                            <c:choose>
                                <c:when test="${not empty receiveJobList}">
                                    <c:forEach var="receiveJobVO" items="${receiveJobList}">
                                        <button type="button" class="receiveJob btn" data-seq="${receiveJobVO.jobNo}">
                                            <div class="empl-info">
                                                <img src="/uploads/profile/${receiveJobVO.jobRequstEmplProfl}" alt="profile"
                                                     class="empl-profile">
                                                <span class="empl-name">${receiveJobVO.jobRequstEmplNm}</span>
                                            </div>
                                            <div class="request-job-detail">
                                                <p class="receive-job-title job-title"> ${receiveJobVO.jobSj}</p>
                                                <span class="receive-job-date job-date"><fmt:formatDate value="${receiveJobVO.jobRequstDate}"
                                                                              pattern="yy년 MM월 dd일"/></span>
                                            </div>
                                        </button>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span class="no-list">요청 받은 업무가 없습니다.</span>
                                </c:otherwise>
                            </c:choose>

                        </div>
                        <ul class="modal-list">
                            <li class="form-data-list">
                                <label>📚 업무 제목</label>
                                <div class="data-box input-l modal-input">
                                    <p id="receive-sj"></p>
                                </div>
                            </li>
                            <li class="form-data-list">
                                <label>✅ 업무 내용</label>
                                <div class="data-box input-l modal-input">
                                    <p id="receive-cn"></p>
                                </div>
                            </li>
                            <li class="form-data-list">
                                <label>📅 업무 기간</label>
                                <div class="input-date">
                                    <div class="data-box input-l modal-input">
                                        <p id="receive-begin"></p>
                                    </div>
                                    ~
                                    <div class="data-box input-l modal-input">
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
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <div class="tab-new-job on">
                    <div class="btn-wrap">
                            <button type="button" class="close btn btn-fill-wh-sm">취소</button>
                            <button type="button" id="regist" class="regist btn btn-fill-bl-sm">등록</button>
                    </div>
                </div>
                <div class="tab-new-request">
                    <div class="btn-wrap">
                        <button type="button" id="rejectJob" class="btn btn-fill-wh-sm">거절</button>
                        <button type="button" id="agreeJob" class="btn btn-fill-bl-sm">승인</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal-layer card-df sm jobDetail">
            <div class="modal-top">
                <div class="modal-title"><i class="icon i-idea i-3d"></i>업무 상세</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <ul class="modal-list">
                    <li class="form-data-list">
                        <h5 class="modal-title">📚 업무 제목</h5>
                        <div class="data-box input-l modal-input">
                            <p id="sj-data" class="detail-p">
                                <input type="text" name="jobSj" class="input-text font-14" readonly>
                            </p>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5 class="modal-title">✅ 업무 내용</h5>
                        <div class="data-box input-l modal-input">
                            <p id="cn-data" class="detail-p">
                                <input type="text" name="jobCn" class="input-text font-14" readonly>
                            </p>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5 class="modal-title">📅 업무 기간</h5>
                        <div class="input-date">
                            <div class="data-box input-l modal-input">
                                <p id="begin-data" class="detail-p">
                                    <input type="date" name="jobBeginDate" class="input-date font-14 font-reg" readonly>
                                </p>
                            </div>
                            <div class="data-box input-l modal-input">
                                <p id="close-data" class="detail-p">
                                    <input type="date" name="jobClosDate"  class="input-date font-14 font-reg" readonly>
                                </p>
                            </div>
                        </div>
                    </li>
                    <li class="form-data-list">
                        <h5 class="modal-title">💭 업무 분류</h5>
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
                        <h5 class="modal-title">🔥 업무 상태</h5>
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
                    <li class="form-data-list send-empl">
                        <div class="head">
                            <h5 class="modal-title">💌 보낸 사람</h5>
                        </div>
                        <div class="data-box input-l modal-input">
                            <p id="request-data"></p>
                        </div>
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <div class="btn-wrap">
                    <button class="close btn-close btn btn-fill-wh-sm">취소</button>
                    <button type="button" id="modify"  class="btn btn-fill-bl-sm">수정</button>
                    <button type="button" id="confirm" style="display: none" class="btn btn-fill-bl-sm">저장</button>
                </div>
            </div>
        </div>

    </div>
</div>
<script src="/resources/js/orgChart.js"></script>
<script src="/resources/js/modal.js"></script>
<script src="/resources/js/job.js"></script>

<script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/validate.js"></script>

<script>
    <sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser" />
    let emplNm = `${CustomUser.employeeVO.emplNm}`;
    let emplId = `${CustomUser.employeeVO.emplId}`;
    </sec:authorize>

    let swiper = new Swiper("#todoBoard", {
        slidesPerView: 5,
        centeredSlides: true,
        spaceBetween: 24,
        grabCursor: true,
    });
    setMinDate("jobBeginDate");
    setMinDate("jobClosDate");
    setDate("jobBeginDate");
    setDate("jobClosDate");
</script>