extends Control

# UI container nodes
@onready var loginScreen = $base/loginBox
@onready var createScreen = $base/createBox
# login screen nodes
@onready var mailInp = $base/loginBox/mailEdit
@onready var pwdInp = $base/loginBox/pwdEdit
@onready var loginBtn = $base/loginBox/loginButton
@onready var createBtn = $base/loginBox/createButton
# create account screen nodes
@onready var createNameInp = $base/createBox/usrNameEdit
@onready var createMailInp = $base/createBox/mailEdit
@onready var createPwdInp = $base/createBox/pwdEdit
@onready var createPwdRepeatInp = $base/createBox/pwdRepeatEdit
@onready var createConfBtn = $base/createBox/confirmButton
@onready var createBackBtn = $base/createBox/backButton

func _on_login_button_pressed():
	# TESTING skip login
	if($/root/sceneHandler.skipLogin == true):
		$/root/sceneHandler.userVerified()
		return

	
	if(mailInp.text == "" || pwdInp.text == ""):
		#TODO error
		print("fill form pls")
	else:
		loginBtn.disabled = true
		createBtn.disabled = true
		var usrMail = mailInp.text
		var usrPwd = pwdInp.text
		print("try to log in " + usrMail)
		Gateway.connectServer(usrMail, usrPwd, false)


func _on_create_button_pressed():
	loginScreen.hide()
	createScreen.show()


func _on_back_button_pressed():
	loginScreen.show()
	createScreen.hide()


func _on_confirm_button_pressed():
	if createNameInp.text == "":
		print("the entered username is invalid")
	elif createMailInp.text == "":
		print("the entered mail is invalid")
	elif createPwdInp.text == "":
		print("the entered pwd is invalid")
	elif createPwdRepeatInp.text == "":
		print("the entered repeat pwd is invalid")
	elif createPwdInp.text != createPwdRepeatInp.text:
		print("the entered passwords dont match")
#	elif createPwdInp.text.length() < 6:
#		print("the entered pawword ist too short, min 6 chars")
	else:
		print("trying to create account now")
		createConfBtn.disabled = true
		createBackBtn.disabled = true
		
		var usrMail = createMailInp.text
		var usrName = createNameInp.text
		var usrPwd = createPwdInp.text
		Gateway.connectServer(usrMail, usrPwd, true, usrName)


func _on_settings_button_pressed():
	$/root/sceneHandler.openSettings()


func _on_close_button_pressed():
	$/root/sceneHandler.closeApp()
