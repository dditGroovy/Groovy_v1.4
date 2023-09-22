// 오늘 날짜
function getCurrentDate() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// 날짜 선택 오늘부터로 제한
function setMinDate(inputName) {
    const inputElement = $(`input[name='${inputName}']`);
    inputElement.attr("min", getCurrentDate());
}

function setDate(inputName) {
    const inputElement = $(`input[name='${inputName}']`);
    const currentDate = getCurrentDate();
    inputElement.val(currentDate);
}


// 날짜 유효성 검사
function validateDate(formId, startDateName, endDateName) {
    const form = $("#" + formId);
    const beginDate = new Date(form.find(`input[name='${startDateName}']`).val());
    const closDate = new Date(form.find(`input[name='${endDateName}']`).val());
    const today = new Date();

    beginDate.setHours(0, 0, 0, 0);
    closDate.setHours(0, 0, 0, 0);
    today.setHours(0, 0, 0, 0);

    if (beginDate < today || beginDate > closDate) {
        alert("선택한 날짜를 다시 확인해 주세요.");
        return false;
    }
    return true;
}

function validateEmpty(formId) {
    const form = $("#" + formId);
    let isNotEmpty = true;

    form.find(":input:not(:hidden)").each(function () {
        const elementType = $(this).attr("type");
        const value = $(this).val();

        if (elementType === "radio") {
            const name = $(this).attr("name");
            const radioGroup = form.find(`:input[name="${name}"]:checked`);

            if (radioGroup.length === 0) {
                isNotEmpty = false;
            }
        } else if (!value) {
            isNotEmpty = false;
        }
    });

    if (isNotEmpty === false) {
        alert("모든 항목을 입력해 주세요");
    }
    return isNotEmpty;
}


function formatNumber(number) {
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}