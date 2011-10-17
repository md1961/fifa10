$(document).ready(
    function() {
        $(window).keydown(
            function(e) {
                var $marker = $('#table_matches_link');
                if ($marker.length == 0) {
                    return;
                }

                var key = String.fromCharCode(e.which);
                if ((key < 'A' || 'Z' < key) && key != '/') {
                    return;
                }
                $marker.children('a[short_cut="' + key + '"]').focus();
            }
        );
    }
);
