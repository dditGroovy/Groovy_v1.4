const modal = document.querySelector("#modal");
const post = document.querySelectorAll(".post");
const teamEnter = document.querySelector(".team-enter");
const notisntncSj = document.querySelector("#notisntncSj");
const notisntncCn = document.querySelector("#notisntncCn");
const teamVote = document.querySelector("#teamVote");
const inputVoteRegister = document.querySelector("#inputVoteRegister");
const voteRegistStartDate = document.querySelector("#voteRegistStartDate");
const voteRegistEndDate = document.querySelector("#voteRegistEndDate");
const addTeamNotice = document.querySelector("#addTeamNotice");
const insertNotice = document.querySelector("#insertNotice");
const modifyNotice = document.querySelector("#modifyNotice");
const options = document.querySelector(".options");
const serviceBtn = document.querySelectorAll(".service-btn");
let formData = undefined;
let num = 0;
let sntncEtprCode;
loadTeamVote();

function loadAnswerFn(sntncEtprCode, item) {
    $.ajax({
        url: "/teamCommunity/loadAnswer",
        type: "POST",
        data: {sntncEtprCode: sntncEtprCode},
        success: function (data) {
            let code = "";
            data.forEach(item => {
                code += `
                <div class="answer-list-item">
                    <img src="/uploads/profile/${item.proflPhotoFileStreNm}" class="answer-thum"/>
                    <div class="answer-empl-info">
                        <div class="info-top">
                            <h5 class="answer-empl-name">${item.answerWrtingEmplNm}</h5>
                            <p class="answer-date">${item.answerDate}</p>
                        </div>
                         <p class="empl-answerCn">${item.answerCn}</p>
                    </div>
                </div>`
            })
            item.querySelector(".answerBox").innerHTML = code;

        },
        error: function (request, status, error) {
            console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
        }
    })
}

/*  포스트에서 기능 */
post.forEach((item) => {
    item.addEventListener("click", function (e) {
        // e.preventDefault();
        const target = e.target;
        const sntncEtprCode = `${item.getAttribute("data-idx")}`;
        const sntncCnbox = item.querySelector(".sntncCn");
        let recommendVo = {
            "sntncEtprCode": sntncEtprCode
        }
        let sntncVO = {
            "sntncEtprCode": sntncEtprCode
        }
        /*  수정 삭제 버튼 */
        if (document.querySelector(".more")) {
            if (target.classList.contains("more")) {
                target.classList.add("on");
            } else if (target.closest(".more")) {
                target.closest(".more").classList.add("on");
            } else {
                document.querySelector(".more").classList.remove("on");
            }
        }
        /*  좋아요 */
        if (target.classList.contains("unRecommendBtn")) {
            const btn = item.querySelector(".unRecommendBtn");
            $.ajax({
                url: "/teamCommunity/inputRecommend",
                type: "POST",
                data: sntncVO,
                dataType: "text",
                success: function (data) {
                    const like = item.querySelector(".recommendCnt");
                    like.innerText = data + " Likes";
                    if (btn.classList.contains("unRecommendBtn")) {
                        btn.classList.remove("unRecommendBtn");
                        btn.classList.add("recommendBtn");
                    }
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
                }
            })
            return;
        }
        /*  좋아요 취소 */
        if (target.classList.contains("recommendBtn")) {
            const btn = item.querySelector(".recommendBtn");
            $.ajax({
                url: "/teamCommunity/deleteRecommend",
                type: "POST",
                data: recommendVo,
                dataType: "text",
                success: function (data) {
                    const like = item.querySelector(".recommendCnt");
                    like.innerText = data + " Likes";
                    if (btn.classList.contains("recommendBtn")) {
                        btn.classList.remove("recommendBtn");
                        btn.classList.add("unRecommendBtn");
                    }
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
                }
            })
            return;
        }
        /*  포스트 수정  */
        if (target.classList.contains("modifyBtn")) {

            const content = sntncCnbox.innerText;
            const textArea = document.createElement("textarea");
            textArea.classList = "modifySntncCn";
            textArea.value = content;

            const saveBtn = document.createElement("button");
            saveBtn.classList = "saveMoidfyBtn";
            saveBtn.innerText = "수정";

            sntncCnbox.innerHTML = "";
            sntncCnbox.appendChild(textArea);
            sntncCnbox.appendChild(saveBtn);
        }
        if (target.classList.contains("saveMoidfyBtn")) {
            const modisntncCn = document.querySelector(".modifySntncCn").value;
            sntncVO.sntncCn = modisntncCn;
            $.ajax({
                url: "/teamCommunity/modifyPost",
                type: "PUT",
                data: JSON.stringify(sntncVO),
                contentType: "application/json",
                dataType: "text",
                success: function (data) {
                    item.querySelector(".modifySntncCn").remove();
                    sntncCnbox.innerText = sntncVO.sntncCn;
                    target.remove();
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
                }
            })
        }
        /*  포스트 삭제  */
        if (target.classList.contains("deleteBtn")) {
            $.ajax({
                url: "/teamCommunity/deletePost",
                type: "Delete",
                data: JSON.stringify({sntncEtprCode: sntncEtprCode}),
                contentType: 'application/json',
                success: function (data) {
                    item.remove();
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
                }
            })
        }

        /*  댓글 등록   */
        if (target.classList.contains("inputAnswer")) {
            const answerCnt = item.querySelector(".answerCnt")
            const answerContent = item.querySelector(".answerCn");
            const answerValue = answerContent.value;
            const answerVO = {
                "sntncEtprCode": sntncEtprCode,
                "answerCn": answerValue,
            }
            let postWriterId = target.closest(".post-card-footer").closest(".post-card").querySelector(".postWriterInfo").getAttribute("data-id")
            let subject = target.closest(".post-card-footer").closest(".post-card").querySelector(".sntncCn").innerText;
            if (answerValue !== "") {
                $.ajax({
                    url: "/teamCommunity/inputAnswer",
                    type: "POST",
                    data: JSON.stringify(answerVO),
                    contentType: "application/json",
                    dataType: "text",
                    success: function (data) {
                        answerCnt.innerText = data;
                        answerContent.value = "";
                        loadAnswerFn(sntncEtprCode, item);

                        //알림 보내기
                        $.get("/alarm/getMaxAlarm")
                            .then(function (maxNum) {
                                maxNum = parseInt(maxNum) + 1;

                                let url = '/teamCommunity';
                                let content = `<div class="alarmListBox">
                                                    <a href="${url}" class="aTag" data-seq="${maxNum}">
                                                        <div class="alarm-textbox">
                                                            <p>[<span>${subject}</span>]에
                                                            ${emplNm}님이 댓글을 등록하셨습니다.</p>
                                                        </div>
                                                    </a>
                                                    <button type="button" class="readBtn">읽음</button>
                                                </div>`;
                                let alarmVO = {
                                    "ntcnEmplId": postWriterId,
                                    "ntcnSn": maxNum,
                                    "ntcnUrl": url,
                                    "ntcnCn": content,
                                    "commonCodeNtcnKind": 'NTCN011'
                                };

                                //알림 생성 및 페이지 이동
                                $.ajax({
                                    type: 'post',
                                    url: '/alarm/insertAlarmTarget',
                                    data: alarmVO,
                                    success: function (rslt) {
                                        if (socket) {
                                            //알람번호,카테고리,url,보낸사람이름,받는사람아이디
                                            let msg = maxNum + ",answer," + url + "," + emplNm + "," + postWriterId + "," + subject;
                                            socket.send(msg);
                                        }
                                    },
                                    error: function (xhr) {
                                        console.log(xhr.status);
                                    }
                                });
                            })
                            .catch(function (error) {
                                console.log("최대 알람 번호 가져오기 오류:", error);
                            });
                    },
                    error: function (request, status, error) {
                        console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
                    }
                })
            }
        }


        /*  댓글 불러오기 */
        if (target.classList.contains("loadAnswer")) {
            !target.closest(".post-card").classList.contains(".post-card") ? target.closest(".post-card").classList.add("on") : target.closest(".post-card").classList.remove("on")
            loadAnswerFn(sntncEtprCode, item);
        }
    })
})

function loadTeamNotiFnc() {
    $.ajax({
        url: "/teamCommunity/loadTeamNoti",
        type: "POST",
        success: function (data) {
            let code = '<button type="button" class="btn btn-modal addBtn" id="addTeamNotice" data-name="insertNotice">+ 공지 추가하기</button>' +
                '<div class="notice-wrap">' +
                '   <div class="notice-list-wrap">';
            data.forEach(item => {
                code += `<div class="card card-df pd-32 accordion" id="${item.sntncEtprCode}">
                                <input type="checkbox" id="accordion-${item.sntncEtprCode}"/>
                                <label class="card-header" for="accordion-${item.sntncEtprCode}">
                                     <div class="accordion-header">
                                         <div class="notice-title-wrap">
                                            <span class="noti-title">${item.sntncSj}</span>
                                            <span class="noti-date">${item.sntncWrtingDate}</span>
                                        </div>
                                        
                                        <div class="btn-wrap">`;
                if (emplId == item.sntncWrtingEmplId) {
                    code += `
                                                <div class="edit-btn-wrap"><button type="button" class="notimodifyBtn editBtn btn btn-free-white">수정</button>
                                                <button type="button" class="notideleteBtn btn btn-free-white editBtn">삭제</button></div>
                                                `
                }
                code += ` <i class="icon i-arr-bt accordion-arrow"></i>
                                    </div>
                                    </div></label>
                             <div class="accordion-body">
                                         <p class="noti-content input-l">${item.sntncCn}</p>
                             </div>
                         </div>`;
            })
            code += '</div></div>';
            teamEnter.innerHTML = code;
        },
        error: function (request, status, error) {
            console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
        }
    })
}

/*  팀 공지 관련 */
document.querySelector("#teamNotice").addEventListener("click", () => {
    loadTeamNotiFnc();
})
teamEnter.addEventListener("click", function (e) {
    e.preventDefault();
    const target = e.target;
    if (target.classList.contains("btn-modal")) {
        const dataName = target.getAttribute("data-name");
        modalOpen(dataName);
    }

    if (target.classList.contains("accordion-header") || target.closest(".accordion-header")) {
        // 라벨 클릭 시 체크박스 체크/해제
        const label = target.closest('.card-header');
        label.addEventListener('click', function () {
            const checkbox = this.previousElementSibling;
            const checkboxes = document.querySelectorAll('input[id*="accordion"]');
            checkboxes.forEach(item => {
                item.checked = false;
            })
            checkbox.checked = !checkbox.checked;
        });
    }

    if (target.classList.contains("notimodifyBtn")) {
        const card = target.closest(".card");
        sntncEtprCode = target.closest(".card").id;
        modifyNotice.style.display = "block";
        insertNotice.style.display = "none";
        modalOpen("insertNotice");
        notisntncSj.value = card.querySelector(".noti-title").innerText;
        notisntncCn.value = card.querySelector(".noti-content").innerHTML;
    }
    if (target.id == "addTeamNotice") {
        modifyNotice.style.display = "none";
        insertNotice.style.display = "block";
        notisntncSj.value = "";
        notisntncCn.value = "";
    }
    if (target.classList.contains("notideleteBtn")) {
        const card = target.closest(".card");
        sntncEtprCode = target.closest(".card").id;
        $.ajax({
            url: "/teamCommunity/deletePost",
            type: "Delete",
            data: JSON.stringify({sntncEtprCode: sntncEtprCode}),
            contentType: 'application/json',
            success: function (data) {
                loadTeamNotiFnc();
            },
            error: function (request, status, error) {
                console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
            }
        })
    }
    if (target.classList.contains("option-btn")) {
        const checkBox = target.nextElementSibling;
        const voteRegistNo = target.closest(".card").id;
        const voteOptionNo = checkBox.id;
        const voteOptionVO = {
            voteRegistNo: voteRegistNo,
            voteOptionNo: voteOptionNo
        };
        if (target.classList.contains("on")) {
            $.ajax({
                url: "/teamCommunity/deleteVote",
                type: "Delete",
                data: JSON.stringify(voteOptionVO),
                contentType: "application/json",
                dataType: "text",
                success: function (data) {
                    if (data == "success") {
                        checkBox.checked = false;
                        target.classList.remove("on");
                        let totalCntElement = $('.option-total[data-target="' + voteOptionNo + '"]');
                        let currentTotalCnt = parseInt(totalCntElement.text());
                        totalCntElement.text(currentTotalCnt - 1);
                    } else {
                        console.error('투표 업데이트에 실패했습니다.');
                    }
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
                }
            })
            return false;
        } else {
            $.ajax({
                url: "/teamCommunity/inputVote",
                type: "POST",
                data: JSON.stringify(voteOptionVO),
                contentType: "application/json",
                dataType: "text",
                success: function (data) {
                    if (data == "success") {
                        checkBox.checked = true;
                        target.classList.add("on");
                        let totalCntElement = $('.option-total[data-target="' + voteOptionNo + '"]');
                        let currentTotalCnt = parseInt(totalCntElement.text());
                        totalCntElement.text(currentTotalCnt + 1);
                    } else {
                        console.error('투표 업데이트에 실패했습니다.');
                    }
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
                }
            })
        }
    }
    if (target.classList.contains("endBtn")) {
        const card = target.closest(".card");
        voteRegistNo = target.closest(".card").id;
        $.ajax({
            url: "/teamCommunity/updateVoteRegistAt",
            type: "Put",
            data: voteRegistNo,
            contentType: "text/plain",
            success: function (data) {
                window.location.href = "/teamCommunity"
            },
            error: function (request, status, error) {
                console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
            }
        })
    }
});
insertNotice.addEventListener("click", () => {
    const notiSntncVO = {
        sntncSj: notisntncSj.value,
        sntncCn: notisntncCn.value,
    }
    $.ajax({
        url: "/teamCommunity/inputTeamNoti",
        type: "POST",
        data: JSON.stringify(notiSntncVO),
        contentType: "application/json",
        dataType: "text",
        success: function (data) {
            notisntncSj.value = "";
            notisntncCn.value = "";
            Swal.fire({
                text: '공지 등록 완료!',
                showConfirmButton: false,
                timer: 1500
            })
            modalClose();
            loadTeamNotiFnc();

            $.get("/alarm/getMaxAlarm")
                .then(function (maxNum) {
                    maxNum = parseInt(maxNum) + 1;

                    let url = '/teamCommunity';
                    let content = `<div class="alarmListBox">
                                                    <a href="${url}" class="aTag" data-seq="${maxNum}">
                                                    <h1>[팀 커뮤니티]</h1>
                                                    <div class="alarm-textbox">
                                                        <p>${emplNm}님이 팀 공지사항을 등록하셨습니다.</p>
                                                    </div>
                                                    </a>
                                                    <button type="button" class="readBtn">읽음</button>
                                                </div>`;
                    let alarmVO = {
                        "ntcnSn": maxNum,
                        "ntcnUrl": url,
                        "ntcnCn": content,
                        "commonCodeNtcnKind": 'NTCN012',
                        "dept": emplDept
                    };
                    //알림 생성 및 페이지 이동
                    $.ajax({
                        type: 'post',
                        url: '/alarm/insertAlarm',
                        data: alarmVO,
                        success: function () {
                            if (socket) {
                                let msg = maxNum + ",teamNoti," + url + "," + emplNm + "," + emplDept;
                                socket.send(msg);
                            }
                        },
                        error: function (xhr) {
                            console.log(xhr.status);
                        }
                    });
                })
                .catch(function (error) {
                    console.log("최대 알람 번호 가져오기 오류:", error);
                });
        },
        error: function (request, status, error) {
            console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
        }
    })
})
modifyNotice.addEventListener("click", () => {
    const notiSntncVO = {
        sntncEtprCode: sntncEtprCode,
        sntncSj: notisntncSj.value,
        sntncCn: notisntncCn.value
    }
    $.ajax({
        url: "/teamCommunity/modifyTeamNoti",
        type: "PUT",
        data: JSON.stringify(notiSntncVO),
        contentType: "application/json",
        dataType: "text",
        success: function (data) {
            notisntncSj.value = "";
            notisntncCn.value = "";
            modalClose();
            loadTeamNotiFnc();
        },
        error: function (request, status, error) {
            console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
        }
    })
})

/*  투표 관련   */

function loadTeamVote() {
    $.ajax({
        url: "/teamCommunity/loadAllRegistVote",
        type: "GET",
        success: function (data) {

            let code = '<button type="button" id="addVote" class="btn btn-modal addBtn" data-name="insertVote">+ 투표 등록하기</button>' +
                '<div class="vote-wrap"><div class="vote-list-wrap">';
            data.forEach(item => {
                code += `<div class="card card-df accordion ${item.voteRegistAt == 0 ? 'ongoing' : 'completed'}" id="${item.voteRegistNo}">
                                     <input type="checkbox" id="accordion-${item.voteRegistNo}">
                                     <label class="card-header" for="accordion-${item.voteRegistNo}">
                                         <div class="vote-header">
                                            <div class="vote-info">
                                                <div class="header-left">
                                                    <span class="badge ${item.voteRegistAt == 0 ? 'ongoing' : 'completed'}">
                                                        ${item.voteRegistAt == 0 ? '진행 중' : '종료'}
                                                    </span>
                                                     <h3 class="voteTitle">${item.voteRegistTitle}</h3>
                                                 </div>
                                                 <div class="header-right">
                                                     <p class="voteDate">
                                                        <span class="voteRegistStartDate">${item.voteRegistStartDate}</span>~
                                                        <span class="voteRegistEndDate">${item.voteRegistEndDate}</span>
                                                    </p>
                                                    <button class="endBtn btn btn-free-blue ${item.voteRegistEmpId == emplId ? 'on' : ''}" ${item.voteRegistAt == 1 ? 'disabled' : ''}>투표 종료</button>
                                                </div>
                                             </div>
                                             <div class="vote-service">
                                                 <div class="btnWrapper">
                                             <div class="options">`;
                item.voteOptionList.forEach(item => {
                    code += `
                                                    <div>
                                                        <button type="button" class="option-btn btn btn-free-white ${item.votedAt == 1 ? 'on' : ''}"  >${item.voteOptionContents}</button>
                                                        <input type="checkbox" name="${item.voteOptionNo}" id="${item.voteOptionNo}" class="optionChkBox" style="display:none;" ${item.votedAt == 1 ? 'checked' : ''}>
                                                    </div>`
                });
                code += `
                                             </div>
                                         </div>
                                            </div>
                                         </div>
                                     </label>
                                     <div class="card-body">
                                        <div class="vote-result">`;
                item.voteOptionList.forEach(item => {
                    code += `<div class="vote-option">
                                            <span class="option-title">${item.voteOptionContents}</span>
                                            <span class="option-total" data-target="${item.voteOptionNo}">${item.voteTotalCnt}</span>
                                        </div>`;
                })
                code += `            </div>
                                     </div>
                             </div>`
            })
            teamEnter.innerHTML = code;

            /* 투표 종료시 인풋 disabled   */
            document.querySelectorAll(".card").forEach(item => {
                const badge = item.querySelector(".badge");
                const options = item.querySelectorAll(".option-btn");

                if (badge) {
                    if (badge.classList.contains("completed")) {
                        options.forEach(option => {
                            option.disabled = true;
                        })
                    }
                }
            });

        },
        error: function (request, status, error) {
            console.log("code:" + request.status + "n" + "message:" + request.responseText + "n" + "error:" + error);
        }
    })
}

teamVote.addEventListener("click", () => {
    loadTeamVote();
})
/*   새 투표 등록   */
inputVoteRegister.addEventListener("submit", e => {
    e.preventDefault();
})
/*  모달  */
modal.addEventListener("click", e => {
    const target = e.target;
    if (target.id == "add-option") {
        if (num < 4) {
            const newDiv = document.createElement("div");
            newDiv.classList = "option";

            const newInput = document.createElement("input");
            const optionBody = document.querySelector(".option-body");

            ++num;
            newInput.type = "text";
            newInput.id = "voteOptionContents" + num;
            newInput.name = `voteOptionContents`;
            newInput.classList.add("input-l");
            newInput.classList.add("modal-input");

            const newBtn = document.createElement("button");
            newBtn.type = "button";
            newBtn.classList = "optiondelete btn";

            newBtn.innerHTML = '<i class="icon i-close"></i>';
            newDiv.append(newInput);
            newDiv.append(newBtn);
            optionBody.append(newDiv);
        } else {
            Swal.fire({
                text: '옵션은 최대 5개까지 추가할 수 있습니다',
                showConfirmButton: false,
                timer: 1500
            })
            document.querySelector("#add-option").disabled = true
        }
    }
    if (target.classList.contains("optiondelete")) {
        const deleteTarget = target.closest(".option");
        --num;
        deleteTarget.remove();

    }
    if (num < 5) {
        document.querySelector("#add-option").disabled = false;
    }
    if (target.id == "inputVoteRegisterBtn") {
        formData = new FormData(inputVoteRegister);
        const voteOptionNames = [];
        const options = formData.getAll("voteOptionContents");
        options.forEach(option => {
            voteOptionNames.push(option);
        })
        formData.append("voteOptionNames", voteOptionNames);

        $.ajax({
            url: '/teamCommunity/inputVoteRegist',
            type: 'post',
            data: formData,
            contentType: false,
            processData: false,
            cache: false,
            success: function (data) {
                const inputs = inputVoteRegister.querySelectorAll("input");
                inputs.forEach(item => {
                    item.value = "";
                    Swal.fire({
                        text: '투표 등록 완료!',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    modalClose();
                    loadTeamVote()
                })
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        });


    }
})
/*document.querySelectorAll(".card").forEach(item => {
    const badge = item.querySelector(".badge");
    const options = item.querySelectorAll(".option-btn");

    if(badge.classList.contains("completed")){
        console.log(badge);
        options.forEach(option => {
            option.disabled = true;
        })
    }
})*/
/* 오늘 자동으로 인풋*/
voteRegistStartDate.valueAsDate = new Date();
const today = new Date().toISOString().split("T")[0];
voteRegistEndDate.setAttribute("min", today);

/*  파일 이름   */
const postFile = document.querySelector("#postFile");
const originName = document.querySelector("#originName");
postFile.addEventListener("change", function () {
    if (postFile.value.length) {
        originName.innerHTML = postFile.files[0].name;
    } else {
        originName.innerHTML = "";
    }
})

/*  서비스 눌렀을 때 */
serviceBtn.forEach(item => {
    item.addEventListener("click", () => {
        serviceBtn.forEach(btn => {
            btn.classList.remove("on");
        })
        item.classList.add("on");
    })
})