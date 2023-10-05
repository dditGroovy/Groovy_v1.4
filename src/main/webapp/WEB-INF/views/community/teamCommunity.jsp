<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                                            <input type="file" name="postFile" id="postFile">
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
                                        <div class="file-wrap">
                                            <c:choose>
                                                <c:when test="${sntncVO.uploadFileSn != null && sntncVO.uploadFileSn != 0.0}">
                                                    <a class="btn-free-white fileBox" href="/file/download/teamCommunity?uploadFileSn=${sntncVO.uploadFileSn}">
                                                        파일
                                                        <span>
                                                                ${sntncVO.uploadFileOrginlNm}
                                                        </span>
                                                        <span class="file-size"><fmt:formatNumber value="${sntncVO.uploadFileSize / 1024.0}" type="number"
                                                                          minFractionDigits="1" maxFractionDigits="1"/> KB</span>
                                                    </a>

                                                </c:when>
                                                <c:otherwise>
                                                    <span style="display: none">파일없음</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
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
                                                    <span class="recommendCnt enter-text">${recommendCnt.value} Likes                                                                                                                                                                                                              </span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                        <div class="answer-area">
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
                                    <div class="answer-detail-wrap">
                                        <div class="my-answer">
                                            <img src="/uploads/profile/${CustomUser.employeeVO.proflPhotoFileStreNm}" alt="profileImage"
                                                 class="thum"/>
                                            <textarea class="answerCn" placeholder="댓글을 입력하세요"></textarea>
                                            <button class="inputAnswer btn btn-free-blue">댓글 등록</button>
                                        </div>
                                        <div class="answer-list">
                                            <div class="answerBox"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            </c:forEach>
                        </div>
                    </div>
                </section>
                <section id="service">
                    <div class="service-wrap">
                       <div class="content-header">
                           <div class="btn-wrap">
                               <button type="button" id="teamVote" class="on btn btn-free-white service-btn">등록된 투표</button>
                               <button type="button" id="teamNotice" class="btn btn-free-white service-btn">팀 공지 보기</button>
                           </div>
                       </div>
                       <div class="content-body">
                           <div class="team-enter">
                           </div>
                       </div>
                    </div>
                </section>
            </div>
        </main>
    </div>
    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm insertVote">
            <div class="modal-top">
                <div class="modal-title"><i class="icon i-boxAdd i-3d"></i>투표 등록하기</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <form id="inputVoteRegister" method="post">
                    <ul class="modal-list">
                        <li class="form-data-list">
                            <label for="voteRegistTitle" class="modal-title">💭 투표 제목</label>
                            <input type="text" name="voteRegistTitle" id="voteRegistTitle" class="modal-input input-l">
                        </li>
                        <li class="form-data-list">
                            <div class="option-header">
                                <h5 class="modal-title">✅ 옵션 추가</h5>
                                <button id="add-option" class="btn">+ 항목 추가하기</button>
                            </div>
                            <div class="option-body">
                                <div class="option">
                                    <input type="text" name="voteOptionContents" id="voteOptionContents0" class="input-l modal-input">
                                </div>
                            </div>
                        </li>
                        <li class="form-data-list">
                            <label class="modal-title">📆 투표 기간</label>
                            <div class="input-date">
                                <input type="date" name="voteRegistStartDate" id="voteRegistStartDate" placeholder="시작날짜" readonly class="input-l modal-input">
                                <input type="date" name="voteRegistEndDate" id="voteRegistEndDate" placeholder="종료날짜" class="input-l modal-input">
                            </div>
                        </li>
                    </ul>
                </form>
            </div>
            <div class="modal-footer">
                <div class="btn-wrap">
                    <button id="cancel" class="btn btn-fill-wh-sm">취소</button>
                    <button id="inputVoteRegisterBtn" class="btn btn-fill-bl-sm">등록</button>
                </div>
            </div>
        </div>
        <div class="modal-layer card-df sm insertNotice">
            <div class="modal-top">
                <div class="modal-title"><i class="icon i-boxAdd i-3d"></i>공지 등록하기</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <ul class="modal-list">
                    <li class="form-data-list">
                        <label for="notisntncSj" class="modal-title">공지 제목</label>
                        <input type="text" name="notisntncSj" id="notisntncSj" class="modal-input input-l">
                    </li>
                    <li class="form-data-list">
                        <label for="notisntncCn" class="modal-title">공지 내용</label>
                        <textarea name="notisntncCn" id="notisntncCn" class="modal-input input-l"></textarea>
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <div class="btn-wrap">
                    <button class="close btn btn-fill-wh-sm">취소</button>
                    <button id="insertNotice" class="btn btn-fill-bl-sm">등록</button>
                    <button id="modifyNotice" class="btn btn-fill-bl-sm" style="display:none;">수정</button>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        const emplId = "${CustomUser.employeeVO.emplId}";
        const emplNm = "${CustomUser.employeeVO.emplNm}";
        const emplDept = "${CustomUser.employeeVO.commonCodeDept}";

    </script>
    <script src="/resources/js/teamCommunity.js"></script>
    <script src="/resources/js/modal.js"></script>
</sec:authorize>
