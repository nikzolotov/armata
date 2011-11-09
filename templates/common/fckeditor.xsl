<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="js-loadeditor">
		<script type="text/javascript" src="/admin/js/fckeditor/fckeditor.js"><xsl:comment/></script>
		<script type="text/javascript"><xsl:comment>
			window.onload = function(){
				var textareas = document.getElementsByTagName('textarea');
				
				for( var i = 0; i &lt; textareas.length; i++ ){
					var oFCKeditor = new FCKeditor( textareas[i].name );
					oFCKeditor.BasePath = '/admin/js/fckeditor/';
					oFCKeditor.Height=450;
					oFCKeditor.ReplaceTextarea();					
				}
			}
			//</xsl:comment>
		</script>
	</xsl:template>

	<xsl:template name="js-showeditor">
		<script type="text/javascript" src="/admin/js/fckeditor/fckeditor.js"><xsl:comment/></script>
		<script type="text/javascript"><xsl:comment>
			function showeditor(lnk){
				var oFCKeditor = new FCKeditor( lnk.name );
				oFCKeditor.BasePath = '/admin/js/fckeditor/';
				oFCKeditor.Height=450;
				oFCKeditor.ReplaceTextarea();
				lnk.parentNode.style.display='none';
				return false;
			}
			//</xsl:comment>
		</script>
	</xsl:template>
	
	<xsl:template name="js-preview">
		<script language="JavaScript"><xsl:comment>
			var imagePreview;
			var imagePreviewImage;
			window.onload = function(e)
			{
				imagePreview = document.getElementById('imagePreview');
				imagePreviewImage = document.getElementById('imagePreviewImage');
			}
			function showImage(e, url, width, height)
			{
				//for(i in document) if(!confirm(i)) break;
				var x = e.x ? e.x: e.pageX;
				var y = e.y ? e.y : e.pageY;
				//alert(e.srcElement.nodeName);
				imagePreviewImage.src = url;
				imagePreviewImage.width = width;
				imagePreviewImage.height = height;
				imagePreview.style.left = x - 12 - width/2 &lt; 0 ? 0 : x - 12 - width/2;
				imagePreview.style.top = y - 12 - height/2 &lt; 0 ? 0 : y - 12 - height/2;
				imagePreview.style.display = 'block';
				return false;
			}
			function hideImage()
			{
				imagePreview.style.display='none';
				return false;
			}
		//</xsl:comment></script>
	</xsl:template>
	
</xsl:stylesheet>