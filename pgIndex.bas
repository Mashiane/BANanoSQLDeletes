B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.51
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private SQL As BANanoSQL
	Private body As BANanoElement
	Private BANano As BANano
	Private dummy As UOENowData
	Private elNotif As BANanoElement
	Private elCommand As BANanoElement
	Private elArgs As BANanoElement
End Sub

Sub Init
	'open the db
	SQL.OpenWait("tests","tests")
	'
	'get the body of the page
	body = BANano.GetElement("#body")
	'empty the body
	body.Empty
	'
	'command
	Dim command As UOENowHTML
	command.Initialize("command","label").SetText("Command: ")
	body.Append(command.HTML).Append("<br><br>")
	'
	'arguements
	Dim args As UOENowHTML
	args.Initialize("args","label").SetText("Arguements: ")
	body.Append(args.HTML).Append("<br><br>")
	 
	'results
	Dim notify As UOENowHTML
	notify.Initialize("notify","label").SetText("Notifications:")
	body.Append(notify.HTML).Append("<br><br>")
	'
	'create the insert button
	Dim btn As UOENowHTML
	btn.Initialize("btninserts","button").SetText("Inserts")
	'append insert to the body
	body.Append(btn.HTML)
	'create the select button
	Dim btnSelect As UOENowHTML
	btnSelect.Initialize("btnselect","button").SetText("Select")
	'add select to the body
	body.Append(btnSelect.HTML)
	'deletes
	Dim btnDelete As UOENowHTML
	btnDelete.Initialize("btndelete","button").SetText("Delete All")
	body.Append(btnDelete.HTML)
	' 
	'updates
	Dim btnUpdates As UOENowHTML
	btnUpdates.Initialize("btnupdate","button").SetText("Update All")
	body.Append(btnUpdates.HTML)
	
	'add events to the buttons
	BANano.GetElement("#btninserts").HandleEvents("click", Me, "inserts")
	BANano.GetElement("#btnselect").HandleEvents("click", Me, "selects")
	BANano.GetElement("#btnupdate").HandleEvents("click", Me, "updates")
	BANano.GetElement("#btndelete").HandleEvents("click", Me, "deletes")
	'
	elNotif = BANano.GetElement("#notify")
	elCommand = BANano.GetElement("#command")
	elArgs = BANano.GetElement("#args")
End Sub

'update all
Sub updates
	ClearFirst
	dummy.Initialize
	Dim parentid As String = dummy.Rand_Company_Name
	Dim update_statement As Map = BANanoSQLUtils.UpdateAll("items", CreateMap("parentid":parentid))
	Dim qry As String = update_statement.Get("sql")
	Dim args As List = update_statement.Get("args")
	elCommand.SetText("Command: " & qry)
	elArgs.SetText("Arguements: " & BANano.ToJson(args))
	
	Dim result As List = SQL.ExecuteWait(qry,args)
	elNotif.SetText("Result: " & BANano.ToJson(result))
	
End Sub

'delete all records
Sub Deletes
	ClearFirst
	Dim del_statement As String = BANanoSQLUtils.DeleteAll("items")
	elCommand.SetText("Command: " & del_statement)
	elArgs.SetText("Arguements: ")
	
	Dim result As List = SQL.ExecuteWait(del_statement,Null)
	elNotif.SetText("Result: " & BANano.ToJson(result))
End Sub

'select all records
Sub Selects
	ClearFirst
	'build the select statement
	Dim sel_statement As Map = BANanoSQLUtils.SelectAll("items", Array("*"), Array("id"))
	Dim qry As String = sel_statement.Get("sql")
	Dim args As List = sel_statement.Get("args")
	elCommand.SetText("Command: " & qry)
	elArgs.SetText("Arguements: " & BANano.ToJson(args))
	'
	Dim result As List = SQL.ExecuteWait(qry,Array(args))
	'
	elNotif.SetText("Result: " & BANano.ToJson(result))
End Sub

'insert 10 dummy records to the db
Sub Inserts
	ClearFirst
	'initialize dummy data generator
	dummy.Initialize
	'define structure
	Dim structure As Map = CreateMap()
	structure.Put("id", dummy.DT_FIRST_NAME)
	structure.Put("jsoncontent", dummy.DT_FULL_NAME)
	structure.Put("tabindex", dummy.DT_NUMBER)
	structure.put("parentid", "form")
	'
	Dim records As List
	records = dummy.GetRecordsWithStructure(structure, 10)
	'
	Dim qry As String = BANanoSQLUtils.InsertList("items")
	elCommand.SetText("Command: " & qry)
	elArgs.SetText("Arguements: " & BANano.ToJson(records))
	'
	Dim result As Int = SQL.ExecuteWait(qry, Array(records))
	elNotif.SetText("Result: " & result & " records inserted!")
End Sub


Sub ClearFirst
	elCommand.SetText("Command: ")
	elArgs.SetText("Arguements: ")
	elNotif.SetText("Result: ")
End Sub