const allCheck = document.querySelector("#selectAll");
let checkboxes = document.querySelectorAll('.selectmail:checked');

function checkAll() {
    let checkboxes = document.querySelectorAll(".selectmail");
    checkboxes.forEach(function (checkbox) {
        checkbox.checked = allCheck.checked;
    });
}

function modifyTableAt(td) {
    let code = td.getAttribute("data-type");
    if (code === 'redng') {
        let at = td.querySelector("i").getAttribute("data-at");
        let emailEtprCode = td.closest("tr").getAttribute("data-id");
        $.ajax({
            url: `/email/${code}/${emailEtprCode}`,
            type: 'put',
            data: at,
            success: function (result) {
                at = result;
                if(at == "Y"){
                    td.innerHTML = '<i class="icon i-mail-read mail-icon" data-at="Y"></i>'
                }else if(at == "N"){
                    td.innerHTML = '<i class="icon i-mail mail-icon" data-at="N"></i>'
                }
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
            }
        });
    }else if(code === 'imprtnc'){
        let at = td.querySelector("i").getAttribute("data-at");
        let emailEtprCode = td.closest("tr").getAttribute("data-id");
        $.ajax({
            url: `/email/${code}/${emailEtprCode}`,
            type: 'put',
            data: at,
            success: function (result) {
                at = result;
                if(at == "Y"){
                    td.innerHTML = '<i class="icon i-star-fill star-icon" data-at="Y"></i>'
                }else if(at == "N"){
                    td.innerHTML = '<i class="icon i-star-out star-icon" data-at="N"></i>'
                }
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
            }
        });
    } else {
        code = 'delete';
        let emailEtprCode = td.closest("tr").getAttribute("data-id");
        let at = document.querySelector("input[name=deleteAt]").value;
        $.ajax({
            url: `/email/${code}/${emailEtprCode}`,
            type: 'put',
            data: at,
            success: function (result) {
                td.remove();
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
            }
        });
    }
}

function modifyAtByBtn() {
    checkboxes = document.querySelectorAll(".selectmail:checked");
    checkboxes.forEach(function (checkbox) {
        let td = checkbox.parentNode.nextElementSibling;
        modifyTableAt(td);
        checkbox.checked = false;
        allCheck.checked = false;
    });
}

function modifyDeleteAtByBtn() {
    checkboxes = document.querySelectorAll(".selectmail:checked");
    checkboxes.forEach(function (checkbox) {
        let tr = checkbox.closest("tr");
        modifyTableAt(tr);
        checkbox.checked = false;
        allCheck.checked = false;
    });
}
