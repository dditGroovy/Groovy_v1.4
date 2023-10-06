<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>

<style>
    #modifyCardInfoBtn, #saveCardInfoBtn, #cancelModifyCardInfoBtn, #disabledCardBtn {
        display: none;
    }
</style>
<link rel="stylesheet" href="/resources/css/admin/cardManage.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/card/manage" class="on">회사 카드 관리</a></h1>
        <h1><a href="${pageContext.request.contextPath}/card/reservationRecords">대여 내역 관리</a></h1>
    </header>
    <div class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm registerCard">
            <div class="modal-top register-top">
                <div class="modal-title register-title"><i class="icon-card"></i>카드 등록</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <div id="registerCard">
                    <form id="registerCardForm" method="post">
                        <table class="register-table">
                            <tr>
                                <td class="table-title">카드 이름</td>
                                <td><input type="text" id="cardName" class="font-14" name="cprCardNm"
                                           placeholder="카드 이름을 입력해주세요." required></td>
                            </tr>
                            <tr>
                                <td class="table-title">카드 번호</td>
                                <td><input type="text" id="cardNo" class="font-14" name="cprCardNo"
                                           placeholder="0000-0000-0000-0000" required></td>
                            </tr>
                            <tr>
                                <td class="table-title">카드사</td>
                                <td>
                                    <select name="cprCardChrgCmpny" id="cardCom">
                                        <option value="IBK기업은행">IBK기업은행</option>
                                        <option value="KB국민카드">KB국민카드</option>
                                        <option value="NH농협은행">NH농협은행</option>
                                        <option value="롯데카드">롯데카드</option>
                                        <option value="비씨카드">비씨카드</option>
                                        <option value="삼성카드">삼성카드</option>
                                        <option value="신한카드">신한카드</option>
                                        <option value="우리카드">우리카드</option>
                                        <option value="하나카드">하나카드</option>
                                        <option value="한국씨티은행">한국씨티은행</option>
                                        <option value="현대카드">현대카드</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
            <div class="modal-footer btn-wrapper">
                <button type="button" id="registerCardBtn" class="btn btn-out-sm">등록</button>
            </div>
        </div>
        <div class="modal-layer card-df sm cardInfoCard">
            <div class="modal-top info-top">
                <div class="modal-cardinfo font-md font-18 color-font-md">카드 기본 정보</div>
                <div class="cardinfo-button-box">
                    <button type="button" class="setting-box">
                        <i class="icon i-set"></i>
                    </button>
                    <button type="button" class="modal-close btn close info-close">
                        <i class="icon i-close close"></i>
                    </button>
                </div>
            </div>
            <div class="modal-container">
                <div id="cardInfo">
                    <form id="cardInfoForm" method="post">
                        <div class="table-wrapper">
                            <table class="card-info-table">
                                <tr>
                                    <td class="info-title font-14">카드 이름</td>
                                    <td id="selectedCardName" class="font-14"></td>
                                </tr>
                                <tr>
                                    <td class="info-title font-14">카드 번호</td>
                                    <td id="selectedCardNo" class="font-14"></td>
                                </tr>
                                <tr>
                                    <td class="info-title font-14">카드 회사</td>
                                    <td id="selectedCardCom" class="font-14"></td>
                                </tr>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer btn-wrapper btn-info-wrapper" style="display: none">
                <div class="info-btn-wrapper">
                    <button id="saveCardInfoBtn" class="btn">저장</button>
                    <button id="modifyCardInfoBtn" class="btn">수정</button>
                    <button id="cancelModifyCardInfoBtn" class="btn">취소</button>
                    <button id="disabledCardBtn" class="btn">사용불가 처리</button>
                </div>
            </div>
        </div>

    </div>

    <div class="card-wrapper">
        <button type="button" class="card-regist color-font-md font-md font-14 btn-modal" data-name="registerCard">카드 등록
            <i class="icon i-add-md"></i></button>
        <div id="cardList"></div>
    </div>

    <div class="waiting-wrapper card-df card">
        <h1 class="font-24 font-md waiting-title">카드 신청 미처리건 <span id="waitingListCnt"
                                                                   style="color: dodgerblue; font-weight: bolder">${waitingListCnt}</span><span
                class="font-14">건</span>
        </h1>
        <div id="cardWaitingList">
            <div id="waitingListGrid" class="ag-theme-material"></div>
        </div>
    </div>

    <script>
        window.onload = function () {
            // 모든 요소가 로딩된 후에 실행할 코드
            var script = document.createElement('script');
            script.src = '/resources/js/modal.js';
            document.head.appendChild(script);
        };
        const cardListDiv = $("#cardList");
        const registerCardBtn = $("#registerCardBtn");
        const saveCardInfoBtn = $("#saveCardInfoBtn");
        const cancelModifyCardInfoBtn = $("#cancelModifyCardInfoBtn");
        const modifyCardInfoBtn = $("#modifyCardInfoBtn");
        const disabledCardBtn = $("#disabledCardBtn");
        const selectedCardName = $("#selectedCardName");
        const selectedCardCom = $("#selectedCardCom");
        const selectedCardNo = $("#selectedCardNo");

        let settingBtn = $(".setting-box");
        let currentCardNo;
        let currentCardNm;
        let optionCode;

        const returnResve = (params) => params.value;

        class ClassComp {
            init(params) {
                let data = params.node.data;
                let cprCardResveSn = data.cprCardResveSn;
                let selectedCardNo;
                let assignData = {};
                let cprCardResveEmplId = data.cprCardResveEmplId;
                this.eGui = document.createElement('div');
                this.eGui.innerHTML = `<div class="select-box"><div class="select-wrapper"><select name="cprCardNo" class="selectedCard selectBox"></select></div>
            <button id="submitBtn">저장</button></div>`;

                this.selectElement = this.eGui.querySelector('.selectedCard');
                this.btn = this.eGui.querySelector("#submitBtn");

                this.selectElement.innerHTML = optionCode;

                this.selectElement.addEventListener('change', (event) => {
                    this.selectedOptionValue = event.target.value;
                    selectedCardNo = this.selectedOptionValue;
                    assignData = {
                        cprCardResveSn: cprCardResveSn,
                        cprCardNo: selectedCardNo,
                    }
                });

                this.btn.onclick = () => {
                    console.log(assignData);
                    $.ajax({
                        url: "/card/assignCard",
                        type: "post",
                        data: JSON.stringify(assignData),
                        contentType: "application/json;charset:utf-8",
                        success: function (result) {
                            //알림 보내기
                            $.get("/alarm/getMaxAlarm")
                                .then(function (maxNum) {
                                    maxNum = parseInt(maxNum) + 1;
                                    let ntcnEmplId = cprCardResveEmplId;
                                    let url = '/card/request';
                                    let content = `<div class="alarmListBox">
                                                <a href="\${url}" class="aTag" data-seq="\${maxNum}">
                                                    <h1>[법인카드 신청]</h1>
                                                    <div class="alarm-textbox">
                                                        <p>법인카드 신청이 승인되었습니다.</p>
                                                    </div>
                                                </a>
                                                <button type="button" class="readBtn">읽음</button>
                                                </div>`;
                                    let alarmVO = {
                                        "ntcnEmplId": ntcnEmplId,
                                        "ntcnSn": maxNum,
                                        "ntcnUrl": url,
                                        "ntcnCn": content,
                                        "commonCodeNtcnKind": 'NONE'
                                    };

                                    //알림 생성 및 페이지 이동
                                    $.ajax({
                                        type: 'post',
                                        url: '/alarm/insertAlarmTarget',
                                        data: alarmVO,
                                        success: function (rslt) {
                                            if (socket) {
                                                //알람번호,카테고리,url,보낸사람이름,받는사람아이디
                                                let msg = maxNum + ",card," + url + "," + ntcnEmplId;
                                                socket.send(msg);
                                            }
                                            loadAllCard();
                                            const newData = rowData.filter(item => item.cprCardResveSn !== assignData.cprCardResveSn);
                                            gridOptions.api.setRowData(newData);
                                            let cntText = $("#waitingListCnt").text();
                                            let cnt = parseInt(cntText, 10);
                                            $("#waitingListCnt").text(cnt - 1);
                                        },
                                        error: function (xhr) {
                                        }
                                    });
                                })
                                .catch(function (error) {
                                    console.log("최대 알람 번호 가져오기 오류:", error);
                                });
                        },
                        error: function (xhr) {
                            Swal.fire({
                                text: '오류로 인하여 카드 지정을 실패했습니다',
                                showConfirmButton: false,
                                timer: 1500
                            })
                        }
                    })
                };
            }

            constructor() {
                this.selectedOptionValue = '';
            }

            getGui() {
                return this.eGui;
            }

            destroy() {
            }
        }

        const getMedalString = function (param) {
            const str = `${param} `;
            return str;
        };
        const MedalRenderer = function (params) {
            return getMedalString(params.value);
        };

        function onQuickFilterChanged() {
            gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
        }

        const columnDefs = [
            {
                headerName: "순번",
                valueGetter: "node.rowIndex + 1",
                width: 80
            },
            {
                field: "cprCardResveSn", headerName: "예약 순번", hide: true, getQuickFilterText: (params) => {
                    return getMedalString(params.value);
                }
            },
            {field: "cprCardResveBeginDate", headerName: "사용 시작 일자", width: 130},
            {field: "cprCardResveClosDate", headerName: "사용 마감 일자", width: 130},
            {field: "cprCardUseLoca", headerName: "사용처"},
            {field: "cprCardUsePurps", headerName: "사용 목적"},
            {field: "cprCardUseExpectAmount", headerName: "사용 예상 금액", width: 150},
            {field: "cprCardResveEmplIdAndName", headerName: "사원명(사번)", width: 150},
            {field: "assign", headerName: "카드 지정", cellRenderer: ClassComp},
            {field: "cprCardResveEmplId", headerName: "사번", hide: true}
        ];

        const rowData = [];
        <c:forEach items="${loadCardWaitingList}" var="resve">
        <fmt:formatDate var= "cprCardResveBeginDate" value="${resve.cprCardResveBeginDate}" type="date" pattern="yyyy-MM-dd" />
        <fmt:formatDate var= "cprCardResveClosDate" value="${resve.cprCardResveClosDate}" type="date" pattern="yyyy-MM-dd" />
        <fmt:formatNumber var= "cprCardUseExpectAmount" value="${resve.cprCardUseExpectAmount}" type="number" maxFractionDigits="3" />
        rowData.push({
            cprCardResveSn: "${resve.cprCardResveSn}",
            cprCardResveBeginDate: "${cprCardResveBeginDate}",
            cprCardResveClosDate: "${cprCardResveClosDate}",
            cprCardUseLoca: "${resve.cprCardUseLoca}",
            cprCardUsePurps: "${resve.cprCardUsePurps}",
            cprCardUseExpectAmount: "${cprCardUseExpectAmount}원",
            cprCardResveEmplIdAndName: "${resve.cprCardResveEmplNm}(${resve.cprCardResveEmplId})",
            cprCardResveEmplId: "${resve.cprCardResveEmplId}"
        })
        </c:forEach>

        const gridOptions = {
            columnDefs: columnDefs,
            rowData: rowData,
            onGridReady: function (event) {
                event.api.sizeColumnsToFit();
            },
            rowHeight: 50
        };

        document.addEventListener('DOMContentLoaded', () => {
            const gridDiv = document.querySelector('#waitingListGrid');
            new agGrid.Grid(gridDiv, gridOptions);

        });

        loadAllCard();


        registerCardBtn.on("click", function (event) {
            event.preventDefault();

            let cardNo = $("#cardNo").val();
            if (!isValidCardNumber(cardNo)) {
                Swal.fire({
                    text: '카드 번호 형식이 올바르지 않습니다',
                    showConfirmButton: false,
                    timer: 1500
                })
                return;
            }

            let form = $("#registerCardForm")[0];
            let formData = new FormData(form);
            $.ajax({
                url: "/card/inputCard",
                type: "post",
                data: formData,
                processData: false,
                contentType: false,
                success: function (result) {
                    loadAllCard();
                    modalClose("registerCard");
                },
                error: function (xhr) {
                    Swal.fire({
                        text: '오류로 인하여 카드 등록을 실패했습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            })
        })

        function loadAllCard() {
            $.ajax({
                url: "/card/loadAllCard",
                type: "get",
                dataType: "json",
                success: function (result) {
                    codeforList = "";
                    optionCode = "<option value='null'>카드 선택</option>";
                    let imgUrls = ['card1.png', 'card2.png', 'card3.png', 'card4.png', 'card5.png'];
                    $.each(result, function (idx, obj) {
                        let imgUrl = imgUrls[idx % imgUrls.length];
                        codeforList += `<div><button class="cards btn-modal" data-name="cardInfoCard" id="\${obj.cprCardNo}" >
                                        <span class="opacity-span" style='background-image: url("/resources/images/object/\${imgUrl}")'></span>
                                        <p id="btnCardNo">\${obj.maskCardNo}</p>
                                        <input type=hidden id="btnCardStatus" value="\${obj.cprCardSttus}">`;
                        let cprCardSttus = obj.cprCardSttus
                        switch (cprCardSttus) {
                            case 0:
                                optionCode += `<option value="\${obj.cprCardNo}">\${obj.cprCardNm}</option>`;
                                break;
                            case 1:
                                codeforList += "<p class='using font-14 font-md'>사용중</p>"
                                break;
                            case 2:
                                codeforList += "<p class='refuse font-14 font-md'>사용불가</p>"
                                break;
                        }
                        codeforList += `</button>
                                                <div class="card-info">
                                                    <p id="btnCardCom" class="color-font-md font-14">[\${obj.cprCardChrgCmpny}]</p>
                                                    <p id="btnCardNm" class="color-font-md font-11">\${obj.cprCardNm}</p>
                                                </div>
                                        </div>`;
                    });
                    cardListDiv.html(codeforList);
                    $(".selectedCard").html(optionCode);
                    let usings = document.querySelectorAll(".using");
                    usings.forEach(use => {
                        use.parentElement.querySelector(".opacity-span").classList.add("using-opacity");
                    });
                    let refuseContents = document.querySelectorAll(".refuse");
                    refuseContents.forEach(refuse => {
                        refuse.parentElement.querySelector(".opacity-span").classList.add("refuse-grayscale");
                    })


                },
                error: function (xhr) {
                    Swal.fire({
                        text: '오류로 인하여 카드 목록을 불러오지 못하였습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            })
        }

        cardListDiv.on("click", ".cards", function () {
            let selectedCard = $(this);
            let cardNo = selectedCard.attr("id");
            let cardMarkNo = selectedCard.find("#btnCardNo").text();
            let cardNm = selectedCard.siblings().find("#btnCardNm").text();
            let cardCom = selectedCard.siblings().find("#btnCardCom").text();
            let cardStatus = selectedCard.find("#btnCardStatus").val();

            if ($(this).find(".refuse").length == 0) {
                settingBtn.css("display", "block");
            } else {
                settingBtn.css("display", "none");
            }

            saveCardInfoBtn.hide();
            cancelModifyCardInfoBtn.hide();
            modifyCardInfoBtn.show();
            if (cardStatus != 2) {
                disabledCardBtn.show();
            } else {
                disabledCardBtn.hide();
            }

            selectedCardName.text(cardNm);
            selectedCardCom.text(cardCom.replace(/\[|\]/g, ""));
            selectedCardNo.text(cardMarkNo);

            currentCardNo = cardNo;
            currentCardNm = cardNm;

            modalOpen("cardInfoCard");
        })

        modifyCardInfoBtn.on("click", function () {
            selectedCardName.html(`<input type='text' id='newCardNm' value='\${currentCardNm}'>`);
            $(this).hide();
            disabledCardBtn.hide();
            saveCardInfoBtn.show();
            cancelModifyCardInfoBtn.show();
        })

        saveCardInfoBtn.on("click", function () {
            let newCardNm = $("#newCardNm").val();
            selectedCardName.html('');
            selectedCardName.text(newCardNm);

            let modifiedData = {
                cprCardNo: currentCardNo,
                cprCardNm: newCardNm
            }

            $.ajax({
                url: "/card/modifyCardNm",
                type: "post",
                data: JSON.stringify(modifiedData),
                contentType: "application/json;charset:utf-8",
                success: function (result) {
                    if (result == 1) {
                        loadAllCard();
                    } else {
                        Swal.fire({
                            position: 'top',
                            icon: 'error',
                            text: '오류로 인하여 카드 이름 수정을 실패했습니다',
                            showConfirmButton: false,
                            timer: 1500
                        })
                    }
                },
                error: function (xhr) {
                    Swal.fire({
                        position: 'top',
                        icon: 'error',
                        text: '오류로 인하여 카드 이름 수정을 실패했습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            })

            $(this).hide();
            cancelModifyCardInfoBtn.hide();
            modifyCardInfoBtn.show();
            disabledCardBtn.show();
        })

        cancelModifyCardInfoBtn.on("click", function () {
            selectedCardName.html('');
            selectedCardName.text(currentCardNm);

            $(this).hide();
            saveCardInfoBtn.hide();
            modifyCardInfoBtn.show();
            disabledCardBtn.show();
        })

        disabledCardBtn.on("click", function () {
            Swal.fire({
                text: '해당 카드를 사용불가 처리하시겠습니까?',
                showCancelButton: true,
                confirmButtonColor: '#5796F3FF',
                cancelButtonColor: '#e1e1e1',
                confirmButtonText: '확인',
                cancelButtonText: '취소',
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: `/card/modifyCardStatusDisabled/\${currentCardNo}`,
                        type: "get",
                        success: function (result) {
                            if (result == 1) {
                                loadAllCard();
                                selectedCardName.html('');
                                selectedCardNo.html('');
                                selectedCardCom.html('');
                                Swal.fire({
                                    text: '카드 사용불가 처리를 완료했습니다',
                                    showConfirmButton: false,
                                    timer: 1500
                                })
                                modalClose();
                            } else {
                                Swal.fire({
                                    text: '오류로 인하여 카드 사용불가 처리를 실패했습니다',
                                    showConfirmButton: false,
                                    timer: 1500
                                })
                            }
                        },
                        error: function (xhr) {
                            Swal.fire({
                                text: '오류로 인하여 카드 사용불가 처리를 실패했습니다',
                                showConfirmButton: false,
                                timer: 1500
                            })
                        }
                    })
                }
            })
        })

        function isValidCardNumber(cardNumber) {
            let cardNumberPattern = /^\d{4}-\d{4}-\d{4}-\d{4}$/;
            return cardNumberPattern.test(cardNumber);
        }

        settingBtn.on("click", () => {
            $(".btn-info-wrapper").css("display", "block");
        })

        document.querySelector(".info-close").addEventListener("click", () => {
            document.querySelector(".btn-info-wrapper").style.display = "none";
        })

    </script>
</div>

<%--<script src="/resources/js/modal.js"></script>--%>

