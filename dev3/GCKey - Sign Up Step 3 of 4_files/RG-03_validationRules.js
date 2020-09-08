$(document).ready(function () {
    $("#password").addClass("pValidation");
    $("#confirmPassword").addClass("cpValidation");
    formValidation.push({ className: "pValidation", validationMethod: validUserPassLength, summaryMsg: passwordLengthError, fieldMsg: passwordLengthError_field });
    formValidation.push({ className: "pValidation", validationMethod: validPassLowerSpecialChar, summaryMsg: passwordLowerCaseError, fieldMsg: passwordLowerCaseError_field });
    formValidation.push({ className: "pValidation", validationMethod: validPassUpperSpecialChar, summaryMsg: passwordUpperCaseError, fieldMsg: passwordUpperCaseError_field });
    formValidation.push({ className: "pValidation", validationMethod: hasNumeric, summaryMsg: passwordNumericError, fieldMsg: passwordNumeric_field });
    formValidation.push({ className: "pValidation", validationMethod: passwordMatchesConfirm, summaryMsg: passwordMatchConfirmError, fieldMsg: passwordMatchConfirmError_field });
    formValidation.push({ className: "pValidation", validationMethod: passwordContainsUserid, summaryMsg: passwordContainsUidError, fieldMsg: passwordContainsUidError_field });
    formValidation.push({ className: "pValidation", validationMethod: passwordSpecialChar, summaryMsg: passwordIlegalCharError, fieldMsg: passwordIlegalCharError_field });
    formValidation.push({ className: "cpValidation", validationMethod: confirmMatchPassFunction, summaryMsg: confirmMatchPassError, fieldMsg: confirmMatchPassError_field }); additionalValidation.push({ className: "pValidation", validationMethod: hasNoErrors, summaryMsg: passwordClearError, fieldMsg: passwordClearError_field }); additionalValidation.push({ className: "cpValidation", validationMethod: hasNoErrors, summaryMsg: confirmPassClearError, fieldMsg: confirmPassClearError_field }); checklistValidation.push({ id: "password_rg01e17", validationMethod: validUserPassLength });
    checklistValidation.push({ id: "password_rg01e22", validationMethod: passwordContainsUserid });
    checklistValidation.push({ id: "password_rg01e26", validationMethod: passwordSpecialChar });
    checklistValidation.push({ id: "password_rg01e18", validationMethod: validPassLowerSpecialChar });
    checklistValidation.push({ id: "password_rg01e19", validationMethod: validPassUpperSpecialChar });
    checklistValidation.push({ id: "password_rg01e20", validationMethod: hasNumeric });
    checklistValidation.push({ id: "password_rg01e21", validationMethod: passwordMatchesConfirm });
    $("#confirmPassword, #password").on("keyup change", function (event) {
        checklist("password", checklistValidation, "Password")
    })
});
var additionalValidation = new Array();
var checklistValidation = new Array();
function clearInputs() {
    $("input[type=password]").val("");
    checklist("password", checklistValidation, "Password")
};