note
	description: "{COMMAND_EXECUTOR} object that execute a command in the JSONWireProtocol"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=SELINIUM", "protocol=JSONWireProtocol", "src=https://code.google.com/p/selenium/wiki/JsonWireProtocol#Commands"

class
	COMMAND_EXECUTOR

inherit

	JSON_HELPER

	SE_JSON_WIRE_PROTOCOL_COMMANDS

-- TODO
-- clean and improve the code
-- handle response from the server in a smart way
create
	make

feature -- Initialization

	make (a_host: STRING_32)
		local
			h: LIBCURL_HTTP_CLIENT
		do
			host := a_host
			create h.make
			http_session := h.new_session (a_host)
				--	http_session.set_is_debug (True)
				--	http_session.set_proxy ("127.0.0.1", 8888)
		end

feature -- Status Report

	is_available: BOOLEAN
			-- Is the Seleniun server up and running?
		do
			Result := http_session.is_available
		end

feature -- Commands

	status: SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_status)
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	new_session (capabilities: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_new_session, capabilities)
			if attached resp.header ("Location") as l_location then
				resp := http_new_session (l_location).get ("", context_executor)
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end
		end

	sessions: SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_sessions)
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	retrieve_session (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_session_by_id (session_id))
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	delete_session (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_delete (cmd_session_by_id (cmd_session_by_id (session_id)))
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end
		end

	set_session_timeouts (a_session_id: STRING_32; a_data_timeout: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_session_timeouts (a_session_id), a_data_timeout)
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end
		end

	set_session_timeouts_async_script (a_session_id: STRING_32; a_data_timeout: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_session_timeouts_async_script (a_session_id), a_data_timeout)
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end

		end

	set_session_timeouts_implicit_wait (a_session_id: STRING_32; a_data_timeout: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_session_timeouts_implicit_wait (a_session_id), a_data_timeout)
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end

		end

	retrieve_window_handle (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_session_window_handle (session_id))
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	retrieve_window_handles (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_session_window_handles (session_id))
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	retrieve_url (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_session_url (session_id))
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	navigate_to_url (a_session_id: STRING_32; a_url: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_session_url (a_session_id), a_url)
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end
		end

	forward (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_session_forward (a_session_id), Void)
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end
		end

	back (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_session_back (a_session_id), Void)
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end
		end

	refresh (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_session_refresh (a_session_id), Void)
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end
		end

	execute
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
				-- TODO
		end

	execute_async
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
				-- TODO
		end

	screenshot (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_session_screenshot (session_id))
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	ime_available_engines (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_session_ime_available (session_id))
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	ime_active_engine (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_session_ime_active_engine (session_id))
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	ime_activated (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_session_ime_activated (session_id))
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	ime_deactivate (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_session_ime_deactivate (a_session_id), Void)
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end
		end

	ime_activate (a_session_id: STRING_32; an_engine: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_session_ime_activate (a_session_id), an_engine)
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					Result := build_response (l_body)
				end
			end

		end

feature {NONE} -- Implementation

	execute_get (command_name: STRING_32): HTTP_CLIENT_RESPONSE
		do
			Result := http_session.get (command_name, context_executor)
		end

	execute_post (command_name: STRING_32; data: detachable READABLE_STRING_8): HTTP_CLIENT_RESPONSE
		do
			Result := http_session.post (command_name, context_executor, data)
		end

	execute_delete (command_name: STRING_32): HTTP_CLIENT_RESPONSE
		do
			Result := http_session.delete (command_name, context_executor)
		end

	build_response (a_message: STRING_32): SE_RESPONSE
		do
			create Result.make_empty
			initialize_converters (json)
			if attached {SE_RESPONSE} json.object_from_json (a_message, "SE_RESPONSE") as l_response then
				Result := l_response
			end
			Result.set_json_response (a_message)
		end

	context_executor: HTTP_CLIENT_REQUEST_CONTEXT
			-- request context for each request
		do
			create Result.make
			Result.headers.put ("application/json;charset=UTF-8", "Content-Type")
			Result.headers.put ("application/json;charset=UTF-8", "Accept")
		end

	host: STRING_32

	http_session: HTTP_CLIENT_SESSION

	http_new_session (url: STRING_32): HTTP_CLIENT_SESSION
		local
			h: LIBCURL_HTTP_CLIENT
		do
			create h.make
			Result := h.new_session (url)
				--		Result.set_is_debug (True)
				--		Result.set_proxy ("127.0.0.1", 8888)
		end

end
