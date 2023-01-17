import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
      const BASE_URL =location.protocol +'//'+location.hostname+':'+location.port;
      $( ".facet-check-box-city" ).click(function() {
          var selected = [];
          var page;
          $('.list-group-item input:checked').each(function() {
              selected.push($(this).attr('value'));
          });
          fillterSearch(selected, page);
      });
      function fillterSearch(data, page) {
          var keyword = $('#keyword').val();
          var ajax_call = true
          jQuery.ajax({
              url: BASE_URL+ "/jobs/search/",
              type: "POST",
              data: { data, keyword, ajax_call, page },
              success:function(data)
              {
                  $('.job-list').html(data)
              }
          });
      }
  }
}
