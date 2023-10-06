
let jobProgressVO;

//들어온 업무 요청
document.querySelector("#receive-job").addEventListener("click", (event) => {
    const target = event.target;
    let jobNo = null;

    if (target.classList.contains("receiveJob")) {
        jobNo = target.getAttribute("data-seq");
    } else if (target.closest(".receiveJob")) {
        jobNo = target.closest(".receiveJob").getAttribute("data-seq");
    }

    if (jobNo !== null) {
        event.preventDefault();
        /*openModal("#modal-receive-job");*/
        let checkboxes = document.querySelectorAll(".receive-kind");

        checkboxes.forEach(checkbox => {
            checkbox.checked = false;
        });

        $.ajax({
            type: 'get',
            url: '/job/getReceiveJobByNo?jobNo=' + jobNo,
            success: function (rslt) {
                document.querySelector(".receive-sj").innerText = rslt.jobSj;
                document.querySelector(".receive-cn").innerText = rslt.jobCn;
                document.querySelector(".receive-begin").innerText = rslt.jobBeginDate;
                document.querySelector(".receive-close").innerText = rslt.jobClosDate;
                document.querySelector(".receive-request").innerText = rslt.jobRequstEmplNm;
                let kind = rslt.commonCodeDutyKind;

                checkboxes.forEach(checkbox => {
                    checkbox.disabled = true;
                    if (checkbox.value === kind) {
                        checkbox.checked = true;
                    }
                });

                jobProgressVO = {
                    "jobNo": jobNo
                };
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        });
    }
});

let jobRejects = document.querySelectorAll(".jobReject");
jobRejects.forEach(jobReject => {
    jobReject.addEventListener("click", (e) => {
        let jobNo = e.target.parentNode.previousElementSibling.getAttribute("data-seq");
        jobProgressVO = {
            "commonCodeDutySttus": "거절",
            "jobNo": jobNo
        }
        rejectOrAgree(jobProgressVO);
    });
});

let jobAgrees = document.querySelectorAll(".jobAgree");
jobAgrees.forEach(jobAgree => {
    jobAgree.addEventListener("click", (e) => {
        let jobNo = e.target.parentNode.previousElementSibling.getAttribute("data-seq");
        jobProgressVO = {
            "commonCodeDutySttus": "승인",
            "jobNo": jobNo
        }
        rejectOrAgree(jobProgressVO);
    });
});


//요청 받은 업무 목록
document.querySelector(".new-request").addEventListener("click", (event) => {
    const target = event.target;
    let jobNo = null;

    if (target.classList.contains("receiveJob")) {
        jobNo = target.getAttribute("data-seq");
    } else if (target.closest(".receiveJob")) {
        jobNo = target.closest(".receiveJob").getAttribute("data-seq");
    }

    if (jobNo !== null) {
        event.preventDefault();
        let checkboxes = document.querySelectorAll(".receive-kind-box");

        checkboxes.forEach(checkbox => {
            checkbox.checked = false;
        });

        $.ajax({
            type: 'get',
            url: '/job/getReceiveJobByNo?jobNo=' + jobNo,
            success: function (rslt) {
                document.querySelector("#receive-sj").innerText = rslt.jobSj;
                document.querySelector("#receive-cn").innerText = rslt.jobCn;
                document.querySelector("#receive-begin").innerText = rslt.jobBeginDate;
                document.querySelector("#receive-close").innerText = rslt.jobClosDate;
                let kind = rslt.commonCodeDutyKind;

                checkboxes.forEach(checkbox => {
                    checkbox.disabled = true;
                    if (checkbox.value === kind) {
                        checkbox.checked = true;
                    }
                });

                jobProgressVO = {
                    "jobNo": jobNo
                };
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        });
    }
});

document.querySelector("#reject").addEventListener("click", () => {
    jobProgressVO["commonCodeDutySttus"] = "거절"
    rejectOrAgree(jobProgressVO);
});

document.querySelector("#agree").addEventListener("click", () => {
    jobProgressVO["commonCodeDutySttus"] = "승인"
    rejectOrAgree(jobProgressVO);
});

document.querySelector("#rejectJob").addEventListener("click", () => {
    jobProgressVO["commonCodeDutySttus"] = "거절"
    rejectOrAgree(jobProgressVO);
});

document.querySelector("#agreeJob").addEventListener("click", () => {
    jobProgressVO["commonCodeDutySttus"] = "승인"
    rejectOrAgree(jobProgressVO);
});



//요청 상태 변경 함수(거절, 승인)
function rejectOrAgree(jobProgressVO) {
    $.ajax({
        type:'put',
        url:'/job/updateJobStatus',
        data: JSON.stringify(jobProgressVO),
        contentType: 'application/json; charset=utf-8',
        success: function () {
            location.href = "/job/main";
        },
        error: function (xhr) {
            console.log(xhr.status);
        }
    })
}

document.querySelector(".requestJob").addEventListener("click", () => {
    openModal("#modal-request-job");
});

//업무 요청하기(상세)
document.getElementById("request-job").addEventListener("click", (event) => {
    /*openModal("#modal-requestDetail-job");*/
    let jobNo;
    if (event.target.classList.contains("requestJobDetail")) {
        let checkboxes = document.querySelectorAll(".data-kind");
        checkboxes.forEach(checkbox => {
            checkbox.checked = false;
        });
        jobNo = event.target.getAttribute("data-seq");
    }else if (event.target.closest(".requestJobDetail")) {
        jobNo = event.target.closest(".requestJobDetail").getAttribute("data-seq");
    }
    $.ajax({
        type: 'get',
        url: '/job/getJobByNo?jobNo=' + jobNo,
        success: function (rslt) {
            document.querySelector(".data-sj").innerText = rslt.jobSj;
            document.querySelector(".data-cn").innerText = rslt.jobCn;
            document.querySelector(".data-begin").innerText = rslt.jobBeginDate;
            document.querySelector(".data-close").innerText = rslt.jobClosDate;
            let kind = rslt.commonCodeDutyKind;
            let checkboxes = document.querySelectorAll(".data-kind");
            checkboxes.forEach(checkbox => {
                if (checkbox.value === kind) {
                    checkbox.checked = true;
                }
            });
            let jobProgressVOList = rslt.jobProgressVOList;
            let code = ``;
            jobProgressVOList.forEach((jobProgressVO) => {
                code += `<span class="${jobProgressVO.commonCodeDutySttus}">
                                <span>${jobProgressVO.jobRecptnEmplNm}</span>
                                ${jobProgressVO.commonCodeDutySttus === '승인' ? `<span> | ${jobProgressVO.commonCodeDutyProgrs}</span>` : ''}
                         </span>`;
            });
            document.querySelector("#receiveBox").innerHTML = code;
        },
        error: function (xhr) {
            console.log(xhr.status);
        }
    });

});
let addJobs = document.querySelectorAll(".addJob");
addJobs.forEach(addJob => {
    addJob.addEventListener("click", () => {
        //신규 등록
        document.querySelector("#tab-new-request").addEventListener("click", () => {
            document.querySelector(".new-job").classList.remove("on");
            document.querySelector(".new-request").classList.add("on");
            document.querySelector(".modal-footer .tab-new-job").classList.remove("on");
            document.querySelector(".modal-footer .tab-new-request").classList.add("on");
        });
        //요청 받은 업무 목록
        document.querySelector("#tab-new-job").addEventListener("click", () => {
            document.querySelector(".new-request").classList.remove("on");
            document.querySelector(".new-job").classList.add("on");
            document.querySelector(".modal-footer .tab-new-job").classList.add("on");
            document.querySelector(".modal-footer .tab-new-request").classList.remove("on");

        });
    });
});

//신규 등록
document.querySelector("#regist").addEventListener("click", () => {
    let formData = new FormData(document.querySelector("#registNewJob"));
    let requiredList = ["sj", "cn", "date-begin", "date-close"];
    let validation = true;

    requiredList.forEach((required) => {
        let req = document.getElementById(required);
        if (req.value.trim() === "") {
            validation = false;
        }
    });

    if (!validation) {
        // alert("모든 값을 입력해주세요.");
        Swal.fire({
            text: '모든 값을 입력해주세요',
            showConfirmButton: false,
            timer: 1500
        })
    }

    $.ajax({
        url: '/job/insertJob',
        type: 'post',
        data: formData,
        contentType: false,
        processData: false,
        cache: false,
        success: function() {
            location.href = "/job/main";
        },
        error: function(xhr) {
            console.log(xhr.status);
        }
    });
})

let progressList = document.querySelectorAll(".progress");
let myJobs = document.querySelectorAll(".myJob");
let requestId = document.querySelector("#request-data");
myJobs.forEach(myJob => {
    myJob.addEventListener("click", (event)=> {
        confirmBtn.style.display = "none";
        document.querySelector(".send-empl").style.display = "block";
        let kindList = document.querySelectorAll(".kind-data");
        let inputList = document.querySelectorAll(".jobDetail input");
        let target = event.target;

        kindList.forEach(kind => {
            kind.checked = false;
        });
        progressList.forEach(progress => {
            progress.checked = false;
        });
        inputList.forEach(input => {
            input.setAttribute("readOnly", true);
        })

        if (target.classList.contains("todoCard")) {
            jobNo = target.getAttribute("data-seq");
        } else if (target.closest(".todoCard")) {
            jobNo = target.closest(".todoCard").getAttribute("data-seq");
        }
        document.querySelector("#modify").style.display = "block";
        if (jobNo !== null) {
            $.ajax({
                type: 'get',
                url: `/job/getJobByNoAndId?jobNo=${jobNo}`,
                success: function (rslt) {
                    document.querySelector("#sj-data input").value = rslt.jobSj;
                    document.querySelector("#cn-data input").value = rslt.jobCn;
                    document.querySelector("#begin-data input").value = rslt.jobBeginDate;
                    document.querySelector("#close-data input").value = rslt.jobClosDate;
                    document.querySelector("#request-data").innerHTML = rslt.jobRequstEmplNm;
                    if (rslt.jobRequstEmplId == emplId) {
                        document.querySelector(".send-empl").style.display = "none";
                    }
                    kindList.forEach(kind => {
                        kind.disabled = true;
                        if (kind.value === rslt.commonCodeDutyKind) {
                            kind.checked = true;
                        }
                    });
                    progressList.forEach(progress => {
                        progress.disabled = true;
                        if (progress.value === rslt.jobProgressVOList[0].commonCodeDutyProgrs) {
                            progress.checked = true;
                        }
                    });
                    modifyBtn.setAttribute("data-id", rslt.jobRequstEmplId);
                    requestId.setAttribute("data-id", rslt.jobRequstEmplId);
                    document.querySelector("#confirm").setAttribute("data-seq", jobNo);
                   /* openModal("#modal-job-detail");*/
                },
                error: function (xhr) {
                    console.log(xhr.status);
                }
            });
        }
    });
});

//날짜 유효성 검사
function validateDate() {
    const begin = document.querySelector("#jobBeginDate");
    const close = document.querySelector("#jobClosDate");
    const beginDate = new Date(begin.value);
    const closeDate = new Date(close.value);

    validateCurrentDate(begin);
    validateCurrentDate(close);

    if (beginDate > closeDate) {
        Swal.fire({
            text: '끝 날짜는 시작 날짜보다 이전이 될 수 없습니다',
            showConfirmButton: false,
            timer: 1500
        });
        close.value = begin.value;
    }
}
function newValidateDate() {
    const begin = document.querySelector("#date-begin");
    const close = document.querySelector("#date-close");
    const beginDate = new Date(begin.value);
    const closeDate = new Date(close.value);

    validateCurrentDate(begin);
    validateCurrentDate(close);

    if (beginDate > closeDate) {
        Swal.fire({
            text: '끝 날짜는 시작 날짜보다 이전이 될 수 없습니다',
            showConfirmButton: false,
            timer: 1500
        });
        close.value = begin.value;
    }
}

function validateCurrentDate(input) {
    let currentDate = new Date();
    let inputDate = new Date(input.value);

    let currentYear = currentDate.getFullYear();
    let currentMonth = String(currentDate.getMonth() + 1).padStart(2, '0');
    let currentDay = String(currentDate.getDate()).padStart(2, '0');

    let minDate = new Date(currentYear, currentDate.getMonth(), currentDay); // 월은 0부터 시작하므로 -1 제거

    if (inputDate <= minDate) {
        alert('현재 날짜보다 이전의 날짜는 설정할 수 없습니다.');
        let formattedDate = `${currentYear}-${currentMonth}-${currentDay}`;
        input.value = formattedDate;
    }
}

//업무 요청하기
let requestBtn = document.getElementById("request");
let requestForm = document.querySelectorAll("#requestJob")[0];

requestBtn.addEventListener("click", (event) => {
    let target = event.target;
    event.preventDefault();
    let formData = new FormData(requestForm);
    let requiredList = ["jobSj", "jobCn", "jobBeginDate", "jobClosDate"];
    let validation = true;

    requiredList.forEach((required) => {
        let req = document.getElementById(required);
        if (req.value.trim() === "") {
            validation = false;
        }
    });

    if (!validation) {
        Swal.fire({
            text: '모든 값을 입력해주세요',
            showConfirmButton: false,
            timer: 1500
        });
    }

    //받는 사원의 리스트
    let receiveEmpls = receive.querySelectorAll("span");
    let selectedEmplIds = [];
    receiveEmpls.forEach((receiveEmpl) => {
        let emplId = receiveEmpl.getAttribute("data-id");
        selectedEmplIds.push(emplId);
    });
    formData.append("selectedEmplIds", selectedEmplIds);

    $.ajax({
        url: '/job/insertJob',
        type: 'post',
        data: formData,
        contentType: false,
        processData: false,
        cache: false,
        success: function() {
            //알림 보내기
            $.get("/alarm/getMaxAlarm")
                .then(function (maxNum) {
                    maxNum = parseInt(maxNum) + 1;

                    let subject = formData.get("jobSj");
                    let url = '/job/main';
                    let content = `<div class="alarmListBox">
                                    <a href="${url}" class="aTag" data-seq="${maxNum}">
                                        <h1>[업무 요청]</h1>
                                        <div class="alarm-textbox">
                                            <p>${emplNm}님이
                                            [<span>${subject}</span>]
                                             업무를 요청하셨습니다.</p>
                                        </div>
                                    </a>
                                    <button type="button" class="readBtn">읽음</button>
                                    </div>`;
                    let alarmVO = {
                        "ntcnSn": maxNum,
                        "ntcnUrl": url,
                        "ntcnCn": content,
                        "commonCodeNtcnKind": 'NTCN010',
                        "selectedEmplIds": selectedEmplIds
                    };

                    //알림 생성 및 페이지 이동
                    $.ajax({
                        type: 'post',
                        url: '/alarm/insertAlarmTargeList',
                        data: alarmVO,
                        success: function (rslt) {
                            if (socket) {
                                //알람번호,카테고리,url,보낸사람이름,받는사람아이디, 제목
                                let msg = `${maxNum},job,${url},${emplNm},${subject},${selectedEmplIds}`;
                                socket.send(msg);
                            }},
                        error: function (xhr) {
                            console.log(xhr.status);
                        }
                    });
                })
                .catch(function (error) {
                    console.log("최대 알람 번호 가져오기 오류:", error);
                });
            location.href = "/job/main";
        },
        error: function(xhr) {
            console.log(xhr.status);
        }
    });
});

//수정
let modifyBtn = document.querySelector("#modify");
let confirmBtn = document.querySelector("#confirm");

modifyBtn.addEventListener("click", function(){
    let dataId = modifyBtn.getAttribute("data-id");
    progressList.forEach(progress => {
        progress.disabled = false;
    });
    confirmBtn.style.display = "block";
    this.style.display = "none";
    if (dataId == emplId) { // 나 -> 나
        let inputList = document.querySelectorAll(".jobDetail input");
        inputList.forEach(input => {
            input.disabled = false;
            input.readOnly = false;
        })
    }
});

confirmBtn.addEventListener("click", () => {
    let jobNo = confirmBtn.getAttribute("data-seq");
    let id = requestId.getAttribute("data-id");
    let checkboxes = document.querySelectorAll(".kind-data");
    let selectedValue;
    let commonCodeDutyKind;
    progressList.forEach(progress => {
        if (progress.checked) {
            selectedValue = progress.getAttribute("data-code");
        }
    });
    checkboxes.forEach(checkbox => {
        if (checkbox.checked) {
           commonCodeDutyKind = checkbox.value;
        }
    })

    let jobProgressVO = {
        "jobNo": jobNo,
        "commonCodeDutyProgrs": selectedValue
    }

    let jobVO = {
        "jobNo": jobNo,
        "jobSj": document.querySelector("#sj-data input").value,
        "jobCn": document.querySelector("#cn-data input").value,
        "jobBeginDate": document.querySelector("#begin-data input").value,
        "jobClosDate": document.querySelector("#close-data input").value,
        "commonCodeDutyKind": commonCodeDutyKind
    }
    $.ajax({
        type: 'put',
        url: '/job/updateJobProgress',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(jobProgressVO),
        success: function () {
            if (id == emplId) {
                $.ajax({
                    type: 'put',
                    url: '/job/updateJob',
                    contentType: 'application/json; charset=utf-8',
                    data: JSON.stringify(jobVO),
                    success: function () {
                        location.href = "/job/main";
                    },
                    error: function (xhr) {
                        console.log(xhr.status);
                    }
                });
            } else {
                location.href = "/job/main";
            }
        },
        error: function (xhr) {
            console.log(xhr.status);
        }
    });
});

//to do
let progresses = document.querySelectorAll(".dutyProgrs");
progresses.forEach(progress => {
    let progrs = progress.innerText;
    if (progrs == "업무 전") {
        progress.classList.add("before-progress");
    } else if (progrs == "업무 중") {
        progress.classList.add("doing-progress");
    } else if (progrs == "업무 완") {
        progress.classList.add("done-progress");
    }
});

let dutykinds = document.querySelectorAll(".dutykind");
dutykinds.forEach(kind => {
    let duty = kind.innerText;
    if (duty == "회의") {
        kind.classList.add("badge-duty-meeting");
    } else if (duty == "개인") {
        kind.classList.add("badge-personal-meeting");
    } else if (duty == "팀") {
        kind.classList.add("badge-team-meeting");
    } else if (duty == "교육") {
        kind.classList.add("badge-edu-meeting");
    } else if (duty == "기타") {
        kind.classList.add("badge-etc-meeting");
    }
});
