note
	description: "Summary description for {WSF_PAGE_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_PAGE_CONTROL

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			request := req
			response := res
			initialize_controls
		end

feature -- Access

	request: WSF_REQUEST

	response: WSF_RESPONSE

feature

	initialize_controls
		-- Initalize all the controls, all the event handles must be set in this function.
		deferred
		ensure
			attached control
		end

	process
		-- Function called on page load (not on callback)
		deferred
		end

feature

	execute
		-- Entry Point: If request is a callback, restore control states and execute handle then return new state json.
		-- If request is not a callback. Run process and render the html page
		local
			event: detachable STRING
			control_name: detachable STRING
			states: detachable STRING
			new_states: JSON_OBJECT
			json_parser: JSON_PARSER
		do
			control_name := get_parameter ("control_name")
			event := get_parameter ("event")
			states := get_parameter ("states")
			if attached event and attached control_name and attached control and attached states then
				create json_parser.make_parser (states)
				if attached {JSON_OBJECT} json_parser.parse_json as sp then
					control.load_state (sp)
				end
				control.handle_callback (control_name, event)
				create new_states.make
				control.read_state (new_states)
				response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "application/json"]>>)
				response.put_string (new_states.representation)
			else
				process
				render
			end
		end

	render
		-- Render and send the HTML Page
		local
			data: STRING
			page: WSF_PAGE_RESPONSE
			states: JSON_OBJECT
		do
			create states.make
			control.read_state (states)
			data := "<html><head>"
			data.append ("</head><body>")
			data.append (control.render)
			data.append ("<script type=%"text/javascript%">window.states=")
			data.append (states.representation)
			data.append (";</script>")
			data.append ("<script src=%"//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js%"></script>")
			data.append ("<script src=%"/widget.js%"></script>")
			data.append ("</body></html>")
			create page.make
			page.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"]>>)
			page.set_body (data)
			response.send (page)
		end

	get_parameter (key: STRING): detachable STRING
		-- Read query parameter as string
		local
			value: detachable WSF_VALUE
		do
			Result := VOID
			value := request.query_parameter (key)
			if attached value and then value.is_string  then
				Result := value.as_string.value
			end
		end

feature {NONE}

	control: WSF_CONTROL

end
