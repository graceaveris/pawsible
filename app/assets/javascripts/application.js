// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap
//= require activestorage
//= require_tree .

// feed index page autocomplete for search field
document.addEventListener("DOMContentLoaded", function(event) {
  let searchTitleArray = [];
  $( "#filter_challenge" ).keyup(function(key) {
    $.ajax({
      method: "GET",
      url: "/search/autocomplete",
      data: $(this).serialize(),
      dataType: "json"
    })
    .done(function( data ) {
      if (data.length === 0 || ($("#filter_challenge").val().length === 0 && (key.keyCode === 8 || key.keyCode === 46)) ) {
        $( "#dropdown" ).empty(); 
        searchTitleArray = [];           
      } else {
        data.forEach(function(element) {
          if (searchTitleArray.indexOf(element.title) === -1) {
            searchTitleArray.push(element.title);
            $( "#dropdown" ).append( `<option value='${element.title}'>` );
          };
        });
      };
    });
  });
});
// end