<!-- write>>
* @ jsp : insertNote.jsp
* @ Date : 2018.10.10
* @ Author : 고은아
* @ Desc : 노트 작성을 위해 들어오는 페이지
-->

<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<script src="https://cloud.tinymce.com/stable/tinymce.min.js?apiKey=yaps0ah95j72p1podkonpizywofdvarpwuuzjrfbjm1ysadp"></script>
<script src="${pageContext.request.contextPath}/resources/js/api/textEditer.js"></script>
<script>


</script>
<!-- 등록 전 띄워지는 모달창 -->
<form action="" method="post">
	<div id="publishModal" class="modal fade form-horizontal">
		<div class="modal-dialog noteModalSize">
			<div class="modal-content">
				<div class="modal-body">
					<div class="form-group">
					<br/>
						<input type="hidden" id="selFolderName" value="${note.folderName}">
						<label class="control-label col-sm-2 noteLabels">폴더 </label>
						<select id="folderList" name="folderName" class="form-control notePublish" ></select>
					</div>
					<div class="form-group">
						<input type="hidden" id="selSubjectCode" value="${note.subjectCode}">
						<label class="control-label col-sm-2 noteLabels">주제 </label> 
						<select	id="subjectList" name="subjectCode" class="form-control notePublish"></select>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-2 noteLabels" id="noteLabel">공개<br/>설정</label>
						<input type="hidden" id="selNotePublic" value="${note.notePublic}">
						<input type="radio" name="notePublic" value="1"
							id="noteRadio1"> 전체 공개 <br/>
						<input type="radio" name="notePublic" value="0" > 비공개
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-danger" id="updateNoteBtn">수정하기</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 텍스트 에디터 -->
	<div class="n-container">
	<div class="n-inner">
		<div class="form-group">
			<input id="noteNum" name="noteNum" type="hidden" value="${note.noteNum}">
			<input id="noteTitle" name="noteTitle" type="text" size="158" value="${note.noteTitle}">
		</div>
		<textarea id="noteContent" name="noteContent" rows="20">${note.noteContent}</textarea>
		<input name="image" type="file" id="upload" multiple class="hidden" onchange="">
		<br>
		<div class="col-sm-12 text-right">
			<input type="button" class="btn btn-secondary" value="문자 인식">
			<input type="button" class="btn btn-secondary" value="맞춤법 검사">
		</div>
		<br>
		<div class="col-sm-12 text-center">
			<input id="submitBtn" name="submitBtn" class="btn btn-danger"
				type="button" value="등록" data-toggle="modal"
				data-target="#publishModal">
		</div>
	</div>
	</div>
</form>


