<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
    .recommend-icon-btn {
        width: calc((48 / 1920) * 100vw);
        height: calc((48 / 1920) * 100vw);
        background-color: transparent;
        border: 0;
        cursor: pointer;
    }

    .recommendBtn {
        background: url("/resources/images/icon/heart-on.svg") 100% center / cover;
    }

    .unRecommendBtn {
        background: url("/resources/images/icon/heart-off.svg") 100% center / cover;
    }

    .options {
        display: flex;
    }

    .option-btn.on {
        background-color: var(--color-main);
        color: white;
    }

    .option-body {
        display: flex;
        flex-direction: column;
    }

    .endBtn {
        display: none;
    }

    .endBtn.on {
        display: block;
    }

/*    .btn-wrap {
        display: none;
    }

    .btn-wrap.on {
        display: block;
    }*/
</style>
<link href="/resources/css/community/community.css" rel="stylesheet"/>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">
        <header id="tab-header">
            <h1><a href="${pageContext.request.contextPath}/teamCommunity" class="on">팀 커뮤니티</a></h1>
            <h2 class="main-desc"><strong class="font-sb">${CustomUser.employeeVO.deptNm}팀</strong>만을 위한 공간입니다&#x1F60A;</h2>
        </header>
        <main>
            <div class="main-inner community-inner">
                <section id="post">
                    <div class="post-wrap">
                        <div class="post-write-wrap">
                            <div class="post-card card card-df">
                                <div class="post-card-header">
                                    <h3 class="card-title"><i class="icon i-idea i-3d"></i>포스트 등록</h3>
                                </div>
                                <form action="${pageContext.request.contextPath}/teamCommunity/inputPost" method="post"  enctype="multipart/form-data">
                                    <div class="post-card-body">
                                            <div class="content-wrap">
                                               <textarea name="sntncCn" id="sntncCn" class="input-l"></textarea>
                                            </div>
                                    </div>
                                    <div class="post-card-footer">
                                        <div class="file-wrap">
                                            <label for="postFile" class="btn btn-free-white file-btn">
                                                <i class="icon i-file"></i>
                                                파일 첨부
                                            </label>
                                            <input type="file" name="postFile" id="postFile" style="display: none">
                                            <p id="originName"></p>
                                        </div>
                                        <div class="btn-wrap">
                                            <button id="insertPostBtn" class="btn btn-free-blue">등록</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="post-list-wrap">
                            <c:forEach var="sntncVO" items="${sntncList}">
                            <div class="post-card card card-df post" data-idx="${sntncVO.sntncEtprCode}">
                                <div class="post-card-header">
                                    <div class="writer-info">
                                        <img src="/uploads/profile/${sntncVO.proflPhotoFileStreNm}" class="thum"/>
                                        <div class="writer-info-detail">
                                            <h4 class="postWriterInfo" data-id="${sntncVO.sntncWrtingEmplId}">${sntncVO.sntncWrtingEmplNm}</h4>
                                            <p>${sntncVO.sntncWrtingDate}</p>
                                        </div>
                                    </div>
                                    <div class="more-wrap">
                                        <c:if test="${CustomUser.employeeVO.emplId == sntncVO.sntncWrtingEmplId}">
                                            <button class="more btn"><i class="icon i-more"></i></button>
                                            <ul class="more-list">
                                                <li><button type="button" class="modifyBtn btn">수정</button></li>
                                                <li><button type="button" class="deleteBtn btn">삭제</button></li>
                                            </ul>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="post-card-body">
                                    <div class="content-wrap">
                                        <p class="sntncCn input-l">
                                          ${sntncVO.sntncCn}
                                        </p>
                                    </div>
                                </div>
                                <div class="post-card-footer">
                                    <div class="enter-wrap">
                                        <div class="recommend-wrap">
                                            <c:forEach var="recommendedChk" items="${recommendedEmpleChk}">
                                                <c:if test="${recommendedChk.key == sntncVO.sntncEtprCode}">
                                                    <c:choose>
                                                        <c:when test="${recommendedChk.value == 0}">
                                                            <button class="recommend-icon-btn unRecommendBtn enter-btn"
                                                                    data-idx="${sntncVO.sntncEtprCode}"></button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="recommend-icon-btn recommendBtn enter-btn"
                                                                    data-idx="${sntncVO.sntncEtprCode}"></button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </c:forEach>
                                            <c:forEach var="recommendCnt" items="${recommendPostCnt}">
                                                <c:if test="${recommendCnt.key == sntncVO.sntncEtprCode}">
                                                    <span class="recommendCnt enter-text">${recommendCnt.value} Likes</span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                        <div class="answer-wrap">
                                            <c:forEach var="answerPostCnt" items="${answerPostCnt}">
                                                <c:if test="${answerPostCnt.key == sntncVO.sntncEtprCode}">
                                                    <button class="loadAnswer enter-btn btn"></button>
                                                    <span class="answerCnt enter-text">${answerPostCnt.value} Comments</span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            </c:forEach>
                        </div>
                    </div>
                </section>
                <section id="service">
                    <div class="post-wrap">
                    </div>
                </section>
            </div>
        </main>
        <h2>포스트 등록</h2>

        <hr/>
        <br/>
        <h2>포스트 불러오기</h2>
        <form>
            <table border="1" style="width: 90%;">
                <tr>
                    <th>글번호</th>
                    <th>사원 이름</th>
                    <th>등록일</th>
                    <th>포스트 내용</th>
                    <th>좋아요</th>
                    <th>수정/삭제</th>
                    <th>파일</th>
                    <th>수정/삭제</th>
                    <th>좋아요/좋아요수</th>
                    <th>댓글/댓글수</th>
                </tr>
                <c:forEach var="sntncVO" items="${sntncList}">

                    <tr data-idx="${sntncVO.sntncEtprCode}" class="post">
                        <td class="sntncEtprCode">${sntncVO.sntncEtprCode}</td>
                        <td class="postWriter">
                            <img src="/uploads/profile/${sntncVO.proflPhotoFileStreNm}" width="50px;"/>
                                ${sntncVO.sntncWrtingEmplNm}
                            <span class="postWriterInfo" data-id="${sntncVO.sntncWrtingEmplId}"
                                  style="display: none"></span>
                        </td>
                        <td>${sntncVO.sntncWrtingDate}</td>
                        <td class="sntncCn">${sntncVO.sntncCn}</td>
                        <td>${sntncVO.recomendCnt}</td>
                        <td>${sntncVO.sntncWrtingEmplId}</td>
                        <td>
                            <c:choose>
                                <c:when test="${sntncVO.uploadFileSn != null && sntncVO.uploadFileSn != 0.0}">
                                    <a href="/file/download/teamCommunity?uploadFileSn=${sntncVO.uploadFileSn}">
                                            ${sntncVO.uploadFileOrginlNm}
                                    </a>
                                    <fmt:formatNumber value="${sntncVO.uploadFileSize / 1024.0}" type="number"
                                                      minFractionDigits="1" maxFractionDigits="1"/> KB
                                </c:when>
                                <c:otherwise>
                                    파일없음
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:if test="${CustomUser.employeeVO.emplId == sntncVO.sntncWrtingEmplId}">
                                <button type="button" class="modifyBtn">수정</button>
                                <button type="button" class="deleteBtn">삭제</button>
                            </c:if>
                        </td>

                        <td>
                            <c:forEach var="recommendedChk" items="${recommendedEmpleChk}">
                                <c:if test="${recommendedChk.key == sntncVO.sntncEtprCode}">
                                    <c:choose>
                                        <c:when test="${recommendedChk.value == 0}">
                                            <button class="recommend-icon-btn unRecommendBtn"
                                                    data-idx="${sntncVO.sntncEtprCode}"></button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="recommend-icon-btn recommendBtn"
                                                    data-idx="${sntncVO.sntncEtprCode}"></button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </c:forEach>
                            <c:forEach var="recommendCnt" items="${recommendPostCnt}">
                                <c:if test="${recommendCnt.key == sntncVO.sntncEtprCode}">
                                    <span class="recommendCnt">${recommendCnt.value}</span>
                                </c:if>
                            </c:forEach>
                        </td>
                        <td>
                            <c:forEach var="answerPostCnt" items="${answerPostCnt}">
                                <c:if test="${answerPostCnt.key == sntncVO.sntncEtprCode}">
                                    <span class="answerCnt">${answerPostCnt.value}</span>
                                </c:if>
                            </c:forEach>
                            <img src="/uploads/profile/${CustomUser.employeeVO.proflPhotoFileStreNm}" alt="profileImage"
                                 style="width: 50px; height: 50px;"/>
                            <textarea class="answerCn"></textarea>
                            <button class="inputAnswer">댓글 등록</button>

                        </td>
                        <td class="answerBox"></td>
                    </tr>
                </c:forEach>
            </table>
        </form>
        <hr/>
        <br/>
        <hr/>
        <h2>팀 공지</h2>
        <button type="button" id="teamVote" class="on">진행중인 투표</button>
        <button type="button" id="teamNotice">팀 공지 보기</button>
        <section class="team-enter">
        </section>
    </div>
    <div id="modal">
        <div id="modal-insert-notice" style="display: none;">
            <label for="notisntncSj">공지 제목</label> <br/>
            <input type="text" name="notisntncSj" id="notisntncSj"> <br/>
            <label for="notisntncCn">공지 내용</label><br/>
            <textarea name="notisntncCn" id="notisntncCn" cols="30" rows="10"></textarea><br/>
            <button type="button" id="insertNotice">등록</button>
            <button type="button" id="modifyNotice" style="display: none;">수정</button>
        </div>
        <div id="modal-insert-vote" style="display: none;">
            <form id="inputVoteRegister" method="post">
                <label for="voteRegistTitle">투표 제목</label> <br/>
                <input type="text" name="voteRegistTitle" id="voteRegistTitle"> <br/>
                <div class="option-wrapper">
                    <div class="option-header">
                        <span>옵션 추가</span>
                        <button id="add-option">+ 항목 추가하기</button>
                    </div>
                    <div class="option-body">
                        <div class="option">
                            <input type="text" name="voteOptionContents" id="voteOptionContents0">
                        </div>
                    </div>
                </div>
                <label>투표 기간</label> <br/>
                <input type="date" name="voteRegistStartDate" id="voteRegistStartDate" placeholder="시작날짜" readonly>
                <br/>
                <input type="date" name="voteRegistEndDate" id="voteRegistEndDate" placeholder="종료날짜"> <br/>
            </form>
            <button type="button" id="inputVoteRegisterBtn">확인</button>
            <button type="button" class="cancel">취소</button>
        </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        const emplId = "${CustomUser.employeeVO.emplId}";
        const emplNm = "${CustomUser.employeeVO.emplNm}";
        const emplDept = "${CustomUser.employeeVO.commonCodeDept}";

    </script>
    <script src="/resources/js/teamCommunity.js"></script>
</sec:authorize>
