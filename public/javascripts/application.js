// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function validateSSN(the_element) {

    the_ssn = the_element.value;

    if(the_ssn == null || the_ssn == "") { return true; } // allow empty values

    var matchArr = the_ssn.match(/^(\d{3})-?\d{2}-?\d{4}$/);
    var numDashes = the_ssn.split('-').length - 1;

    if (matchArr == null || numDashes == 1) {
        alert('Invalid SSN. Must be 9 digits or in the form NNN-NN-NNNN.');
        the_element.focus();
        return false;
    }
    else if (parseInt(matchArr[1],10)==0) {
        alert("Invalid SSN: SSN's can't start with 000.");
        the_element.focus();
        return false;
    }

    return true;
}

function validatePhone(the_element) {

    the_phone = the_element.value;

    if(the_phone == null || the_phone == "") { return true; } // allow empty values

    var matchArr = the_phone.match(/^(\d{3})-?\d{3}-?\d{4}$/);
    var numDashes = the_phone.split('-').length - 1;

    if (matchArr == null || numDashes == 1) {
        alert('Invalid Phone Number. Must be in the form NNN-NNN-NNNN.');
        the_element.focus();
        return false;
    }

    return true;
}