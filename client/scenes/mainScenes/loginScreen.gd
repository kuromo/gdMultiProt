extends Control

@onready var usrInp = $base/margin/vBox/usrNameEdit
@onready var pwdInp = $base/margin/vBox/pwdEdit
@onready var loginBtn = $base/margin/vBox/loginButton

func _on_login_button_pressed():
	if(usrInp.text == "" || pwdInp.text == ""):
		#TODO error
		print("fill form pls")
	else:
		loginBtn.disabled = true
		var usrName = usrInp.text
		var usrPwd = pwdInp.text
		print("try to log in " + usrInp.text)
		Gateway.connectServer(usrInp.text, pwdInp.text)



func _on_create_button_pressed():
	pass # Replace with function body.
