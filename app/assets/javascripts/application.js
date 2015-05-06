// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/datepicker
//= require bootstrap-tokenfield
//= require chosen.jquery
//= require_tree .
//= require jquery.fileupload


var fade_flash = function() {
    $("#flash_notice").delay(5000).fadeOut("slow");
    $("#flash_alert").delay(5000).fadeOut("slow");
    $("#flash_error").delay(5000).fadeOut("slow");
    $(".alert").delay(5000).fadeOut("slow");
};

window.setTimeout(function() {
  $(".fade").fadeTo(500, 0).slideUp(500, function(){
      $(this).remove();
  });
}, 3000);

function checkTime(i){
	if (i<10){i="0" + i;}
	return i;
}

function startTime(){
	var tm=new Date();
	var h=tm.getHours();
	var m=tm.getMinutes();
	var s=tm.getSeconds();
	
	m=checkTime(m);
	s=checkTime(s);
	$(".time_h").html(h+":"+m+":"+s);
	t=setTimeout('startTime()',500);
}


var show_ajax_message = function(msg, type) {
    if (!type) {type = "success"};
    $(".flash").html('<div class="alert fade in alert-'+type+'">'+msg+'</div>');    
    fade_flash();
};

var fixEncode = function(loc) {
    var h = loc.split('#');
    var l = h[0].split('?');
    return l[0] + (l[1] ? ('?' + ajx2q(q2ajx(l[1]))) : '') + (h[1] ? ('#' + h[1]) : '');
  };

$(function() {

  startTime();

var settings = {
    url: "/",
    method: "POST",
    fileName: "myfile",
    onSuccess:function(files,data,xhr)
    {
        alert("Upload success");
    },
    onError: function(files,status,errMsg)
    {       
        alert("Upload Failed");
    }
}
$('.progress').hide();
$('#file').hide();
 
$("#mulitplefileuploader").uploadFile(settings);

  // дата по умолчанию для нового лида - сегодня
  if (!$("#lead_start_date").val()){
	    $("#lead_start_date").val($.datepicker.formatDate('dd.mm.yy', new Date()));
      $("#lead_status_date").val($.datepicker.formatDate('dd.mm.yy', new Date()));
  }

 $('.sel_val').click(function(){
          if ($(this).hasClass('select_custom_ext')) {
            $(this).removeClass('select_custom_ext');
            $(this).parent().removeClass('select_custom_ext');
          }
          else {
            $(this).addClass('select_custom_ext');
            $(this).parent().addClass('select_custom_ext');
          }
        });


  $('.menu_sb li a').click(function(){ 
      $('.menu_sb li.active').removeClass("active", 150, "easeInQuint");
      $(this).parent().addClass("active");
      var url = "/" + $(this).attr("controller");
      $.get(url, null, null, "script");
      if (url!="/undefined") setLoc("options"+url);
  });

  $(document).on('click','#btn-send',function(e) {  
     
    var valuesToSubmit = $('form').serialize();
    var url = $('form').attr('action');
    
    $.ajax({
        type: "POST",
        url: url, //sumbits it to the given url of the form
        data: valuesToSubmit,
        dataType: 'JSON',  
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},         
        success: function(){
          $.get(url, null, null, "script");
      }
    });
    
    return false; // prevents normal behaviour
  });

});


