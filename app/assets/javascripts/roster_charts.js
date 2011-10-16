$(document).ready(
    function(){
        $(window).keydown(
            function(e) {
                if ($('#top_of_tables_roster_chart').length == 0) {
                    return;
                }

                var keyCode = e.which;
                if (keyCode == 65) {  // 'a'
                    $('#select_attr2').focus();
                    return false;
                } else if ((48 <= keyCode && keyCode <= 48 + 9) || (65 <= keyCode && keyCode <= 65 + 25)) {
                    $('#edit_command').focus();
                }
            }
        );
    }
);

