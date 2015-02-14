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
//= require jquery-ui
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-datepicker




window.setTimeout(function() {
  $(".fade").fadeTo(500, 0).slideUp(500, function(){
      $(this).remove();
  });
}, 3000);

$(function() {
  $("#datepicker").datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true});


  $('span.btn-sm').click(function(){
  	comment = $("#comment_comment").val();
  	lead_id = $(this).attr('leadid');

	comment_id = $(".microposts p:first").attr('leadid');
	if (comment=='') return;
  	//return;
  	$.ajax({
	 url: "/ajax/add_comment",
	 data: {'comment':comment,'lead_id':lead_id},
	 type: "POST",
	 beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},	 
	  success: function(){
	   $("#comment_comment").val("");
	   $.get('/leads/'+lead_id+'/edit', "", null, "script");
	   $('.panel-body').scrollTop(-9999);
	  }
	 });


  })
});



