$(document).ready(
    function() {
        $(window).keydown(
            function(e) {
                var $marker = $('#top_of_tables_roster_chart');
                if ($marker.length == 0) {
                    return;
                }

                var short_cut_for_select_attr2  = $marker.attr('short_cut_for_select_attr2');
                var short_cuts_for_edit_command = $marker.attr('short_cuts_for_edit_command');

                var key = String.fromCharCode(e.which);
                if (key == short_cut_for_select_attr2) {
                    $('#select_attr2').focus();
                    return false;
                } else if (short_cuts_for_edit_command.indexOf(key) >= 0) {
                    $('#edit_command').focus();
                }
            }
        );
    }
);

