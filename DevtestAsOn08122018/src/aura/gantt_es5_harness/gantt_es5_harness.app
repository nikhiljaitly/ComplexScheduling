<aura:application >
    
    <!-- DOESN'T WORK WHEN RENDERING A LIGHTNING CONTAINER -->
    <div style="width: 1000px; height: 500px;">
    	<c:gantt_es5 />
    </div>
     
    <!-- WORKS WHEN RENDERING AN IFRAME -->
    <!--<div style="width: 100%; height: 100%;">
    	<iframe style="width: 100%; height: 100%;"
                src="/resource/gantt_chart/index.html" />
    </div>-->
    
	
</aura:application>