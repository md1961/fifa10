$(document).ready(
    function(){
        $(window).keydown(
            function(e) {
                var keyCode = e.which;
                if ((48 <= keyCode && keyCode <= 48 + 9) || (65 <= keyCode && keyCode <= 65 + 25)) {
                    $('#edit_command').focus();
                }
            }
        );
    }
);

