window.addEventListener('load', function(){
	document.getElementById("nickname").addEventListener("click", function() {
        var dropdown_content = document.getElementById("dropdown_content");
        var displayValue = dropdown_content.style.display;
        
        if(displayValue == '' ||displayValue == 'none'){
         	dropdown_content.style.display = "block";
        }else{
        	dropdown_content.style.display = "none";
        }
        // div를 나타나게 함
       
    });
	
	document.addEventListener("click", function(event) {
        var nickname = document.getElementById("nickname");
		var dropdown_content = document.getElementById("dropdown_content");
		
        // 클릭된 요소 자체이거나 내부의 요소인 경우에는 아무 작업도 하지 않음
        if (event.target === nickname || dropdown_content.contains(event.target)) {
            return;
        }

        // 클릭된 요소가 다른 요소일 때 숨김
        dropdown_content.style.display = "none";
    });
    
    window.addEventListener("resize", function() {
		var header_menu = document.getElementById("header_menu");
		
		if(window.innerWidth > 600){
		  	header_menu.style.display = 'flex';
		}
		if(window.innerWidth <= 600){
		  	header_menu.style.display = 'none';
		}
	});
});





/*function dropdown(){	
	var displayValue = dropdown_content.style.display;
	if(displayValue === 'none' || displayValue === ''){
		dropdown_content.style.display = 'block';
	}
}*/

function hamburger(){
	var header_menu = document.getElementById("header_menu");
		
		var displayValue = header_menu.style.display;
		if(displayValue === 'none' || displayValue === ''){
			header_menu.style.display = 'flex';
		}else{
			header_menu.style.display = 'none';
		}
}