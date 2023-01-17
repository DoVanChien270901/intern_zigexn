$('#keyword').keyup(function() {
    const BASE_URL =location.protocol +'//'+location.hostname+':'+location.port;
    jQuery.ajax({
        url: BASE_URL+ "/suggestions/"+this.value,
        type: "GET",
        data: {},
        dataType: "json",
        success:function(response)
        {
            options = $("#data-list1");
            options.empty();
            if (response.data != null) {
                $(".data-list").css('opacity', '1');
                $.each(response.data.suggestion, function(i, item) {
                    options.append(
                        $("<p>").attr("class","text-suggestion").text(item).click(function(){
                            $(".data-list").css('opacity', '0');
                            input = $('#keyword');
                            arr = input.val().split(' ');
                            if (arr.length > 1) {
                                input.val( arr[arr.length -2] + ' ' + this.textContent);
                            } else {
                                input.val(this.textContent)
                            }
                            input.focus();
                        })
                    )
                });
            } else {  
                $(".data-list").css('opacity', '0');
            }
        }
    });
});
function add_to_favorite(id) {
    const BASE_URL =location.protocol +'//'+location.hostname+':'+location.port;
    jQuery.ajax({
        url: BASE_URL+ "/favorites/"+id, // it should be mapped in routes.rb in rails
        type: "POST",
        data: {}, // if you want to send some data.
        dataType: "json",
        success:function(response)
        {
            if(response.status == 201) {
                jQuery('#btn_favorite_'+id).toggleClass('btn-solid');
                document.getElementById("favorite_count").innerHTML =response.favorite_count;
            } else {
                window.location.replace(BASE_URL + '/login');
            }

        }
    });
}
function apply_job(id) {
    document.getElementById("apply_link").href="/apply?job_id="+id;
}
jQuery("input:radio[name=apply_radio]:visible")[0].checked=true;
