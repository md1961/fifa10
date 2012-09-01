$(document).ready(
    function() {
        $('.focus_on_open').focus();

        $(window).keydown(
            function(e) {
                var $marker = $('#table_matches_link');
                if ($marker.length == 0) {
                    return;
                }

                var key = String.fromCharCode(e.which);
                if (e.keyCode == 191) { key = '/'; }
                if ((key < 'A' || 'Z' < key) && key != '/') {
                    return;
                }
                $marker.children('a[short_cut="' + key + '"]').focus();
            }
        );
    }
);

