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
                    <a href="#" class="card-link" data-target="${clubVO.clbEtprCode}">
                        <div class="card-header">
                            <div class="card-thum"><img src="/resources/images/club/club-coffee.png"></div>
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
<div id="modal">
    <div class="modal-container">
        <%--            <div id="modal-proposal"></div>--%>
        <div id="modal-clubDetail" class="modal-common on">
            <div class="modal-header">
                <h4 class="modal-title"></h4>
                <button class="close">&times;</button>
            </div>
            <div class="modal-body">
                <div class="modal-thum">

                </div>
                <div class="modal-content">
                    <span class="badge club-cate"></span>
                    <h2 class="club-name"></h2>
                    <p class="club-dc"></p>
                    <p class="club-charId"></p>
                </div>
            </div>
            <div class="modal-footer">
                <button id="chat">문의하기</button>
                <button id="join">가입하기</button>
                <button id="leave">탈퇴하기</button>

            </div>
        </div>
    </div>
</div>

<div id="modal-ㄷㅂ" class="modal-dim">
    <div class="dim-bg"></div>
    <div class="modal-layer card-df sm requestClub">
        <div class="modal-top">
            <%--            <div id="modal-proposal">--%>
            <h3 class="modal-title">동호회 제안하기</h3>
            <button type="button" class="modal-close btn js-modal-close">
                <i class="icon i-close close">X</i>
            </button>
        </div>
        <div class="modal-container">
            <form action="${pageContext.request.contextPath}/club/inputClub" method="post" id="proposal">
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
                        <div><input type="text" name="clbPsncpa" id="clbPsncpa" class="data-box input-l modal-input">
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
    const chatBtn = document.querySelector("#chat");
    const joinBtn = document.querySelector("#join");
    const leaveBtn = document.querySelector("#leave");
    const modal = document.querySelector("#modal");
    const textArea = document.querySelector("#clbDc");
    const clbNm = document.querySelector("#clbNm");
    let clbEtprCode;


    /*/!* 이모지 처리   *!/
    function containsWindowsEmoji(text) {
        const windowsEmojiRegex = /[\uD800-\uDBFF][\uDC00-\uDFFF]/;
        return windowsEmojiRegex.test(text);
    }
    function convertImojiToUnicode(text) {
        const emojiRegex = /([\u2700-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD10-\uDDFF])/g;
        const emojis = text.match(emojiRegex);

        if (!emojis) {
            return text;
        }

        return emojis.map(function(match) {
            if (match.length === 2) {
                const codePoint1 = match.charCodeAt(0).toString(16).toUpperCase().padStart(4, '0');
                const codePoint2 = match.charCodeAt(2).toString(16).toUpperCase().padStart(4, '0');
                return '\\u{' + codePoint1 + '}' + '\\u{' + codePoint2 + '}';
            } else {
                return '\\u{' + match.codePointAt(0).toString(16).toUpperCase().padStart(4, '0') + '}';
            }
        }).join('');
    }*/
    form.addEventListener("submit", e => {
        e.preventDefault();
    })
    document.querySelector("#proposalClb").addEventListener("click", () => {
        document.querySelector("#modal-proposal").style.display = "block";
    })
    proposalBtn.addEventListener("click", () => {
        form.submit();
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
                    console.log(data);
                    clubTitle.innerText = data[0].clbNm;
                    clubName.innerText = data[0].clbNm;
                    clubDc.innerText = data[0].clbDc;
                    document.querySelector("#modal").style.display = "flex";
                    document.querySelector("#modal-clubDetail").classList.add("on");
                    if (data[0].joinChk == 1) {
                        chatBtn.style.display = "none";
                        joinBtn.style.display = "none";
                        leaveBtn.style.display = "block";
                    } else {
                        chatBtn.style.display = "block";
                        joinBtn.style.display = "block";
                        leaveBtn.style.display = "none";
                    }
                }
            })
        })
    })
    modal.addEventListener("click", (e) => {
        const target = e.target;
        console.log(target);
        if (target.id == "join") {
            $.ajax({
                url: "/club/inputClubMbr",
                type: "POST",
                data: JSON.stringify({clbEtprCode: clbEtprCode}),
                contentType: 'application/json',
                success: function (data) {
                    console.log(data);
                    chatBtn.style.display = "none";
                    joinBtn.style.display = "none";
                    leaveBtn.style.display = "block";
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            })
            return false;
        }
        if (target.id == "leave") {
            $.ajax({
                url: "/club/updateClubMbrAct",
                type: "PUT",
                data: JSON.stringify({clbEtprCode: clbEtprCode}),
                contentType: 'application/json',
                success: function (data) {
                    console.log(data);
                    chatBtn.style.display = "block";
                    joinBtn.style.display = "block";
                    leaveBtn.style.display = "none";
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            })
            return false;
        }
    })
</script>
