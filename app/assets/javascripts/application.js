//= require jquery
//= require jquery_ujs
//= require bootstrap/dropdown

(function($, undefined) {
  $("#navbar-button").on("click", function () {
    $("#navbar-collapse").toggleClass("collapse");
  });
})(jQuery);
