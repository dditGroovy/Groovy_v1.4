<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="${pageContext.request.contextPath}/resources/css/community/club.css" rel="stylesheet"/>

<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/teamCommunity" class="on">동호회</a></h1>
        <div class="sub-title">
            <h2 class="main-desc">그루비 사내 동호회를 소개합니다 &#x1F64C;</h2>
            <button id="proposalClb" class="btn btn-free-white btn-modal" data-name="requestClub"> 동호회 제안하기 <i
                    class="icon i-question"></i></button>
        </div>
    </header>
    <main>
        <div class="card-wrap">
            <c:forEach var="clubVO" items="${clubList}" varStatus="status">
                <div class="card card-df">
                    <a href="#" class="card-link btn-modal" data-target="${clubVO.clbEtprCode}" data-name="detailClub">
                        <div class="card-header">
                            <div class="card-thum"><img src="/resources/images/club/${clubVO.clbKind}.jpg"></div>
                        </div>
                        <div class="card-content">
                            <span class="club-kind badge badge-${status.count}">${clubVO.clbKind}</span>
                            <h2 class="club-name">${clubVO.clbNm}</h2>
                            <p class="club-dc">
                                    ${clubVO.clbDc}
                            </p>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </main>
</div>

<div id="modal" class="modal-dim">
    <div class="dim-bg"></div>
    <div class="modal-layer card-df sm requestClub">
        <div class="modal-top">
            <%--            <div id="modal-proposal">--%>
            <h3 class="modal-title">동호회 제안하기</h3>
            <button type="button" class="modal-close btn close">
                <i class="icon i-close close">X</i>
            </button>
        </div>
        <div class="modal-container">
            <form action="${pageContext.request.contextPath}/club/inputClub" method="post" id="proposal">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <ul>
                    <li>
                        <h5 class="club-title">1. 희망 동호회 종류</h5>
                        <div><input type="text" name="clbKind" id="clbKind" class="data-box input-l modal-input"
                                    placeholder="ex) 독서 "></div>
                    </li>
                    <li>
                        <h5 class="club-title">2. 동호회 이름</h5>
                        <div><input type="text" name="clbNm" id="clbNm" class="data-box input-l modal-input"
                                    placeholder="희망하는 동호회 이름을 적어 주세요."></div>
                    </li>
                    <li>
                        <h5 class="club-title">3. 동호회 설명</h5>
                        <div>
                            <textarea name="clbDc" id="clbDc" class="data-box input-l modal-input"
                                      placeholder="동호회에 대한 설명을 적어 주세요. &#10;&#10; - 동호회 목적 &#10; - 운영 방식"></textarea>
                        </div>
                    </li>
                    <li>
                        <h5 class="club-title">4. 동호회 정원</h5>
                        <div><input type="number" name="clbPsncpa" id="clbPsncpa" class="data-box input-l modal-input">
                        </div>
                    </li>
                </ul>
                <div class="modal-description">
                    <p>✅ 동호회에 대한 전반적인 책임은 회사에서 지지 않습니다.</p>
                    <p>👉 회사 안에서 이루어지는 동호회이오니 문제가 될만한 언행은 삼가주시길 바랍니다.</p>
                    <p>👉 담당자 검토 후 승인 처리까지 4~5일 소요됩니다.</p>
                </div>
            </form>
        </div>
        <div class="modal-footer btn-wrapper">
            <button type="button" class="btn btn-fill-wh-sm close">취소</button>
            <button id="proposalBtn" class="btn btn-fill-bl-sm">제안하기</button>
        </div>
    </div>
    <div class="modal-layer card-df sm detailClub">
        <div class="modal-top">
            <h3 class="modal-title">동호회 상세보기</h3>
            <button type="button" class="modal-close btn close">
                <i class="icon i-close close">X</i>
            </button>
        </div>
        <div class="modal-container">
            <div class="modal-thum">
                <img src="" id="modalImg">
            </div>
            <div class="modal-content">
                <span class="badge club-kind club-cate"></span>
                <h2 class="club-name"></h2>
                <p class="club-dc"></p>
                <p class="club-charId"></p>
            </div>
        </div>
        <div class="modal-footer btn-wrapper">
            <div class="club-details">
                <div class="thum-wrap">
                    <img src="" class="thum" id="club-charMn-thum">
                </div>
                <div class="club-detail">
                    <h4 class="club-charMn"></h4>
                    <div class="mbrCnt">
                        <span class="currentMbr"></span>
                        /
                        <span class="totalMbr"></span>
                    </div>
                </div>
            </div>
            <%--<button type="button" id="chat" class="btn btn-fill-wh-sm">문의하기</button>--%>
            <button type="button" id="join" class="btn btn-fill-bl-sm">가입하기</button>
            <button type="button" id="leave" class="btn btn-fill-bl-sm">탈퇴하기</button>
        </div>
    </div>
</div>


<script src="${pageContext.request.contextPath}/resources/js/modal.js"></script>
<script>
    const form = document.querySelector("#proposal");
    const proposalBtn = document.querySelector("#proposalBtn");
    const modalLink = document.querySelectorAll(".card-link");
    const clubTitle = document.querySelector(".modal-title");
    const clubCate = document.querySelector("#modal .club-cate");
    const clubName = document.querySelector("#modal .club-name");
    const clubDc = document.querySelector("#modal .club-dc");
    const joinBtn = document.querySelector("#join");
    const leaveBtn = document.querySelector("#leave");
    const modal = document.querySelector("#modal");
    const textArea = document.querySelector("#clbDc");
    const clbNm = document.querySelector("#clbNm");
    const charMn = document.querySelector("#modal .club-charMn");
    const charMnThum = document.querySelector("#modal #club-charMn-thum");
    const currentMbr = document.querySelector("#modal .currentMbr");
    const totalMbr = document.querySelector("#modal .totalMbr");
    let clbEtprCode;

    const postFile = document.querySelector("#postFile");
    const originName = document.querySelector("#originName");
    form.addEventListener("submit", e => {
        e.preventDefault();
    })
    proposalBtn.addEventListener("click", () => {
        Swal.fire({
            text: "제안하시겠습니까?",
            showCancelButton: true,
            confirmButtonColor: '#5796F3FF',
            cancelButtonColor: '#e1e1e1',
            confirmButtonText: '확인',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            } else {
                return false;
            }
        })
        return false;
    })
    const close = document.querySelectorAll(".close");
    close.forEach(item => {
        item.addEventListener("click", () => {
            const modalCommon = document.querySelectorAll(".modal-common")
            modalCommon.forEach(item => item.classList.remove("on"))
            document.querySelector("#modal").style.display = "none";
        })
    })
    modalLink.forEach(item => {
        item.addEventListener("click", e => {
            e.preventDefault();
            const target = e.target;
            clbEtprCode = item.getAttribute("data-target");
            $.ajax({
                url: `/club/\${clbEtprCode}`,
                type: "GET",
                success: function (data) {
                    $("#modalImg").prop("src", `/resources/images/club/\${data[0].clbKind}.jpg`)
                    clubName.innerText = data[0].clbNm;
                    clubDc.innerText = data[0].clbDc;
                    clubCate.innerText = data[0].clbKind;
                    charMn.innerText = data[0].clbChirmnEmplNm;
                    currentMbr.innerText = data[0].clubMbrCnt;
                    totalMbr.innerText = data[0].clbPsncpa;
                    charMnThum.setAttribute("src",`/uploads/profile/\${data[0].proflPhotoFileStreNm}`)
                    if (data[0].joinChk == 1) {
                        joinBtn.style.display = "none";
                        leaveBtn.style.display = "block";
                    } else {
                        joinBtn.style.display = "block";
                        leaveBtn.style.display = "none";
                    }
                }
            })
        })
    })
    modal.addEventListener("click", (e) => {
        const target = e.target;
        if (target.id == "join") {
            const totalMbrIs = totalMbr.innerText;
            const currentMbrIs = currentMbr.innerText;

            // 가입
            if(currentMbrIs != totalMbrIs) {
                $.ajax({
                    url: "/club/inputClubMbr",
                    type: "POST",
                    data: JSON.stringify({clbEtprCode: clbEtprCode}),
                    contentType: 'application/json',
                    success: function (data) {
                        currentMbr.innerText = parseInt(currentMbrIs) + 1;
                        joinBtn.style.display = "none";
                        leaveBtn.style.display = "block";

                        Swal.fire({
                            text: '가입을 환영합니다',
                            showConfirmButton: false,
                            timer: 1500
                        })

                    },
                    error: function (request, status, error) {
                        console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                    }
                })
                return false;
            }else {
                Swal.fire({
                    html: '정원을 초과하여 가입이 불가합니다.<br/> 가입을 원하시는 경우 총무팀에 문의해주세요!',
                    showConfirmButton: false,
                    timer: 1500
                })
            }
        }
        // 탈퇴
        if (target.id == "leave") {
            const currentMbrIs = currentMbr.innerText;
            $.ajax({
                url: "/club/updateClubMbrAct",
                type: "PUT",
                data: JSON.stringify({clbEtprCode: clbEtprCode}),
                contentType: 'application/json',
                success: function (data) {
                    console.log(data);
                    currentMbr.innerText = parseInt(currentMbrIs) - 1;
                    joinBtn.style.display = "block";
                    leaveBtn.style.display = "none";

                    Swal.fire({
                        text: '다음에 또 만나요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            })
            return false;
        }
    })
</script>
